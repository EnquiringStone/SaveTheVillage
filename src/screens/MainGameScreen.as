package screens 
{
	import flash.geom.Point;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.LocaleID;
	import flash.globalization.DateTimeStyle;
	import flash.media.Sound;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import util.AssetManager;
	import util.Config;
	import util.ArrayUtil;
	import ao.ExternalStorageAO;
	import gamelogic.DayLogic;
	import gamelogic.EconomyLogic;
	import gamelogic.MapLogic;
	import gamelogic.RandomEventLogic;
	import screens.RandomEventDetailScreen;
	
	/**
	 * The RTS game screen mode of the game
	 * @author Johan
	 */
	public class MainGameScreen extends BaseScreen 
	{
		private var quad:Quad;
		private var bgImage:Image;
		private var menuBtn:Button;
		private var continueBtn:Button;
		private var saveBtn:Button;
		private var exitBtn:Button;
		
		private var dayLogic:DayLogic;
		private var economyLogic:EconomyLogic;
		private var mapLogic:MapLogic;
		private var randomEventLogic:RandomEventLogic;
		
		private var dayCountText:TextField;
		private var educationPointsText:TextField;
		
		private var id:int;
		private var saveCounter:int;
		
		private var structureScreen:StructureScreen;
		private var previousStructureScreen:StructureScreen;
		
		private var transferHelpMessage:Image;
		private var messageField:TextField;
		
		private var infectedBars:Object = new Object();
		private var resourcesBars:Object = new Object();
		private var knowledgeBars:Object = new Object();
		
		private var randomEventScreen:RandomEventDetailScreen;
		
		private var settings:Object;
		
		/**
		 * The constructor of MainGameScreen
		 * @param	main
		 */
		public function MainGameScreen(main:ScreenMaster, dayLogic:DayLogic=null, economyLogic:EconomyLogic=null, mapLogic:MapLogic=null, randomEventLogic:RandomEventLogic=null, id:int = -1, saveCounter:int = -1, settings:Object = null) 
		{
			super(main);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
			
			this.dayLogic 			= dayLogic 			== null ? new DayLogic(this) 			: dayLogic;
			this.economyLogic 		= economyLogic 		== null ? new EconomyLogic(this) 		: economyLogic;
			this.mapLogic 			= mapLogic 			== null ? new MapLogic(this) 			: mapLogic;
			this.randomEventLogic 	= randomEventLogic 	== null ? new RandomEventLogic(this) 	: randomEventLogic;
			this.id 				= id 				== -1	? getHighestId() + 1			: id;
			this.saveCounter 		= saveCounter 		== -1 	? 0 							: saveCounter;
			this.settings = settings;
		}
		
		/**
		 * Initializes the assets that will be used in this screen. The event listeners will also be set
		 * @param	event
		 */
		public function initialize(event:Event):void {
			menuBtn = new Button(AssetManager.getSingleAsset("ui", "MainGameMenuBtn"));
			setButtonAttributes(stage.stageWidth - menuBtn.width, 0, menuBtn, "Menu");
			menuBtn.addEventListener(Event.TRIGGERED, setMenuOptions);
			
			quad = new Quad(stage.stageWidth, menuBtn.height, 0x565656);
			
			dayCountText = new TextField(50, quad.height, "Day: " + this.getDayLogic().getDayCount(), Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			dayCountText.x = 0;
			dayCountText.y = 0;
			dayCountText.autoSize = TextFieldAutoSize.HORIZONTAL;
			
			educationPointsText = new TextField(200, quad.height, "Education points: " + this.getEconomyLogic().getEducationPoints(), Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			educationPointsText.x = dayCountText.width + Config.SPACING_LEFT_PX;
			educationPointsText.y = 0;
			dayCountText.autoSize = TextFieldAutoSize.HORIZONTAL;
			
			bgImage = new Image(AssetManager.getSingleAsset("ui", "MaingameBg"));
			bgImage.y = menuBtn.height
			bgImage.addEventListener(TouchEvent.TOUCH, detectMoveTouch);
			
			if (stage.stageHeight > bgImage.height || stage.stageWidth > bgImage.width) {
				addAdditionalBG(0, bgImage.height);
			}

			addChild(bgImage);
			addChild(quad);
			addChild(menuBtn);
			addChild(dayCountText);
			addChild(educationPointsText);
			
			addBarsToStructures();
		}
		
		/**
		 * Detects whether the user touches the background
		 * @param	event
		 */
		public function detectMoveTouch(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);
			var target:Image = event.target as Image;
			if (touch != null) {
				if (touch.phase == TouchPhase.MOVED) {
					moveImageByTouch(touch, target);
				} else if (touch.phase == TouchPhase.BEGAN) {
					var sound:Sound = AssetManager.getAudioAsset(AssetManager.MapClickSound);
					sound.play();
					var structure:Object = this.mapLogic.isStructure(touch.getLocation(this), new Point(bgImage.x, bgImage.y));
					if (structure != null) {
						addAdditionalScreen(structure);
					}
				}
			}
		}
		
		/**
		 * Moves the background image by the users touch
		 * @param	touch
		 * @param	target
		 */
		public function moveImageByTouch(touch:Touch, target:Image):void {
			var point:Point = touch.getMovement(this);
			
			target.x += point.x;
			target.y += point.y;
			updateBarLocations(point, target);
			
			if (target.x > 0) target.x = 0;
			if (target.x < (target.width - stage.stageWidth) * -1) target.x = (target.width - stage.stageWidth) * -1;
			
			if (target.y > menuBtn.height) target.y = menuBtn.height;
			if (target.y < (target.height - stage.stageHeight) * -1) {
				target.y = (target.height - stage.stageHeight) * -1;
				if (bgImage.height <= stage.stageHeight) {
					bgImage.y = menuBtn.height;
				}
			}
			
			menuBtn.visible = true;
			
		}
		
		/**
		 * Sets the menu options for the menu button. Initializes the choices the player can choose from and its event listeners
		 * @param	event
		 */
		public function setMenuOptions(event:Event):void {
			bgImage.removeEventListener(TouchEvent.TOUCH, detectMoveTouch);
			menuBtn.removeEventListener(Event.TRIGGERED, setMenuOptions);
			this.dayLogic.getTimer().stop();
			
			if (saveBtn == null) saveBtn = new Button(AssetManager.getSingleAsset("ui", "SaveBtn"));
			setButtonAttributes((stage.stageWidth - saveBtn.width) / 2, (stage.stageHeight - saveBtn.height) / 2, saveBtn, "Save");
			
			if (continueBtn == null) continueBtn = new Button(AssetManager.getSingleAsset("ui", "PlayBtn"));
			setButtonAttributes(saveBtn.x, saveBtn.y - continueBtn.height - Config.SPACING_ABOVE_PX, continueBtn, "Continue");
			
			if (exitBtn == null) exitBtn = new Button(AssetManager.getSingleAsset("ui", "ExitBtn"));
			setButtonAttributes(saveBtn.x, saveBtn.y + saveBtn.height + Config.SPACING_ABOVE_PX, exitBtn, "Exit");
			
			addChild(saveBtn);
			addChild(continueBtn);
			addChild(exitBtn);
			
			saveBtn.addEventListener(Event.TRIGGERED, saveGameState);
			continueBtn.addEventListener(Event.TRIGGERED, continueGame);
			exitBtn.addEventListener(Event.TRIGGERED, toStart);
		}
		
		/**
		 * Gets the id for this playthrough. Is being used for save/load games
		 * @return
		 */
		public function getId():int {
			return this.id;
		}
		
		/**
		 * Gets the economy logic class
		 * @return economyLogic
		 */
		public function getEconomyLogic():EconomyLogic {
			return this.economyLogic;
		}
		
		/**
		 * Gets the map logic class
		 * @return mapLogic
		 */
		public function getMapLogic():MapLogic {
			return this.mapLogic;
		}
		
		public function getSaveButton():Button {
			return this.saveBtn;
		}
		
		public function getQuad():Quad {
			return this.quad;
		}
		
		/**
		 * Gets the day logic class
		 * @return dayLogic
		 */
		public function getDayLogic():DayLogic {
			return this.dayLogic;
		}
		
		public function getRandomEventLogic():RandomEventLogic {
			return this.randomEventLogic;
		}
		
		public function getEducationPointsText():TextField {
			return this.educationPointsText;
		}
		
		public function getDayCountText():TextField {
			return this.dayCountText;
		}
		
		/**
		 * Returns the structure screen
		 * @return structureScreen
		 */
		public function getStructureScreen():StructureScreen {
			return this.structureScreen;
		}
		
		/**
		 * Returns the previous structure screen that was visible
		 * @return
		 */
		public function getPreviousStructureScreen():StructureScreen {
			return this.previousStructureScreen;
		}
		
		/**
		 * Returns the background image
		 * @return bgImage
		 */
		public function getBGImage():Image {
			return this.bgImage;
		}
		
		public function getMenuBtn():Button {
			return this.menuBtn;
		}
		
		/**
		 * Disables the basic listeners
		 */
		public function disableListeners():void {
			bgImage.removeEventListener(TouchEvent.TOUCH, detectMoveTouch);
			menuBtn.removeEventListener(Event.TRIGGERED, setMenuOptions);
		}
		
		/**
		 * Enables the basic listeners
		 */
		public function enableListeners():void {
			bgImage.addEventListener(TouchEvent.TOUCH, detectMoveTouch);
			menuBtn.addEventListener(Event.TRIGGERED, setMenuOptions);
		}
		
		/**
		 * Removes the additional screen that depicts the structure
		 * @param	event
		 */
		public function removeAdditionalScreen(event:Event):void {
			var sound:Sound = AssetManager.getAudioAsset(AssetManager.MenuBackwardsSound);
			sound.play();
			enableListeners();
			removeInformationScreen();
			quad.visible = true;
			menuBtn.visible = true;
			dayCountText.visible = true;
			educationPointsText.visible = true;
		}
		
		/**
		 * Reads and returns the settings file
		 * @return setting
		 */
		public function processSettings():Object {
			if (this.settings != null) return settings;
			var dataString:String = ExternalStorageAO.loadFile(Config.SAVE_SETTINGS_FILE);
			if (dataString == null || dataString == "") return ""; //file doesn't exist (not yet changed the settings)
			var dataObject:Object = ArrayUtil.getValuePair(dataString);
			return dataObject;
		}
		
		/**
		 * Updates the field that shows what day it is
		 */
		public function updateDayField():void {
			dayCountText.text = "Day: " + this.getDayLogic().getDayCount();
		}
		
		/**
		 * Updates the field that shows the education points
		 */
		public function updateEducationPointsField():void {
			educationPointsText.text = "Education points: " + this.getEconomyLogic().getEducationPoints();
		}
		
		/**
		 * Calls the method selectTarget and makes sure it's for knowledge
		 * @param	event
		 */
		public function selectTargetKnowledge(event:TouchEvent):void {
			selectTarget(event, "knowledge");
		}
		
		/**
		 * Calls the method selectTarget and makes sure it's for resources
		 * @param	event
		 */
		public function selectTargetResources(event:TouchEvent):void {
			selectTarget(event, "resources");
		}
		
		/**
		 * Removes the structure screen if exists
		 */
		public function removeInformationScreen():void {
			if (structureScreen != null) {
				this.removeChild(structureScreen);
				previousStructureScreen = structureScreen;
				structureScreen = null;
			}
		}
		
		/**
		 * Adds a help message on the screen with the give message
		 * @param	message
		 */
		public function addHelpMessage(message:String):void {
			this.transferHelpMessage = new Image(AssetManager.getSingleAsset("ui", "HelpMessageScreen"));
			this.transferHelpMessage.x = (stage.stageWidth - this.transferHelpMessage.width) / 2;
			this.transferHelpMessage.y = 10;
			
			messageField = new TextField(transferHelpMessage.width, transferHelpMessage.height, message, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			messageField.x = transferHelpMessage.x;
			messageField.y = transferHelpMessage.y;
			messageField.autoScale = true;
			
			addChild(transferHelpMessage);
			addChild(messageField);
		}
		
		/**
		 * Removes the help message
		 */
		public function removeHelpMessage():void {
			if (messageField != null && transferHelpMessage != null) {
				removeChild(transferHelpMessage);
				removeChild(messageField);
				transferHelpMessage = null;
				messageField = null;
			}
		}
		
		public function createRandomEventMessage(data:Object):void {
			if (this.randomEventScreen == null) {
				this.randomEventScreen = new RandomEventDetailScreen(data, this);
			}
			disableListeners();
			this.dayLogic.getTimer().stop();
			addChild(randomEventScreen);
		}
		
		public function removeRandomEventMessage():void {
			removeChild(randomEventScreen);
			this.randomEventScreen = null;
			this.dayLogic.getTimer().start();
			enableListeners();
			updateBars();
		}
		
		/**
		 * Adds an additional screen for the structures
		 * @param	structure
		 */
		public function addAdditionalScreen(structure:Object):void {
			disableListeners();
			quad.visible = false;
			menuBtn.visible = false;
			dayCountText.visible = false;
			educationPointsText.visible = false;
			if (structure.type == "city") {
				structureScreen = new CityDetailScreen(this, structure);
			} else if (structure.type == "village") {
				structureScreen = new VillageDetailScreen(this, structure);
			} else if (structure.type == "hq") {
				structureScreen = new HQDetailScreen(this, structure);
			}
			addChild(structureScreen);
		}
		
		public function updateBars(name:String = ""):void {
			if (name == "") {
				for (var name:String in infectedBars) {
					updateBarValues(name);
				}
			} else {
				updateBarValues(name);
			}
		}
		
		private function updateBarValues(name:String):void {
			var infected:Number = this.economyLogic.getInfectedPercentageByName(name);
			var scaleYInfected:Number = (infected / 100) * -1;
			infectedBars[name]["colored"].scaleY = scaleYInfected >= -1 ? scaleYInfected : -1;
			
			var resources:Number = this.economyLogic.getResourcesPercentageByName(name);
			var scaleYResources:Number = (resources / 100) * -1;
			resourcesBars[name]["colored"].scaleY = scaleYResources >= -1 ? scaleYResources : -1;
		}
		
		private function updateBarLocations(movePoint:Point, target:Image):void {
			for (var name:String in infectedBars) {
				updateBarX(name, movePoint, target);
				updareBarY(name, movePoint, target);
			}
		}
		
		private function updateBarX(name:String, movePoint:Point, target:Image):void {
			var object:Object = Config.STRUCTURE_POSITIONS;
			infectedBars[name]["standard"].x += movePoint.x;
			resourcesBars[name]["standard"].x += movePoint.x;
			if (target.x > 0) {
				if (object[name].type == "village") {
					infectedBars[name]["standard"].x = object[name].x - (Config.VILLAGE_WIDTH / 2) - Config.SPACING_RIGHT_PX - infectedBars[name]["standard"].width;
					resourcesBars[name]["standard"].x = object[name].x + (Config.VILLAGE_WIDTH / 2) + Config.SPACING_LEFT_PX;
				} else if (object[name].type == "city") {
					infectedBars[name]["standard"].x = object[name].x - (Config.CITY_WIDTH / 2) - Config.SPACING_RIGHT_PX - infectedBars[name]["standard"].width;
					resourcesBars[name]["standard"].x = object[name].x + (Config.CITY_WIDTH / 2) + Config.SPACING_LEFT_PX;
				}
			} if (target.x < (target.width - stage.stageWidth) * -1) {
				if (object[name].type == "village") {
					infectedBars[name]["standard"].x = object[name].x - (Config.VILLAGE_WIDTH / 2) - Config.SPACING_RIGHT_PX - infectedBars[name]["standard"].width - (bgImage.x * -1);
					resourcesBars[name]["standard"].x = object[name].x + (Config.VILLAGE_WIDTH / 2) + Config.SPACING_LEFT_PX - (bgImage.x * -1);
				} else if (object[name].type == "city") {
					infectedBars[name]["standard"].x = object[name].x - (Config.CITY_WIDTH / 2) - Config.SPACING_RIGHT_PX - infectedBars[name]["standard"].width - (bgImage.x * -1);
					resourcesBars[name]["standard"].x = object[name].x + (Config.CITY_WIDTH / 2) + Config.SPACING_LEFT_PX - (bgImage.x * -1);
				}
			}
			infectedBars[name]["colored"].x = infectedBars[name]["standard"].x;
			resourcesBars[name]["colored"].x = resourcesBars[name]["standard"].x;
		}
		
		private function updareBarY(name:String, movePoint:Point, target:Image):void {
			var object:Object = Config.STRUCTURE_POSITIONS;
			infectedBars[name]["standard"].y += movePoint.y;
			resourcesBars[name]["standard"].y += movePoint.y;
			if (target.y > menuBtn.height) {
				if (object[name].type == "village") {
					infectedBars[name]["standard"].y = object[name].y - (Config.VILLAGE_HEIGHT / 2) - (bgImage.y * -1);
					resourcesBars[name]["standard"].y = object[name].y - (Config.VILLAGE_HEIGHT / 2) - (bgImage.y * -1);
				} else if (object[name].type == "city") {
					infectedBars[name]["standard"].y = object[name].y - (Config.CITY_HEIGHT / 2) - (bgImage.y * -1);
					resourcesBars[name]["standard"].y = object[name].y - (Config.CITY_HEIGHT / 2) - (bgImage.y * -1);
				}
			} if (target.y < (target.height - stage.stageHeight) * -1) {
				if (object[name].type == "village") {
					infectedBars[name]["standard"].y = object[name].y - (Config.VILLAGE_HEIGHT / 2) - (bgImage.y * -1);
					resourcesBars[name]["standard"].y = object[name].y - (Config.VILLAGE_HEIGHT / 2) - (bgImage.y * -1);
				} else if (object[name].type == "city") {
					infectedBars[name]["standard"].y = object[name].y - (Config.CITY_HEIGHT / 2) - (bgImage.y * -1);
					resourcesBars[name]["standard"].y = object[name].y - (Config.CITY_HEIGHT / 2) - (bgImage.y * -1);
				}
			}
			infectedBars[name]["colored"].y = infectedBars[name]["standard"].y + infectedBars[name]["standard"].height;
			resourcesBars[name]["colored"].y = resourcesBars[name]["standard"].y + infectedBars[name]["standard"].height;
		}
		
		private function addBarsToStructures():void {
			var object:Object = Config.STRUCTURE_POSITIONS;
			for (var name:String in object) {
				if (object[name].type != "hq") {
					addInfectedBar(object[name]);
					addResourcesBar(object[name]);
					if (object[name].type == "city") {
						//addKnowledgeBar(object[name]);
					}
				}
			}
			updateBars();
		}
		
		private function addInfectedBar(object:Object):void {
			var bar:Image = new Image(AssetManager.getSingleAsset("ui", "BarVertical"));
			if (object.type == "village") {
				bar.x = object.x - (Config.VILLAGE_WIDTH / 2) - Config.SPACING_RIGHT_PX - bar.width;
				bar.y = object.y - (Config.VILLAGE_HEIGHT / 2);
			} else if (object.type == "city") {
				bar.x = object.x - (Config.CITY_WIDTH / 2) - Config.SPACING_RIGHT_PX - bar.width;
				bar.y = object.y - (Config.CITY_HEIGHT / 2);
			}
			
			var coloredBar:Image = new Image(AssetManager.getSingleAsset("ui", "BarVerticalRed"));
			coloredBar.x = bar.x;
			coloredBar.y = bar.y + bar.height;
			
			infectedBars[object.name] = { "standard": bar, "colored": coloredBar };
			addChild(coloredBar);
			addChild(bar);
		}
		
		private function addResourcesBar(object:Object):void {
			var bar:Image = new Image(AssetManager.getSingleAsset("ui", "BarVertical"));
			if (object.type == "village") {
				bar.x = object.x + (Config.VILLAGE_WIDTH / 2) + Config.SPACING_LEFT_PX;
				bar.y = object.y - (Config.VILLAGE_HEIGHT / 2);
			} else if (object.type == "city") {
				bar.x = object.x + (Config.CITY_WIDTH / 2) + Config.SPACING_LEFT_PX;
				bar.y = object.y - (Config.CITY_HEIGHT / 2);
			}
			
			var coloredBar:Image = new Image(AssetManager.getSingleAsset("ui", "BarVerticalYellow"));
			coloredBar.x = bar.x;
			coloredBar.y = bar.y + bar.height;
			resourcesBars[object.name] = { "standard": bar, "colored": coloredBar };
			addChild(coloredBar);
			addChild(bar);
		}
		
		private function addKnowledgeBar(object:Object):void {
			var bar:Image = new Image(AssetManager.getSingleAsset("ui", "BarHorizontal"));
			bar.x = object.x - (bar.width / 2);
			bar.y = object.y + (Config.CITY_HEIGHT / 2) + Config.SPACING_ABOVE_PX;
			knowledgeBars[object.name] = { "standard":bar, "colored": null };
			addChild(bar);
		}
		
		/**
		 * Creates the logic for selecting where the resource/knowledge has to go to
		 * @param	event
		 * @param	type
		 */
		private function selectTarget(event:TouchEvent, type:String):void {
			var touch:Touch = event.getTouch(this);
			var target:Image = event.target as Image;
			if (touch != null) {
				if (touch.phase == TouchPhase.MOVED) {
					moveImageByTouch(touch, target);
				}
				if (touch.phase == TouchPhase.ENDED) {
					var structure:Object = this.mapLogic.isStructure(touch.getLocation(this), new Point(bgImage.x, bgImage.y));
					if (structure != null) {
						if (structure.type != "hq") {
							if (type == "knowledge") {
								this.getEconomyLogic().addKnowledge(structure.name);
								bgImage.removeEventListener(TouchEvent.TOUCH, selectTargetKnowledge);
							}
							else if(type == "resources") {
								this.getEconomyLogic().addResources(structure.name);
								bgImage.removeEventListener(TouchEvent.TOUCH, selectTargetResources);
							}
							updateBars(structure.name);
						} else {
							cancelTransfer(type);
						}
						enableListeners();
						removeHelpMessage();
						quad.visible = true;
						menuBtn.visible = true;
						dayCountText.visible = true;
						educationPointsText.visible = true;
						if(!this.dayLogic.getTimer().running) this.dayLogic.getTimer().start();
					}
				}
			}
		}
		
		private function cancelTransfer(type:String):void {
			if (previousStructureScreen.getInfo().type == "hq") {
				if (type == "knowledge") {
					this.getEconomyLogic().addEducationPoints(Config.DEFAULT_VALUE_KNOWLEDGE);
					bgImage.removeEventListener(TouchEvent.TOUCH, selectTargetKnowledge);
				} else if (type == "resources") {
					this.getEconomyLogic().addEducationPoints(Config.DEFAULT_VALUE_RESOURCES);
					bgImage.removeEventListener(TouchEvent.TOUCH, selectTargetResources);
				}
				updateEducationPointsField();
			} else if (previousStructureScreen.getInfo().type == "city") {
				if (type == "knowledge") {
					this.getEconomyLogic().addKnowledge(previousStructureScreen.getInfo().name);
					bgImage.removeEventListener(TouchEvent.TOUCH, selectTargetKnowledge);
				} else if (type == "resources") {
					this.getEconomyLogic().addResources(previousStructureScreen.getInfo().name);
					bgImage.removeEventListener(TouchEvent.TOUCH, selectTargetResources);
				}
			}
			
		}
		
		/**
		 * Will save the state of the game onto the external drive of the phone. It uses the datetime as its name
		 * @param	event
		 */
		private function saveGameState(event:Event):void {
			this.saveCounter += 1;
			var currentSettings:Object = ArrayUtil.getValuePair(ExternalStorageAO.loadFile(Config.SAVE_SETTINGS_FILE));
			var rawData:String = "{\"id\":"+this.getId()+", \"saveCounter\": "+this.saveCounter+", \"logic\": {"+this.dayLogic.getRawData()+", "+this.economyLogic.getRawData()+", "+this.mapLogic.getRawData()+", "+this.randomEventLogic.getRawData()+"}, \"settings\":{\"duration\":\""+currentSettings.duration+"\", \"difficulty\":\""+currentSettings.difficulty+"\"}}";
			ExternalStorageAO.saveFile(Config.ID_NUMBERS_FILE, this.getId().toString());
			
			var name:String = "SaveGame" + this.getId() + "(" + this.saveCounter + ")";
			ExternalStorageAO.saveFileToDirectory(name + ".txt", Config.SAVE_GAME_DIRECTORY, rawData);
			toStart();
		}
		
		/**
		 * Continues the game, resetting the event listeners and removing the menu options
		 * @param	event
		 */
		private function continueGame(event:Event):void {
			saveBtn.removeEventListener(Event.TRIGGERED, saveGameState);
			continueBtn.removeEventListener(Event.TRIGGERED, continueGame);
			exitBtn.removeEventListener(Event.TRIGGERED, toStart);
			
			removeChild(saveBtn);
			removeChild(continueBtn);
			removeChild(exitBtn);
			
			menuBtn.addEventListener(Event.TRIGGERED, setMenuOptions);
			bgImage.addEventListener(TouchEvent.TOUCH, detectMoveTouch);
			this.dayLogic.getTimer().start();
		}
		
		/**
		 * Returns the highest id
		 * @return id
		 */
		private function getHighestId():Number {
			var number:String = ExternalStorageAO.loadFile(Config.ID_NUMBERS_FILE);
			if (number != null && number != "") {
				return parseInt(number);
			}
			return 0;
		}
		
		private function addAdditionalBG(x:Number = 0, y:Number = 0):void {
			var image:Image = new Image(AssetManager.getSingleAsset("ui", "ExtraGameBG"));
			image.x = x;
			image.y = y;
			addChild(image);
			if (stage.stageWidth > image.width + x) addAdditionalBG(image.width + x);
			if (stage.stageHeight > image.height + y) addAdditionalBG(image.height + y);
			return;
		}
	}

}