package  
{
	import flash.events.KeyboardEvent;
	import screens.BaseScreen;
	import screens.HighscoresScreen;
	import screens.LoadGameScreen;
	import screens.MainGameScreen;
	import screens.ScoreScreen;
	import screens.SettingsScreen;
	import screens.StartScreen;
	import screens.StoryScreen;
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.desktop.NativeApplication;
	import flash.ui.Keyboard;
	
	/**
	 * The controller of the MVC. Its purpose is to fetch the correct screen to the user
	 * @author Johan
	 */
	public class ScreenMaster extends Sprite 
	{
		
		private var currentScreen:BaseScreen;
		private var screenName:String = "";
		
		/**
		 * The constructor of ScreenMaster
		 */
		public function ScreenMaster() 
		{
			super();
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleBackButton);
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
		public function loadScreen(screenName:String, additionalInfo:String = ""):void {
			disposeScreen();
			this.screenName = screenName;
			if (screenName == "start") {
				currentScreen = new StartScreen(this);
			} else if (screenName == "main_game") {
				currentScreen = new MainGameScreen(this);
			} else if (screenName == "load_game_menu") {
				currentScreen = new LoadGameScreen(this);
			} else if (screenName == "settings_menu") {
				currentScreen = new SettingsScreen(this);
			} else if (screenName == "highscores_menu") {
				currentScreen = new HighscoresScreen(this);
			} else if (screenName == "story_play") {
				currentScreen = new StoryScreen(this);
			} else if (screenName == "score") {
				currentScreen = new ScoreScreen(this, additionalInfo);
			}
			
			addChild(currentScreen);
		}
		
		public function loadSavedGame(gameScreen:MainGameScreen):void {
			disposeScreen();
			currentScreen = gameScreen;
		}
		
		public function handleBackButton(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.BACK) {
				if (screenName != "" && screenName != "start") {
					event.preventDefault();
					if (screenName == "main_game") {
						var screen:MainGameScreen = currentScreen as MainGameScreen;
						screen.getMenuBtn().dispatchEvent(new Event(Event.TRIGGERED));
					} else {
						this.loadScreen("start");
					}
				}
			}
		}
		
		private function disposeScreen():void {
			if (currentScreen != null) {
				currentScreen.disposeScreen();
				removeChild(currentScreen);
			}
		}
		
	}

}