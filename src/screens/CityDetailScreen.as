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
		private var transferAmount:int = 1;
		
		public function CityDetailScreen(mainGame:MainGameScreen, information:Object) 
		{
			super(mainGame, information);
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		public function added(event:Event):void {
			initialize(event);
			
			var transferKnowledgeBtn:Button = new Button(AssetManager.getSingleAsset("ui", "SettingsChoiceBtn"));
			setButtonAttributes(getExitBtn().x + getExitBtn().width + Config.SPACING_LEFT_PX, getExitBtn().y, transferKnowledgeBtn, "Transfer knowledge");
			transferKnowledgeBtn.addEventListener(Event.TRIGGERED, transferKnowledge);
			
			var data:Object = this.getMainGame().getEconomyLogic().getValuesByStructureName(this.getInfo().name);
			
			transferKnowledgeBtn.enabled = parseInt(data["Knowledge"]) >= transferAmount;
			
			addChild(transferKnowledgeBtn);
		}
		
		private function transferKnowledge(event:Event):void {
			this.getMainGame().getDayLogic().getTimer().stop();
			this.getMainGame().removeInformationScreen();
			this.getMainGame().addHelpMessage(Config.TRANSFER_HELP_TEXT);
			this.getMainGame().getEconomyLogic().setTransferAmount(Config.BASE_COST_KNOWLEDGE);
			this.getMainGame().getEconomyLogic().removeKnowledge(this.getInfo().name, transferAmount);
			this.getMainGame().getBGImage().addEventListener(TouchEvent.TOUCH, this.getMainGame().selectTargetKnowledge);
		}
	}

}