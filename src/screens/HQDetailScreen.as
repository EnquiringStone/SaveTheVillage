package screens 
{
	import gamelogic.EconomyLogic;
	import starling.display.Button;
	import starling.events.Event;
	import util.AssetManager;
	import util.Config;
	/**
	 * ...
	 * @author Johan
	 */
	public class HQDetailScreen extends StructureScreen 
	{	
		public function HQDetailScreen(mainGame:MainGameScreen, information:Object) 
		{
			super(mainGame, information);
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		public function added(event:Event):void {
			addQuad();
			createScreen();
			
			var buttonKnowledge:Button = new Button(AssetManager.getSingleAsset("ui", "SettingsChoiceBtn"));
			setButtonAttributes(getQuad().x + Config.SPACING_LEFT_PX, getDescription().y + Config.SPACING_ABOVE_PX, buttonKnowledge, "Buy knowledge");
			buttonKnowledge.addEventListener(Event.TRIGGERED, buyKnowledge);
			
			var buttonResources:Button = new Button(AssetManager.getSingleAsset("ui", "SettingsChoiceBtn"));
			setButtonAttributes(buttonKnowledge.x + buttonKnowledge.width + Config.SPACING_LEFT_PX, buttonKnowledge.y, buttonResources, "Buy resources");
			buttonResources.addEventListener(Event.TRIGGERED, buyResources);
		}
		
		public function buyKnowledge(event:Event):void {
			transfer("knowledge");
		}
		
		public function buyResources(event:Event):void {
			transfer("resources");
		}
		
		public function transfer(type:String) {
			
		}
	}

}