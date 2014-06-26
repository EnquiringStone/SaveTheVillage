package  
{
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import starling.core.Starling;
	import screens.BaseScreen;
	import screens.HighscoresScreen;
	import screens.LoadGameScreen;
	import screens.MainGameScreen;
	import screens.ScoreScreen;
	import screens.SettingsScreen;
	import screens.StartScreen;
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.desktop.NativeApplication;
	import flash.ui.Keyboard;
	import util.AssetManager;
	
	/**
	 * The controller of the MVC. Its purpose is to fetch the correct screen to the user
	 * @author Johan
	 */
	public class ScreenMaster extends Sprite 
	{
		
		private var currentScreen:BaseScreen;
		private var screenName:String = "";
		private var soundChannel:SoundChannel;
		private var sound:Sound;
		
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
			} else if (screenName == "score") {
				currentScreen = new ScoreScreen(this, additionalInfo);
			} else if (screenName == "tutorial") {
				//tutorial screen
			}
			//loadMusic(screenName);
			addChild(currentScreen);
		}
		
		public function reloadScreen():void {
			loadScreen(screenName);
		}
		
		public function loadSavedGame(gameScreen:MainGameScreen):void {
			disposeScreen();
			currentScreen = gameScreen;
			//loadMusic("main_game");
			addChild(currentScreen);
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
				} else {
					if (soundChannel != null) {
						soundChannel.stop();
					}
					NativeApplication.nativeApplication.exit();
				}
			}
		}
		
		public function getScreenName():String {
			return this.screenName;
		}
		
		private function disposeScreen():void {
			if (currentScreen != null) {
				currentScreen.disposeScreen();
				removeChild(currentScreen);
				Starling.current.nativeOverlay.removeChildren();
			}
		}
		
		private function loadMusic(screen:String):void {
			var prevSound:Sound = sound;
			if (screen == "main_game") {
				sound = AssetManager.getAudioAsset(AssetManager.MapThemeSound);
			} else {
				sound = AssetManager.getAudioAsset(AssetManager.MenuThemeSound);
			}
			if (prevSound != sound) {
				if (soundChannel != null) {
					soundChannel.stop();
				}
				restartSound();
			}
		}
		
		private function restartSound(event:flash.events.Event = null):void {
			soundChannel = sound.play();
			var transform:SoundTransform = soundChannel.soundTransform;
			transform.volume = 0.6;
			soundChannel.addEventListener(flash.events.Event.SOUND_COMPLETE, restartSound);
		}
		
	}

}