package screens 
{
	import gamelogic.EconomyLogic;
	import starling.events.TouchEvent;
	import util.AssetManager;
	import util.Config;
	import starling.display.Button;
	import starling.events.Event;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Johan
	 */
	public class CityDetailScreen extends StructureScreen 
	{
		private var transferAmount:int = 1; //How much knowledge will be transfered
		private var transferKnowledgeBtn:Button;
		
		public function CityDetailScreen(mainGame:MainGameScreen, information:Object) 
		{
			super(mainGame, information);
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		public function added(event:Event):void {
			initialize(event);
			if (!this.getMainGame().getMapLogic().isDead(this.getInfo().name)) {
				addInfoField();
				addDataField();
				addBuyButton();
				addSpecificDetails();
				transferKnowledgeBtn = new Button(AssetManager.getSingleAsset("ui", "TransferKnowledgeBtn"));
				setButtonAttributes(getBuyButton().x, getBuyButton().y + getBuyButton().height + 5, transferKnowledgeBtn, "");
				transferKnowledgeBtn.addEventListener(Event.TRIGGERED, transferKnowledge);
			
				updateTransferKnowledgeBtn();
			
				addChild(transferKnowledgeBtn);
			} else {
				this.createDeadText();
			}
		}
		
		public function getTransferKnowledgeBtn():Button {
			return this.transferKnowledgeBtn;
		}
		
		public function updateTransferKnowledgeBtn():void {
			var data:Object = this.getMainGame().getEconomyLogic().getValuesByStructureName(this.getInfo().name);
			if (data != null) {
				transferKnowledgeBtn.enabled = data["Knowledge"] >= transferAmount;
			} else {
				transferKnowledgeBtn.enabled = false;
			}
		}
		
		private function transferKnowledge(event:Event):void {
			this.getMainGame().getDayLogic().getTimer().stop();
			this.getMainGame().removeInformationScreen();
			this.getMainGame().addHelpMessage(Config.TRANSFER_HELP_TEXT);
			this.getMainGame().getEconomyLogic().setTransferAmount(transferAmount);
			this.getMainGame().getEconomyLogic().removeKnowledge(this.getInfo().name, transferAmount);
			this.getMainGame().getBGImage().addEventListener(TouchEvent.TOUCH, this.getMainGame().selectTargetKnowledge);
		}
	}

}