package screens 
{
	import flash.media.Sound;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.text.TextFieldAutoSize;
	import util.Config;
	import util.AssetManager;
	import util.ArrayUtil;
	/**
	 * ...
	 * @author Johan
	 */
	public class StructureScreen extends BaseScreen 
	{
		private var info:Object;
		private var quad:Quad;
		private var mainGame:MainGameScreen;
		private var exitBtn:Button;
		private var hqBtn:Button;
		private var description:TextField;
		private var structureImage:Image;
		private var title:TextField;
		private var deadText:TextField;
		private var keyValueVector:Vector.<TextField>;
		private var ignoreKeyWords:Array = new Array("Resource consume", "Knowledge consume", "Knowledge gain", "Limit resources", "Limit knowledge", "Population");
		
		public function StructureScreen(mainGame:MainGameScreen, info:Object) 
		{
			super(mainGame.getMain());
			this.info = info;
			this.mainGame = mainGame;
		}
		
		public function initialize(event:Event):void {
			addQuad();
			if (info != null) {
				createScreen();
				addSpecificDetails();
				createButtons();
			}
			
		}
		
		protected function addQuad():void {
			var height:int = (Config.MIN_HEIGHT_ADD_SCREEN <= stage.stageHeight - Config.SPACING_BENEATH_LARGE_PX - Config.SPACING_ABOVE_LARGE_PX) 
				? Config.MIN_HEIGHT_ADD_SCREEN 
				: stage.stageHeight - Config.SPACING_BENEATH_LARGE_PX - Config.SPACING_ABOVE_LARGE_PX;
			quad = new Quad(stage.stageWidth - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, height, Config.GAME_MENU_COLOR);
			quad.x = (stage.stageWidth - quad.width) / 2;
			quad.y = (stage.stageHeight - quad.height) / 2;
		}
		
		public function updateValues(values:Object = null):void {
			for each(var field:TextField in keyValueVector) {
				removeChild(field);
			}
			addSpecificDetails(values);
		}
		
		public function getInfo():Object {
			return this.info;
		}
		
		protected function getQuad():Quad {
			return this.quad;
		}
		
		protected function getMainGame():MainGameScreen {
			return this.mainGame;
		}
		
		protected function getExitBtn():Button {
			return this.exitBtn;
		}
		
		protected function getDescription():TextField {
			return this.description;
		}
		
		protected function createScreen():void {
			structureImage = new Image(AssetManager.getSingleAsset("ui", info.asset));
			structureImage.x = quad.x;
			structureImage.y = quad.y;
				
			var textWidthNextToPicture:int = quad.width - structureImage.width - Config.SPACING_LEFT_PX;
			
			title = new TextField(textWidthNextToPicture, 20, info.name, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_TITLE, Config.TEXT_COLOR_GENERAL, true);
			title.hAlign = HAlign.LEFT;
			title.height = title.textBounds.height + 4;
			var descriptionHeight:int = structureImage.height - title.height;
			
			title.x = quad.x + structureImage.width + Config.SPACING_LEFT_PX;
			title.y = quad.y + Config.SPACING_ABOVE_PX;
			
			description = new TextField(textWidthNextToPicture, descriptionHeight, info.description, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			description.autoScale = true;
			description.hAlign = HAlign.LEFT;
			description.vAlign = VAlign.TOP;
			description.x = structureImage.x + structureImage.width + Config.SPACING_LEFT_PX;
			description.y = title.y + title.height;
			
			
			
			addChild(quad);
			addChild(structureImage);
			addChild(title);
			addChild(description);
		}
		
		protected function addSpecificDetails(values:Object = null):void {
			var data:Object = values == null ? mainGame.getEconomyLogic().getValuesByStructureName(info.name) : values;
			if (data == null && this.info.type != "hq") createDeadText();		//hq can't die
			else {
				var textHeight:int = 20;
				var textHeightBase:int = description.y + description.height + Config.SPACING_ABOVE_PX;
				var i:int = 1;
				keyValueVector = new Vector.<TextField>();
				for (var key:String in data) {
					if (!ArrayUtil.inArray(ignoreKeyWords, key)) {
						var keyField:TextField = new TextField(structureImage.width, textHeight, key + ":", Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL, true);
						keyField.x = quad.x + Config.SPACING_LEFT_PX;
						keyField.height = Config.TEXT_SIZE_GENERAL + 4;
						keyField.autoSize = TextFieldAutoSize.HORIZONTAL;
						keyField.y = (i * keyField.height) + textHeightBase;
						
						keyValueVector.push(keyField);
						addChild(keyField);
						
						setValueFieldForKey(data, key, keyField);
						
						i++;
					}
				}
			}
		}
		
		protected function createButtons():void {
			exitBtn = new Button(AssetManager.getSingleAsset("ui", "SettingsChoiceRedBtn"));
			setButtonAttributes(quad.x + Config.SPACING_LEFT_PX, (quad.y + quad.height) - exitBtn.height - Config.SPACING_BENEATH_PX, exitBtn, "Exit");
			exitBtn.addEventListener(Event.TRIGGERED, mainGame.removeAdditionalScreen);
			
			if (!(this is HQDetailScreen)) {
				hqBtn = new Button(AssetManager.getSingleAsset("ui", "SettingsChoiceRedBtn"));
				setButtonAttributes(exitBtn.x + exitBtn.width + Config.SPACING_LEFT_PX, exitBtn.y, hqBtn, "Buy");
				hqBtn.addEventListener(Event.TRIGGERED, toHQ);
				addChild(hqBtn);
			}
			
			addChild(exitBtn);
		}
		
		protected function getHqButton():Button {
			return this.hqBtn;
		}
		
		private function createDeadText():void {
			if (getChildIndex(deadText) < 0) {
				createButtons();
				deadText = new TextField(quad.width - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, exitBtn.y - Config.SPACING_BENEATH_PX - (description.y + description.height), Config.DEAD_TEXT, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
				deadText.x = quad.x + Config.SPACING_LEFT_PX;
				deadText.y = description.y + description.height + Config.SPACING_ABOVE_PX;
				deadText.hAlign = HAlign.LEFT;
				addChild(deadText);
			}
		}
		
		private function setValueFieldForKey(data:Object, key:String, keyField:TextField):void {
			var valueField:TextField = new TextField(quad.width - structureImage.width - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, keyField.height, "", Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			valueField.x = keyField.x + Config.SPACING_LEFT_PX + keyField.width;
			valueField.y = keyField.y;
			valueField.hAlign = HAlign.LEFT;
			if (key == "Spread rate") {
				valueField.text = new Number(data[key]).toFixed(2) + "%";
			} else if (key == "Infected") {
				valueField.text = new Number(this.getMainGame().getEconomyLogic().getInfectedPercentageByName(info.name).toString()).toFixed() + "%";
			} else if (key == "Resources") {
				valueField.text = new Number(data[key]).toFixed();
				//addIcon(valueField, ResourcesIcon);
			} else if (key == "Knowledge") {
				valueField.text = new Number(data[key]).toFixed(1);
				//addIcon(valueField, KnowledgeIcon);
			}
			keyValueVector.push(valueField);
			addChild(valueField);
		}
		
		private function toHQ(event:Event):void {
			var sound:Sound = AssetManager.getAudioAsset(AssetManager.MenuForwardSound);
			sound.play();
			this.getMainGame().removeAdditionalScreen(event);
			this.getMainGame().addAdditionalScreen(this.getMainGame().getMapLogic().getStructure("Hospital"));
		}
		
		private function addIcon(valueField:TextField, asset:String):void {
			
		}
	}

}