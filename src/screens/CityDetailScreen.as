package screens 
{
	import gamelogic.EconomyLogic;
	import starling.events.Event;
	/**
	 * ...
	 * @author Johan
	 */
	public class CityDetailScreen extends StructureScreen 
	{
		public function CityDetailScreen(main:ScreenMaster, information:Object, economyLogic:EconomyLogic) 
		{
			super(main, information, economyLogic);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
	}

}