package screens 
{
	import gamelogic.EconomyLogic;
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
			
			addChild(transferKnowledgeBtn);
			//Add button to distribute knowledge (enable/disable)
			//Add button logic
		}
		
		private function transferKnowledge(event:Event):void {
			
		}
	}

}