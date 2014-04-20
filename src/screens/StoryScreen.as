package screens 
{
	import starling.display.Button;
	import starling.events.Event;
	import util.AssetManager;
	import util.Config;
	
	/**
	 * The story screen
	 * @author Johan
	 */
	public class StoryScreen extends BaseScreen 
	{
		private var exitBtn:Button;
		
		/**
		 * The constructor of StoryScreen
		 * @param	main
		 */
		public function StoryScreen(main:ScreenMaster) 
		{
			super(main);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		/**
		 * Initializes the assets that will be used in this screen. The event listeners will also be set
		 * @param	event
		 */
		public function initialize(event:Event):void {
			putLogoOnScreen();
			
			exitBtn = new Button(AssetManager.getSingleAsset("ui", "MenuBtn"));
			setButtonAttributes((stage.stageWidth - exitBtn.width) / 2, getLogo().y + getLogo().height + Config.SPACING_ABOVE_PX, exitBtn, "Back to menu");
			exitBtn.addEventListener(Event.TRIGGERED, toStart);
			
			addChild(exitBtn);
		}
		
	}

}