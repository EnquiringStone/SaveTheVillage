package screens 
{
	import flash.geom.Point;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.LocaleID;
	import flash.globalization.DateTimeStyle;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import util.AssetManager;
	import util.Config;
	import ao.ExternalStorageAO;
	
	/**
	 * The RTS game screen mode of the game
	 * @author Johan
	 */
	public class MainGameScreen extends BaseScreen 
	{
		private var bgImage:Image;
		private var menuBtn:Button;
		private var continueBtn:Button;
		private var saveBtn:Button;
		private var exitBtn:Button;
		
		/**
		 * The constructor of MainGameScreen
		 * @param	main
		 */
		public function MainGameScreen(main:ScreenMaster) 
		{
			super(main);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		/**
		 * Initializes the assets that will be used in this screen. The event listeners will also be set
		 * @param	event
		 */
		public function initialize(event:Event):void {
			menuBtn = new Button(AssetManager.getSingleAsset("ui", "MainGameMenuBtn"));
			setButtonAttributes(stage.stageWidth - menuBtn.width, 0, menuBtn, "Menu");
			menuBtn.addEventListener(Event.TRIGGERED, setMenuOptions);
			
			var quad:Quad = new Quad(stage.stageWidth - menuBtn.width, menuBtn.height, Config.GAME_MENU_COLOR);
			
			bgImage = new Image(AssetManager.getSingleAsset("ui", "MainGameBg"));
			bgImage.y = menuBtn.height;
			bgImage.addEventListener(TouchEvent.TOUCH, detectMoveTouch);
			
			addChild(bgImage);
			addChild(quad);
			addChild(menuBtn);
		}
		
		/**
		 * Detects whether the user touches the phone
		 * @param	event
		 */
		public function detectMoveTouch(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);
			var target:Image = event.target as Image;
			if (touch != null) {
				if (touch.phase == TouchPhase.MOVED) {
					moveImageByTouch(touch, target);
				}
			}
		}
		
		/**
		 * Moves the background image by the users touch
		 * @param	touch
		 * @param	target
		 */
		public function moveImageByTouch(touch:Touch, target:Image):void {
			var point:Point = touch.getMovement(this);
			target.x += point.x;
			if (target.x > 0) target.x = 0;
			if (target.x < (target.width - stage.stageWidth) * -1) target.x = (target.width - stage.stageWidth) * -1;
			
			target.y += point.y;
			if (target.y > menuBtn.height) target.y = menuBtn.height;
			if (target.y < (target.height - stage.stageHeight) * -1) target.y = (target.height - stage.stageHeight) * -1;
			
			menuBtn.visible = true;
		}
		
		/**
		 * Sets the menu options for the menu button. Initializes the choices the player can choose from and its event listeners
		 * @param	event
		 */
		public function setMenuOptions(event:Event):void {
			bgImage.removeEventListener(TouchEvent.TOUCH, detectMoveTouch);
			menuBtn.removeEventListener(Event.TRIGGERED, setMenuOptions);
			
			if (saveBtn == null) saveBtn = new Button(AssetManager.getSingleAsset("ui", "MenuBtn"));
			setButtonAttributes((stage.stageWidth - saveBtn.width) / 2, (stage.stageHeight - saveBtn.height) / 2, saveBtn, "Save");
			
			if (continueBtn == null) continueBtn = new Button(AssetManager.getSingleAsset("ui", "MenuBtn"));
			setButtonAttributes(saveBtn.x, saveBtn.y - continueBtn.height - Config.SPACING_ABOVE_PX, continueBtn, "Continue");
			
			if (exitBtn == null) exitBtn = new Button(AssetManager.getSingleAsset("ui", "MenuBtn"));
			setButtonAttributes(saveBtn.x, saveBtn.y + saveBtn.height + Config.SPACING_ABOVE_PX, exitBtn, "Exit");
			
			addChild(saveBtn);
			addChild(continueBtn);
			addChild(exitBtn);
			
			saveBtn.addEventListener(Event.TRIGGERED, saveGameState);
			continueBtn.addEventListener(Event.TRIGGERED, continueGame);
			exitBtn.addEventListener(Event.TRIGGERED, toStart);
		}
		
		/**
		 * Will save the state of the game onto the external drive of the phone. It uses the datetime as its name
		 * @param	event
		 */
		private function saveGameState(event:Event):void {
			//TODO
			//get raw game data put this into a file
			//var rawData:String = "";
			
			var df:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT, DateTimeStyle.SHORT, DateTimeStyle.SHORT);
			var date:Date = new Date();
			
			var name:String = df.format(date);
			trace(name);
			//ExternalStorageAO.saveFile(Config.SAVE_GAME_DIRECTORY + name + ".dat", rawData);
			continueGame(event);
		}
		
		/**
		 * Continues the game, resetting the event listeners and removing the menu options
		 * @param	event
		 */
		private function continueGame(event:Event):void {
			saveBtn.removeEventListener(Event.TRIGGERED, saveGameState);
			continueBtn.removeEventListener(Event.TRIGGERED, continueGame);
			exitBtn.removeEventListener(Event.TRIGGERED, toStart);
			
			removeChild(saveBtn);
			removeChild(continueBtn);
			removeChild(exitBtn);
			
			menuBtn.addEventListener(Event.TRIGGERED, setMenuOptions);
			bgImage.addEventListener(TouchEvent.TOUCH, detectMoveTouch);
		}
	}

}