package screens 
{
	import starling.display.Button;
	import starling.events.Event;
	import util.AssetManager;
	import util.Config;
	
	/**
	 * The highscores screen of the application
	 * @author Johan
	 */
	public class HighscoresScreen extends BaseScreen 
	{
		private var backBtn:Button;
		
		/**
		 * The constructor of HighscoreScreen
		 * @param	main
		 */
		public function HighscoresScreen(main:ScreenMaster) 
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
			
			backBtn = new Button(AssetManager.getSingleAsset("ui", "MenuBtn"));
			setButtonAttributes((stage.stageWidth - backBtn.width) / 2, getLogo().height + Config.SPACING_ABOVE_PX, backBtn, "Back to menu");
			
			addChild(backBtn);
			backBtn.addEventListener(Event.TRIGGERED, toStart);
		}
	}

}