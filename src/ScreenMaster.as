package  
{
	import screens.BaseScreen;
	import screens.SettingsScreen;
	import screens.StartScreen;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Johan
	 */
	public class ScreenMaster extends Sprite 
	{
		
		private var currentScreen:BaseScreen;
		
		public function ScreenMaster() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize(event:Event):void {
			loadScreen("start");
		}
		
		public function loadScreen(screenName:String):void {
			if (currentScreen != null) {
				currentScreen.disposeScreen();
				removeChild(currentScreen);
			}
			if (screenName == "start") {
				currentScreen = new StartScreen(this);
			} else if (screenName == "main_game") {
				//do nothing
			} else if (screenName == "load_game_menu") {
				//do nothing
			} else if (screenName == "settings_menu") {
				currentScreen = new SettingsScreen(this);
			} else if (screenName == "high_scores_menu") {
				//do nothing
			} else if (screenName == "story_play") {
				//do nothing
			}
			
			addChild(currentScreen);
		}
		
	}

}