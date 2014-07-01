package screens 
{
	import flash.media.Sound;
	import starling.display.Button;
	import starling.events.Event;
	import util.AssetManager;
	import util.Config;
	
	/**
	 * The default screen of the application
	 * @author Johan
	 */
	public class StartScreen extends BaseScreen 
	{
		private var startGameBtn:Button;
		private var highScoresBtn:Button;
		private var loadGameBtn:Button;
		private var settingsBtn:Button;
		private var tutorialBtn:Button;
		
		/**
		 * The constructor of StartScreen
		 * @param	main
		 */
		public function StartScreen(main:ScreenMaster) 
		{
			super(main);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		/**
		 * Initializes the assets that will be used in this screen. The event listeners will also be set
		 * @param	event
		 */
		public function initialize(event:Event):void {
			putBackgroundOnScreen();
			putLogoOnScreen();
			startGameBtn = new Button(AssetManager.getSingleAsset("ui", "PlayBtn"));
			setButtonAttributes(0, 0, startGameBtn, "Start game");
			
			highScoresBtn = new Button(AssetManager.getSingleAsset("ui", "HighscoreBtn"));
			setButtonAttributes(0, 0, highScoresBtn, "Highscores");
			
			loadGameBtn = new Button(AssetManager.getSingleAsset("ui", "SaveBtn"));
			setButtonAttributes(0, 0, loadGameBtn, "Load game");
			
			settingsBtn = new Button(AssetManager.getSingleAsset("ui", "SettingsBtn"));
			setButtonAttributes(0, 0, settingsBtn, "Settings");
			
			tutorialBtn = new Button(AssetManager.getSingleAsset("ui", "TutorialBtn"));
			setButtonAttributes(0, 0, tutorialBtn, "Tutorial");
			
			var buttons:Vector.<Button> = new Vector.<Button>();
			buttons.push(highScoresBtn, settingsBtn, tutorialBtn, loadGameBtn, startGameBtn);
			placeButtons(buttons);
		}
		
		/**
		 * Places the buttons perfectly aligned below eachother
		 * @param	buttons
		 */
		private function placeButtons(buttons:Vector.<Button>):void {
			var previousButton:Button;
			while (buttons.length != 0) {
				var button:Button = buttons.pop();
				button.x = (stage.stageWidth - button.width) / 2;
				button.y = previousButton == null ? getLogo().height + Config.SPACING_ABOVE_PX : previousButton.y + previousButton.height + Config.SPACING_ABOVE_PX;
				addChild(button);
				button.addEventListener(Event.TRIGGERED, touched);
				previousButton = button;
			}
		}
		
		/**
		 * Calls the controller with the touched screen
		 * @param	event
		 */
		public function touched(event:Event):void {
			var sound:Sound = AssetManager.getAudioAsset(AssetManager.MenuForwardSound);
			sound.play();
			if (event.target as Button === startGameBtn) {
				main.loadScreen("main_game");
			} else if (event.target as Button === loadGameBtn) {
				main.loadScreen("load_game_menu");
			} else if (event.target as Button === settingsBtn) {
				main.loadScreen("settings_menu");
			} else if (event.target as Button === highScoresBtn) {
				main.loadScreen("highscores_menu");
			} else if (event.target as Button === tutorialBtn) {
				main.loadScreen("tutorial");
			}
		}
		
	}

}