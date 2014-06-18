package screens 
{
	import flash.geom.Point;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.LocaleID;
	import flash.globalization.DateTimeStyle;
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
	
	/**
	 * The RTS game screen mode of the game
	 * @author Johan
	 */
	public class MainGameScreen extends BaseScreen 
	{
		private var bgImage:Image;
		private var menuBtn:Button;
		private var continueBtn:Button;
		private var saveBtn:Button;
		private var exitBtn:Button;
		
		private var dayLogic:DayLogic;
		private var economyLogic:EconomyLogic;
		private var mapLogic:MapLogic;
		
		private var dayCountText:TextField;
		private var educationPointsText:TextField;
		
		private var id:int;
		
		private var structureScreen:StructureScreen;
		private var previousStructureScreen:StructureScreen;
		
		private var transferHelpMessage:Quad;
		private var messageField:TextField;
		
		/**
		 * The constructor of MainGameScreen
		 * @param	main
		 */
		public function MainGameScreen(main:ScreenMaster, dayLogic:DayLogic=null, economyLogic:EconomyLogic=null, mapLogic:MapLogic=null, id:int = -1) 
		{
			super(main);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
			this.dayLogic 		= dayLogic 		=== null ? new DayLogic(this) 			: dayLogic;
			this.economyLogic 	= economyLogic 	=== null ? new EconomyLogic(this) 		: economyLogic;
			this.mapLogic 		= mapLogic 		=== null ? new MapLogic(this) 			: mapLogic;
			this.id 			= id 			=== -1	 ? getHighestId() + 1			: id;
		}
		
		/**
		 * Initializes the assets that will be used in this screen. The event listeners will also be set
		 * @param	event
		 */
		public function initialize(event:Event):void {
			//TODO put bars at villages and cities
			menuBtn = new Button(AssetManager.getSingleAsset("ui", "MainGameMenuBtn"));
			setButtonAttributes(stage.stageWidth - menuBtn.width, 0, menuBtn, "Menu");
			menuBtn.addEventListener(Event.TRIGGERED, setMenuOptions);
			
			var quad:Quad = new Quad(stage.stageWidth, menuBtn.height, Config.GAME_MENU_COLOR);
			
			dayCountText = new TextField(50, quad.height, "Day: " + this.getDayLogic().getDayCount(), Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			dayCountText.x = 0;
			dayCountText.y = 0;
			dayCountText.autoSize = TextFieldAutoSize.HORIZONTAL;
			
			educationPointsText = new TextField(200, quad.height, "Education points: " + this.getEconomyLogic().getEducationPoints(), Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			educationPointsText.x = dayCountText.width + Config.SPACING_LEFT_PX;
			educationPointsText.y = 0;
			dayCountText.autoSize = TextFieldAutoSize.HORIZONTAL;
			
			bgImage = new Image(AssetManager.getSingleAsset("ui", "MaingameBg"));
			bgImage.y = menuBtn.height;
			bgImage.addEventListener(TouchEvent.TOUCH, detectMoveTouch);
			
			addChild(bgImage);
			addChild(quad);
			addChild(menuBtn);
			addChild(dayCountText);
			addChild(educationPointsText);
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
			if (target.x > 0) target.x = 0;
			if (target.x < (target.width - stage.stageWidth) * -1) target.x = (target.width - stage.stageWidth) * -1;
			
			target.y += point.y;
			if (target.y > menuBtn.height) target.y = menuBtn.height;
			if (target.y < (target.height - stage.stageHeight) * -1) target.y = (target.height - stage.stageHeight) * -1;
			
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
			
			if (saveBtn == null) saveBtn = new Button(AssetManager.getSingleAsset("ui", "MenuBtn"));
			setButtonAttributes((stage.stageWidth - saveBtn.width) / 2, (stage.stageHeight - saveBtn.height) / 2, saveBtn, "Save");
			
			if (continueBtn == null) continueBtn = new Button(AssetManager.getSingleAsset("ui", "MenuBtn"));
			setButtonAttributes(saveBtn.x, saveBtn.y - continueBtn.height - Config.SPACING_ABOVE_PX, continueBtn, "Continue");
			
			if (exitBtn == null) exitBtn = new Button(AssetManager.getSingleAsset("ui", "MenuBtn"));
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
		
		/**
		 * Gets the day logic class
		 * @return dayLogic
		 */
		public function getDayLogic():DayLogic {
			return this.dayLogic;
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
			enableListeners();
			removeInformationScreen();
		}
		
		/**
		 * Reads and returns the settings file
		 * @return setting
		 */
		public function processSettings():Object {
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
			this.transferHelpMessage = new Quad(stage.stageWidth - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, 20, Config.GAME_MENU_COLOR);
			this.transferHelpMessage.x = (stage.stageWidth - this.transferHelpMessage.width) / 2;
			this.transferHelpMessage.y = 100;
			
			messageField = new TextField(transferHelpMessage.width, 20, message, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			messageField.x = transferHelpMessage.x;
			messageField.y = transferHelpMessage.y;
			messageField.autoSize = TextFieldAutoSize.VERTICAL;
			
			transferHelpMessage.height = messageField.height;
			
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
		
		/**
		 * Adds an additional screen for the structures
		 * @param	structure
		 */
		public function addAdditionalScreen(structure:Object):void {
			disableListeners();
			if (structure.type == "city") {
				structureScreen = new CityDetailScreen(this, structure);
			} else if (structure.type == "village") {
				structureScreen = new VillageDetailScreen(this, structure);
			} else if (structure.type == "hq") {
				structureScreen = new HQDetailScreen(this, structure);
			}
			addChild(structureScreen);
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
						} else {
							//cancel stuff
							cancelTransfer(type);
						}
						enableListeners();
						removeHelpMessage();
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
			//TODO
			//get raw game data put this into a file
			var currentSettings:Object = ArrayUtil.getValuePair(ExternalStorageAO.loadFile(Config.SAVE_SETTINGS_FILE));
			var rawData:String = "{\"id\":"+this.getId()+", \"logic\":"+this.dayLogic.getRawData()+", "+this.economyLogic.getRawData()+", "+this.mapLogic.getRawData()+", \"settings\":{\"duration\":\""+currentSettings.duration+"\", \"difficulty\":\""+currentSettings.difficulty+"\"}}";
			
			//ExternalStorageAO.saveFile(Config.ID_NUMBERS_FILE, this.getId().toString());
			var df:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT, DateTimeStyle.SHORT, DateTimeStyle.SHORT);
			var date:Date = new Date();
			
			var name:String = df.format(date);
			//ExternalStorageAO.saveFile(Config.SAVE_GAME_DIRECTORY + name + ".dat", rawData);
			continueGame(event);
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
	}

}