package screens 
{
	import gamelogic.EconomyLogic;
	import starling.display.Button;
	import starling.display.Image;
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
		private var infoImage:Image;
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
			initialize(event);
			addInfoText();
			
			buttonNeedles = new Button(AssetManager.getSingleAsset("ui", "BuyCleanNeedlesBtn"));
			buttonNeedles.x = getStructureBackground().x + ((getStructureBackground().width - buttonNeedles.width) / 2);
			buttonNeedles.y = infoImage.y + infoImage.height + 5;
			
			buttonMedicine = new Button(AssetManager.getSingleAsset("ui", "BuyMedicineBtn"));
			buttonMedicine.x = getStructureBackground().x + ((getStructureBackground().width - buttonMedicine.width) / 2);
			buttonMedicine.y = buttonNeedles.y + buttonNeedles.height + 3;
			
			buttonCondom = new Button(AssetManager.getSingleAsset("ui", "BuyCondomsBtn"));
			buttonCondom.x = getStructureBackground().x + ((getStructureBackground().width - buttonCondom.width) / 2);
			buttonCondom.y = buttonMedicine.y + buttonMedicine.height + 3;
			
			buttonKnowledge = new Button(AssetManager.getSingleAsset("ui", "BuyKnowledgeBtn"));
			buttonKnowledge.x = getStructureBackground().x + ((getStructureBackground().width - buttonKnowledge.width) / 2);
			buttonKnowledge.y = buttonCondom.y + buttonCondom.height + 3;
			
			buttonKnowledge.addEventListener(Event.TRIGGERED, buyKnowledge);
			buttonCondom.addEventListener(Event.TRIGGERED, buyCondoms);
			buttonNeedles.addEventListener(Event.TRIGGERED, buyCleanNeedles);
			buttonMedicine.addEventListener(Event.TRIGGERED, buyCleanNeedles);
			
			updateButtons();
			addChild(buttonKnowledge);
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
		
		private function addInfoText():void {
			if (infoImage == null) {
				infoImage = new Image(AssetManager.getSingleAsset("ui", "HospitalInfoField"));
				infoImage.x = getStructureBackground().x + ((getStructureBackground().width - infoImage.width) / 2);
				infoImage.y = getStructureBackground().y + 10;
			}
			addChild(infoImage);
		}
	}

}