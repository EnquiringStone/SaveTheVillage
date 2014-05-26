package screens 
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
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
		private var description:TextField;
		private var structureImage:Image;
		private var title:TextField;
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
		
		public function updateValues(values:Object):void {
			for each(var field:TextField in keyValueVector) {
				removeChild(field);
			}
			addSpecificDetails(values);
		}
		
		protected function getInfo():Object {
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
			var descriptionHeight:int = structureImage.height - title.height;
			
			title.x = quad.x + structureImage.width + Config.SPACING_LEFT_PX;
			title.y = quad.y + Config.SPACING_ABOVE_PX;
			
			description = new TextField(textWidthNextToPicture, descriptionHeight, info.description, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			description.autoScale = true;
			description.hAlign = HAlign.LEFT;;
			description.x = structureImage.x + structureImage.width + Config.SPACING_LEFT_PX;
			description.y = title.y + title.height;
			
			exitBtn = new Button(AssetManager.getSingleAsset("ui", "SettingsChoiceBtn"));
			setButtonAttributes(quad.x + Config.SPACING_LEFT_PX, (quad.y + quad.height) - exitBtn.height - Config.SPACING_BENEATH_PX, exitBtn, "Exit");
			exitBtn.addEventListener(Event.TRIGGERED, mainGame.removeAdditionalScreen);
			
			addChild(quad);
			addChild(structureImage);
			addChild(title);
			addChild(description);
			addChild(exitBtn);
		}
		
		protected function addSpecificDetails(values:Object = null):void {
			var data:Object = values == null ? mainGame.getEconomyLogic().getValuesByStructureName(info.name) : values;
			if (data == null) createDeadText();
			else {
				var textHeight:int = 20;
				var textHeightBase:int = description.y + description.height + Config.SPACING_ABOVE_PX;
				var i:int = 1;
				keyValueVector = new Vector.<TextField>();
				for (var key:String in data) {
					if (!ArrayUtil.inArray(ignoreKeyWords, key)) {
						var unit:String = getUnitByKey(key);
						var keyField:TextField = new TextField(structureImage.width, textHeight, key + ":", Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL, true);
						keyField.x = quad.x + Config.SPACING_LEFT_PX;
						keyField.y = (i * textHeight) + textHeightBase;
						keyField.hAlign = HAlign.RIGHT;
						
						var valueField:TextField = new TextField(quad.width - structureImage.width - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, textHeight, data[key] + unit, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
						valueField.x = keyField.x + Config.SPACING_LEFT_PX + keyField.width;
						valueField.y = keyField.y;
						valueField.hAlign = HAlign.LEFT;
						
						keyValueVector.push(keyField, valueField);
						
						addChild(keyField);
						addChild(valueField);
						i++;
					}
				}
			}
		}
		
		private function createDeadText():void {
			var deadText:TextField = new TextField(quad.width - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, exitBtn.y - Config.SPACING_BENEATH_PX - (description.y + description.height), Config.DEAD_TEXT, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			deadText.x = quad.x + Config.SPACING_LEFT_PX;
			deadText.y = description.y + description.height + Config.SPACING_ABOVE_PX;
			deadText.hAlign = HAlign.LEFT;
			addChild(deadText);
		}
		
		private function getUnitByKey(key:String):String {
			var unit:String = "";
			if (key == "Infection rate") {
				unit = "%";
			} else if (key == "Infected") {
				unit = " People"
			} else if (key == "Resources") {
				unit = "";
			} else if (key == "Knowledge") {
				unit = ""
			}
			return unit;
		}
	}

}