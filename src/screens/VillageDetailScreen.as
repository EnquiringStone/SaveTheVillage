package screens 
{
	import gamelogic.EconomyLogic;
	import starling.events.Event;
	/**
	 * ...
	 * @author Johan
	 */
	public class VillageDetailScreen extends StructureScreen 
	{
		public function VillageDetailScreen(mainGame:MainGameScreen, information:Object) 
		{
			super(mainGame, information);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
	}

}