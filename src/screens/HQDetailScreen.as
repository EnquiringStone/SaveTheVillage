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
		public function HQDetailScreen(main:ScreenMaster, information:Object, economyLogic:EconomyLogic) 
		{
			super(main, information, economyLogic);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
	}

}