package  
{
	import screens.BaseScreen;
	import screens.HighscoresScreen;
	import screens.MainGameScreen;
	import screens.SettingsScreen;
	import screens.StartScreen;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * The controller of the MVC. Its purpose is to fetch the correct screen to the user
	 * @author Johan
	 */
	public class ScreenMaster extends Sprite 
	{
		
		private var currentScreen:BaseScreen;
		
		/**
		 * The constructor of ScreenMaster
		 */
		public function ScreenMaster() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		/**
		 * Initializes loading the first screen
		 * @param	event
		 */
		public function initialize(event:Event):void {
			loadScreen("start");
		}
		
		/**
		 * Loads the given screen
		 * @param	screenName
		 */
		public function loadScreen(screenName:String):void {
			if (currentScreen != null) {
				currentScreen.disposeScreen();
				removeChild(currentScreen);
			}
			if (screenName == "start") {
				currentScreen = new StartScreen(this);
			} else if (screenName == "main_game") {
				currentScreen = new MainGameScreen(this);
			} else if (screenName == "load_game_menu") {
				//do nothing
			} else if (screenName == "settings_menu") {
				currentScreen = new SettingsScreen(this);
			} else if (screenName == "highscores_menu") {
				currentScreen = new HighscoresScreen(this);
			} else if (screenName == "story_play") {
				//do nothing
			}
			
			addChild(currentScreen);
		}
		
	}

}