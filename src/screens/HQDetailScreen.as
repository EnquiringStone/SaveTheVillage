package screens 
{
	import gamelogic.EconomyLogic;
	import starling.events.Event;
	/**
	 * ...
	 * @author Johan
	 */
	public class HQDetailScreen extends StructureScreen 
	{	
		public function HQDetailScreen(mainGame:MainGameScreen, information:Object) 
		{
			super(mainGame, information);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
	}

}