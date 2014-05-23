package screens 
{
	import gamelogic.EconomyLogic;
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
			//Add button to distribute knowledge (enable/disable)
			//Add button logic
		}
	}

}