package screens 
{
	import starling.events.Event;
	/**
	 * ...
	 * @author Johan
	 */
	public class HQDetailScreen extends BaseScreen 
	{
		private var info:Object;
		public function HQDetailScreen(main:ScreenMaster, information:Object) 
		{
			super(main);
			this.info = information:Object;
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize(event:Event) {
			
		}
	}

}