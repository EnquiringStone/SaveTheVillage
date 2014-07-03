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
		private var mainGame:MainGameScreen;
		private var structureBackground:Image;
		private var exitBtn:Button;
		private var infoField:Image;
		private var dataField:Image;
		private var buyBtn:Button;
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
			addBackground();
			addExitBtn();
		}
		
		public function updateValues(values:Object = null):void {
			for each(var field:TextField in keyValueVector) {
				removeChild(field);
			}
			addSpecificDetails(values);
		}
		
		public function disableListeners():void {
			if (exitBtn != null) {
				exitBtn.removeEventListener(Event.TRIGGERED, mainGame.removeAdditionalScreen);
			} if (buyBtn != null) {
				buyBtn.removeEventListener(Event.TRIGGERED, toHQ);
			}
		}
		
		public function enableListeners():void {
			if (exitBtn != null) {
				exitBtn.addEventListener(Event.TRIGGERED, mainGame.removeAdditionalScreen);
			} if (buyBtn != null) {
				buyBtn.addEventListener(Event.TRIGGERED, toHQ);
			}
		}
		
		public function getInfo():Object {
			return this.info;
		}
		
		public function getMainGame():MainGameScreen {
			return this.mainGame;
		}
		
		public function getExitBtn():Button {
			return this.exitBtn;
		}
		
		public function getStructureBackground():Image {
			return this.structureBackground;
		}
		
		public function getInfoField():Image {
			return this.infoField;
		}
		
		public function getDataField():Image {
			return this.dataField;
		}
		
		public function getBuyButton():Button {
			return this.buyBtn;
		}
		
		public function toHQ(event:Event):void {
			var sound:Sound = AssetManager.getAudioAsset(AssetManager.MenuForwardSound);
			sound.play();
			this.getMainGame().removeAdditionalScreen(event);
			this.getMainGame().addAdditionalScreen(this.getMainGame().getMapLogic().getStructure("Hospital"));
		}
		
		protected function addSpecificDetails(values:Object = null):void {
			var data:Object = values == null ? mainGame.getEconomyLogic().getValuesByStructureName(info.name) : values;
			if (data == null && this.info.type != "hq") createDeadText();		//hq can't die
			else {
				keyValueVector = new Vector.<TextField>();
				for (var key:String in data) {
					if (!ArrayUtil.inArray(ignoreKeyWords, key)) {
						var valueField:TextField = new TextField(60, 20, "", Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
						valueField.x = dataField.x + dataField.width - valueField.width;
						valueField.hAlign = HAlign.LEFT;
						valueField.autoSize = TextFieldAutoSize.HORIZONTAL;
						if (key == "Infected") {
							valueField.text = this.mainGame.getEconomyLogic().getInfectedPercentageByName(this.info.name).toFixed().toString() + "%";
							valueField.y = dataField.y + 10;
						} else if (key == "Resources") {
							valueField.text = new Number(data[key]).toFixed().toString();
							valueField.y = dataField.y + 30;
						} else if (key == "Knowledge") {
							valueField.text = new Number(data[key]).toFixed(1).toString();
							valueField.y = dataField.y + 50;
						} else if (key == "Spread rate") {
							valueField.text = new Number(data[key]).toFixed(1).toString() + "%";
							valueField.y = dataField.y + 70;
						}
						keyValueVector.push(valueField);
						addChild(valueField);
					}
				}
			}
		}
		
		protected function addBuyButton():void {
			if (buyBtn == null) {
				buyBtn = new Button(AssetManager.getSingleAsset("ui", "BuyBtn"));
				buyBtn.y = dataField.y + dataField.height + Config.SPACING_ABOVE_PX;
				buyBtn.x = structureBackground.x + ((structureBackground.width - buyBtn.width) / 2);
			}
			buyBtn.addEventListener(Event.TRIGGERED, toHQ);
			addChild(buyBtn);
		}
		
		protected function addBackground():void {
			if (structureBackground == null) {
				structureBackground = new Image(AssetManager.getSingleAsset("ui", "StructureBG"));
				structureBackground.x = (stage.stageWidth - structureBackground.width) / 2;
				structureBackground.y = (stage.stageHeight - structureBackground.height) / 2;
			}
			addChild(structureBackground);
		}
		
		protected function addExitBtn():void {
			if (exitBtn == null) {
				exitBtn = new Button(AssetManager.getSingleAsset("ui", "BackToGameBtn"));
				setButtonAttributes(structureBackground.x + ((structureBackground.width - exitBtn.width) / 2), structureBackground.y + structureBackground.height - exitBtn.height, exitBtn, "");
			}
			exitBtn.addEventListener(Event.TRIGGERED, mainGame.removeAdditionalScreen);
			addChild(exitBtn);
		}
		
		protected function addInfoField():void {
			if (infoField == null) {
				infoField = new Image(AssetManager.getSingleAsset("ui", "InfoField"));
				infoField.x = structureBackground.x + ((structureBackground.width - infoField.width) / 2);
				infoField.y = structureBackground.y + 5;
			}
			var structureImage:Image = new Image(AssetManager.getSingleAsset("ui", this.info.asset));
			structureImage.x = infoField.x;
			structureImage.y = infoField.y;
			
			var title:TextField = new TextField(infoField.width - structureImage.width, Config.TEXT_SIZE_TITLE + 4, this.info.name, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_TITLE, Config.TEXT_COLOR_GENERAL);
			title.x = structureImage.x + structureImage.width + 5;
			title.y = infoField.y + 5;
			title.hAlign = HAlign.LEFT;
			title.autoSize = TextFieldAutoSize.HORIZONTAL;
			
			var infoText:TextField = new TextField(infoField.width - structureImage.width - 10, infoField.height - (Config.TEXT_SIZE_TITLE + 4) - 10, this.info.description, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			infoText.x = infoField.x + structureImage.width + 5;
			infoText.y = infoField.y + title.height + 5;
			infoText.hAlign = HAlign.LEFT;
			infoText.vAlign = VAlign.TOP;
			infoText.autoScale = true;
			
			addChild(infoField);
			addChild(structureImage);
			addChild(title);
			addChild(infoText);
		}
		
		protected function addDataField():void {
			if (dataField == null) {
				dataField = new Image(AssetManager.getSingleAsset("ui", "DataField"));
				dataField.x = infoField.x;
				dataField.y = infoField.y + infoField.height + Config.SPACING_ABOVE_PX;
			}
			addChild(dataField);
		}
		
		protected function createDeadText():void {
			if (getChildIndex(deadText) < 0) {
				if (getChildIndex(dataField) 	>= 0) 	removeChild(dataField);
				if (getChildIndex(infoField) 	>= 0) 	removeChild(infoField);
				if (getChildIndex(buyBtn) 		>= 0) 	removeChild(buyBtn);
				addInfoField();
				
				var textBackground:Image = new Image(AssetManager.getSingleAsset("ui", "InfoField"));
				textBackground.x = structureBackground.x + ((structureBackground.width - textBackground.width) / 2);
				textBackground.y = infoField.y + infoField.height + Config.SPACING_ABOVE_PX;
				
				deadText = new TextField(textBackground.width - 10, textBackground.height - 10, Config.DEAD_TEXT, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
				deadText.x = textBackground.x + 5;
				deadText.y = textBackground.y + 5;
				deadText.autoSize = TextFieldAutoSize.VERTICAL;
				
				addChild(textBackground);
				addChild(deadText);
			}
		}
	}

}