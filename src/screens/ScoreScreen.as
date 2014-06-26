package screens 
{
	import flash.events.SoftKeyboardEvent;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import starling.display.Button;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.core.Starling;
	import util.AssetManager;
	import util.Config;
	import util.ArrayUtil;
	import ao.ExternalStorageAO;
	/**
	 * ...
	 * @author Johan
	 */
	public class ScoreScreen extends BaseScreen 
	{
		private var score:int;
		private var playerText:flash.text.TextField;
		private var text:String = "Your name";
		
		public function ScoreScreen(main:ScreenMaster, score:String) 
		{
			super(main);
			this.score = parseInt(score);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize():void {
			putLogoOnScreen();
			
			var congratsText:TextField = new TextField(stage.stageWidth - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, 100, "Congratulations", Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_TITLE, Config.GAME_MENU_COLOR);
			congratsText.x = Config.SPACING_LEFT_PX;
			congratsText.y = getLogo().y + getLogo().height + Config.SPACING_BENEATH_PX;
			
			var scoreText:TextField = new TextField(stage.stageWidth - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, 40, Config.SCORE_TEXT, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.GAME_MENU_COLOR);
			scoreText.x = Config.SPACING_LEFT_PX;
			scoreText.y = congratsText.y + congratsText.height + Config.SPACING_BENEATH_PX;
			
			var score:TextField = new TextField(scoreText.width, 100, this.score.toString(), Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_TITLE, Config.GAME_MENU_COLOR, true);
			score.x = scoreText.x;
			score.y = scoreText.y + scoreText.height + 5;
			
			playerText = new flash.text.TextField();
			var textFormat:TextFormat = new TextFormat(Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.GAME_MENU_COLOR);
			textFormat.align = "center";
			playerText.defaultTextFormat = textFormat;
			playerText.width = scoreText.width;
			playerText.height = 20;
			playerText.text = text;
			playerText.border = true;
			playerText.x = scoreText.x;
			playerText.y = score.y + score.height + Config.SPACING_BENEATH_PX;
			playerText.type = TextFieldType.INPUT;
			playerText.needsSoftKeyboard = true;
			playerText.requestSoftKeyboard();
			playerText.maxChars = 20;			
			
			playerText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, activate);
			playerText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, deactivate);
			
			
			var button:Button = new Button(AssetManager.getSingleAsset("ui", "BackBtn"));
			setButtonAttributes((stage.stageWidth - button.width) / 2, stage.stageHeight - Config.SPACING_BENEATH_PX - button.height, button, "Back to menu");
			button.addEventListener(Event.TRIGGERED, saveResults);
			
			addChild(congratsText);
			addChild(scoreText);
			addChild(score);
			Starling.current.nativeOverlay.addChild(playerText);
			addChild(button);
		}
		
		public function activate(event:SoftKeyboardEvent):void {
			if (playerText.text == text) {
				playerText.text = "";
			}
		}
		
		public function deactivate(event:SoftKeyboardEvent):void {
			if (playerText.text == "") {
				playerText.text = text;
			}
		}
		
		public function saveResults(event:Event):void {
			var scores:String = ExternalStorageAO.loadFile(Config.SAVED_HIGHSCORES_FILE);
			if (scores == "") {
				var score:String = playerText.text + "_" + this.score.toString();
				ExternalStorageAO.saveFile(Config.SAVED_HIGHSCORES_FILE, score);
			} else {
				var data:Object = ArrayUtil.getValuePair(scores);
				if (sameName(data)) {
					playerText.borderColor = 0xff0000;
					playerText.text = "Choose another name";
					return;
				}
				var arr:Array;
				scores += ";" + playerText.text + "_" + this.score.toString();
				arr = orderResults(ArrayUtil.getValuePair(scores));
				if (arr.length > Config.DEFAULT_MAX_SAVES) {
					arr.pop();
				}
				ExternalStorageAO.saveFile(Config.SAVED_HIGHSCORES_FILE, resultsToString(arr));
			}
			toStart(); //exit
		}
		
		private function orderResults(results:Object):Array {
			var scores:Array = new Array();
			for (var name:String in results) {
				scores.push({"name": name, "score": results[name]});
			}
			return scores.sortOn("score", Array.DESCENDING | Array.NUMERIC);
		}
		
		private function resultsToString(results:Array):String {
			var data:String = "";
			for (var i:int = 0; i < results.length; i++) {
				data += results[i]["name"] + "_" + results[i]["score"] + ";";
			}
			return data.slice(0, -1);
		}
		
		private function sameName(data:Object):Boolean {
			for (var name:String in data) {
				if (name == playerText.text) return true;
			}
			return false;
		}
	}

}