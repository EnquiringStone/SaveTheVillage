package screens 
{
	import starling.events.Event;
	/**
	 * ...
	 * @author Johan
	 */
	public class VillageDetailScreen extends BaseScreen 
	{
		private var info:Object;
		public function VillageDetailScreen(main:ScreenMaster, information:Object) 
		{
			super(main);
			this.info = information;
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize(event:Event) {
			
		}
		
	}

}