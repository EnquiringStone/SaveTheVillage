package screens 
{
	import starling.events.Event;
	/**
	 * ...
	 * @author Johan
	 */
	public class CityDetailScreen extends BaseScreen 
	{
		private var info:Object;
		public function CityDetailScreen(main:ScreenMaster, information:Object) 
		{
			super(main);
			this.info = information;
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize(event:Event) {
			
		}
		
	}

}