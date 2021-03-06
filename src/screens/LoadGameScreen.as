package screens 
{
	import flash.filesystem.File;
	import gamelogic.DayLogic;
	import gamelogic.EconomyLogic;
	import gamelogic.MapLogic;
	import gamelogic.RandomEventLogic;
	import starling.display.Button;
	import starling.events.Event;
	import starling.text.TextField;
	import util.AssetManager;
	import util.Config;
	import ao.ExternalStorageAO;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * The load game screen
	 * @author Johan
	 */
	public class LoadGameScreen extends BaseScreen 
	{
		private var exitBtn:Button;
		private var buttons:Object;
		
		/**
		 * The constructor of LoadGameScreen
		 * @param	main
		 */
		public function LoadGameScreen(main:ScreenMaster) 
		{
			super(main);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
			this.buttons = new Object();
		}
		
		/**
		 * Initializes the assets that will be used in this screen. The event listeners will also be set
		 * @param	event
		 */
		public function initialize(event:Event):void {
			putBackgroundOnScreen();
			putLogoOnScreen();
			
			var saves:Array = ExternalStorageAO.loadFilesFromDirectory(Config.SAVE_GAME_DIRECTORY);
			var counter:int = 0;
			if (saves.length == 0) emptyScreen();
			for each(var file:File in saves) {
				var button:Button = new Button(AssetManager.getSingleAsset("ui", "SmallPlayBtn"));
				var text:TextField = new TextField((stage.stageWidth / 3) - Config.SPACING_LEFT_PX, button.height, file.name.slice(0, -4), Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
				
				text.x = Config.SPACING_LEFT_PX;
				if (counter == 0) {
					text.y = getLogo().y + getLogo().height + Config.SPACING_BENEATH_PX;
					
				} else {
					text.y = getLogo().y + getLogo().height + Config.SPACING_BENEATH_PX + ((text.height + Config.SPACING_BENEATH_PX) * counter);
				}
				text.hAlign = HAlign.LEFT;
				text.vAlign = VAlign.CENTER;
				
				setButtonAttributes(text.x + text.width, text.y, button, "Play");
				button.addEventListener(Event.TRIGGERED, loadGame);
				
				var deleteBtn:Button = new Button(AssetManager.getSingleAsset("ui", "SmallDeleteBtn"));
				setButtonAttributes(button.x + button.width + Config.SPACING_LEFT_PX, button.y, deleteBtn, "");
				deleteBtn.addEventListener(Event.TRIGGERED, deleteSave);
				
				buttons[file.url] = { "delete": deleteBtn, "play": button, "name": file.name };
				
				
				counter ++;
				addChild(text);
				addChild(button);
				addChild(deleteBtn);
			}
			
			exitBtn = new Button(AssetManager.getSingleAsset("ui", "BackBtn"));
			setButtonAttributes((stage.stageWidth - exitBtn.width) / 2, stage.stageHeight - Config.SPACING_BENEATH_PX - exitBtn.height, exitBtn, "Back to menu");
			exitBtn.addEventListener(Event.TRIGGERED, toStart);
			
			addChild(exitBtn);
		}
		
		private function emptyScreen():void {
			var text:TextField = new TextField(stage.stageWidth - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, 150, "You don't have any saved files. To save a file, play the game and click on menu. Than click save.", Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			text.x = Config.SPACING_LEFT_PX;
			text.y = (stage.stageHeight - text.height) / 2;
			
			addChild(text);
		}
		
		private function loadGame(event:Event):void {
			for (var name:String in buttons) {
				if (buttons[name].play == event.target as Button) {
					var data:String = ExternalStorageAO.loadFile(Config.SAVE_GAME_DIRECTORY + buttons[name]["name"]);
					var jsonData:Object = JSON.parse(data);
					var dayLogic:DayLogic = new DayLogic();
					var economyLogic:EconomyLogic = new EconomyLogic();
					var mapLogic:MapLogic = new MapLogic();
					var randomEventLogic:RandomEventLogic = new RandomEventLogic();
					
					dayLogic.setValuesFromRawData(jsonData.logic.DayLogic);
					economyLogic.setValuesFromRawData(jsonData.logic.EconomyLogic);
					mapLogic.setValuesFromRawData(jsonData.logic.MapLogic);
					randomEventLogic.setValuesFromRawData(jsonData.logic.RandomEventLogic);
					
					var mainGame:MainGameScreen = new MainGameScreen(main, dayLogic, economyLogic, mapLogic, randomEventLogic, parseInt(jsonData.id), parseInt(jsonData.saveCounter), jsonData.settings);
					dayLogic.setMainGame(mainGame);
					economyLogic.setMainGame(mainGame);
					mapLogic.setMainGame(mainGame);
					randomEventLogic.setMainGame(mainGame);
					
					main.loadSavedGame(mainGame);
					break;
				}
			}
		}
		
		private function deleteSave(event:Event):void {
			for (var name:String in buttons) {
				if (buttons[name]["delete"] == event.target as Button) {
					ExternalStorageAO.removeFile(Config.SAVE_GAME_DIRECTORY + buttons[name]["name"]);
					this.main.reloadScreen();
				}
			}
		}
		
	}

}