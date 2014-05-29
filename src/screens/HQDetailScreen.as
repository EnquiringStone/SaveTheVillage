package screens 
{
	import gamelogic.EconomyLogic;
	import starling.display.Button;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.events.TouchEvent;
	import util.AssetManager;
	import util.Config;
	/**
	 * ...
	 * @author Johan
	 */
	public class HQDetailScreen extends StructureScreen 
	{	
		private var buttonKnowledge:Button;
		private var buttonCondom:Button;
		private var buttonNeedles:Button;
		private var buttonMedicine:Button;
		
		public function HQDetailScreen(mainGame:MainGameScreen, information:Object) 
		{
			super(mainGame, information);
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		public function added(event:Event):void {
			addQuad();
			createScreen();
			
			buttonKnowledge = new Button(AssetManager.getSingleAsset("ui", "SettingsChoiceBtn"));
			
			var knowledgeField:TextField = new TextField(getQuad().width - buttonKnowledge.width - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, 0, "", Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			knowledgeField.autoSize = TextFieldAutoSize.VERTICAL;
			knowledgeField.text = "Buy " + Config.DEFAULT_VALUE_KNOWLEDGE_BOUGHT + " Knowledge for " + Config.DEFAULT_VALUE_KNOWLEDGE + " Education points";
			knowledgeField.x = getQuad().x + Config.SPACING_LEFT_PX;
			knowledgeField.y = getDescription().y + getDescription().height + Config.SPACING_BENEATH_PX;
			knowledgeField.hAlign = HAlign.LEFT;
			knowledgeField.vAlign = VAlign.CENTER;
			
			setButtonAttributes(knowledgeField.x + knowledgeField.width + Config.SPACING_LEFT_PX, knowledgeField.y, buttonKnowledge, "Buy knowledge");
			buttonKnowledge.addEventListener(Event.TRIGGERED, buyKnowledge);
			
			var resourceField:TextField = new TextField(knowledgeField.width, 0, "", Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			resourceField.autoSize = TextFieldAutoSize.VERTICAL;
			resourceField.text = "Buy " + Config.DEFAULT_VALUE_RESOURCES_BOUGHT + " Resources for " + Config.DEFAULT_VALUE_RESOURCES + " Education points";
			resourceField.x = knowledgeField.x;
			resourceField.y = buttonKnowledge.y + buttonKnowledge.height + Config.SPACING_BENEATH_PX;
			resourceField.hAlign = HAlign.LEFT;
			resourceField.vAlign = VAlign.CENTER;
			
			var buttonResourceWidth:int = resourceField.x + resourceField.width + Config.SPACING_LEFT_PX;
			
			buttonCondom = new Button(AssetManager.getSingleAsset("ui", "SettingsChoiceBtn"));
			setButtonAttributes(buttonResourceWidth, resourceField.y, buttonCondom, "Buy condoms");
			buttonCondom.addEventListener(Event.TRIGGERED, buyCondoms);
			
			buttonNeedles = new Button(AssetManager.getSingleAsset("ui", "SettingsChoiceBtn"));
			setButtonAttributes(buttonResourceWidth, resourceField.y + buttonCondom.height + Config.SPACING_ABOVE_PX, buttonNeedles, "Buy clean needles");
			buttonNeedles.addEventListener(Event.TRIGGERED, buyCleanNeedles);

			buttonMedicine = new Button(AssetManager.getSingleAsset("ui", "SettingsChoiceBtn"));
			setButtonAttributes(buttonResourceWidth, buttonNeedles.y + buttonNeedles.height + Config.SPACING_ABOVE_PX, buttonMedicine, "Buy medicine");
			buttonMedicine.addEventListener(Event.TRIGGERED, buyCleanNeedles);
			
			getQuad().height += buttonMedicine.height;
			
			createButtons();
			
			updateButtons();
			
			addChild(knowledgeField);
			addChild(buttonKnowledge);
			addChild(resourceField);
			addChild(buttonCondom);
			addChild(buttonNeedles);
			addChild(buttonMedicine);
		}
		
		public function updateButtons():void {
			buttonKnowledge.enabled = this.getMainGame().getEconomyLogic().getEducationPoints() >= Config.DEFAULT_VALUE_KNOWLEDGE;
			buttonCondom.enabled = this.getMainGame().getEconomyLogic().getEducationPoints() >= Config.DEFAULT_VALUE_RESOURCES;
			buttonNeedles.enabled = this.getMainGame().getEconomyLogic().getEducationPoints() >= Config.DEFAULT_VALUE_RESOURCES;
			buttonMedicine.enabled = this.getMainGame().getEconomyLogic().getEducationPoints() >= Config.DEFAULT_VALUE_RESOURCES;
		}
		
		public function buyKnowledge(event:Event):void {
			transfer("knowledge");
		}
		
		public function buyCondoms(event:Event):void {
			transfer("condoms");
		}
		
		public function buyCleanNeedles(event:Event):void {
			transfer("needles");
		}
		
		public function buyMedicine(event:Event):void {
			transfer("medicine");
		}
		
		public function transfer(type:String):void {
			this.getMainGame().getDayLogic().getTimer().stop();
			this.getMainGame().removeInformationScreen();
			this.getMainGame().addHelpMessage(Config.TRANSFER_HELP_TEXT);
			if (type == "knowledge") {
				this.getMainGame().getEconomyLogic().setTransferAmount(Config.DEFAULT_VALUE_KNOWLEDGE_BOUGHT);
				this.getMainGame().getEconomyLogic().removeEducationPoints(Config.DEFAULT_VALUE_KNOWLEDGE);
				this.getMainGame().getBGImage().addEventListener(TouchEvent.TOUCH, this.getMainGame().selectTargetKnowledge);
			} else { //type is a resource
				this.getMainGame().getEconomyLogic().setTransferAmount(Config.DEFAULT_VALUE_RESOURCES_BOUGHT);
				this.getMainGame().getEconomyLogic().removeEducationPoints(Config.DEFAULT_VALUE_RESOURCES);
				this.getMainGame().getBGImage().addEventListener(TouchEvent.TOUCH, this.getMainGame().selectTargetResources);
			}
			this.getMainGame().updateEducationPointsField();
		}
	}

}