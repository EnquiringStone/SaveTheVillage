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
		public function VillageDetailScreen(main:ScreenMaster, information:Object, economyLogic:EconomyLogic) 
		{
			super(main, information, economyLogic);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
	}

}