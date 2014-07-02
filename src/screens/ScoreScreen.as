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
	 * @author Johan
	 */
	public class ScoreScreen extends BaseScreen 
	{
		private var score:int;
		private var playerText:flash.text.TextField;
		private var congratsText:TextField;
		private var scoreText:TextField;
		private var scoreField:TextField;
		private var text:String = "Your name";
		private var button:Button;
		
		public function ScoreScreen(main:ScreenMaster, score:String) 
		{
			super(main);
			this.score = parseInt(score);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize():void {
			putBackgroundOnScreen();
			putLogoOnScreen();
			
			congratsText = new TextField(stage.stageWidth - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, 100, "Congratulations", Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_TITLE, Config.TEXT_COLOR_GENERAL);
			congratsText.x = Config.SPACING_LEFT_PX;
			congratsText.y = getLogo().y + getLogo().height + Config.SPACING_BENEATH_PX;
			
			scoreText = new TextField(stage.stageWidth - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, 40, Config.SCORE_TEXT, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			scoreText.x = Config.SPACING_LEFT_PX;
			scoreText.y = congratsText.y + congratsText.height + Config.SPACING_BENEATH_PX;
			
			scoreField = new TextField(scoreText.width, 100, this.score.toString(), Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_TITLE, Config.TEXT_COLOR_GENERAL, true);
			scoreField.x = scoreText.x;
			scoreField.y = scoreText.y + scoreText.height + 5;
			
			playerText = new flash.text.TextField();
			var textFormat:TextFormat = new TextFormat(Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			textFormat.align = "center";
			playerText.defaultTextFormat = textFormat;
			playerText.width = scoreText.width;
			playerText.height = 30;
			playerText.text = text;
			playerText.border = true;
			playerText.x = scoreText.x;
			playerText.y = scoreField.y + scoreField.height + Config.SPACING_BENEATH_PX;
			playerText.type = TextFieldType.INPUT;
			playerText.needsSoftKeyboard = true;
			playerText.requestSoftKeyboard();
			playerText.maxChars = 20;			
			
			playerText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, activate);
			playerText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, deactivate);
			
			
			button = new Button(AssetManager.getSingleAsset("ui", "BackBtn"));
			setButtonAttributes((stage.stageWidth - button.width) / 2, stage.stageHeight - Config.SPACING_BENEATH_PX - button.height, button, "Highscores");
			button.addEventListener(Event.TRIGGERED, saveResults);
			
			addChild(congratsText);
			addChild(scoreText);
			addChild(scoreField);
			Starling.current.nativeOverlay.addChild(playerText);
			addChild(button);
		}
		
		public function activate(event:SoftKeyboardEvent):void {
			if (playerText.text == text || playerText.text == "Can't use ; or _" || playerText.text == "Choose another name") {
				playerText.text = "";
				playerText.borderColor = 0x000000;
			}
			congratsText.visible = false;
			button.visible = false;
			scoreText.visible = false;
			scoreField.y = getLogo().y + getLogo().height + Config.SPACING_ABOVE_PX;
			playerText.y = scoreField.y + scoreField.height + Config.SPACING_ABOVE_PX;
		}
		
		public function deactivate(event:SoftKeyboardEvent):void {
			if (playerText.text == "") {
				playerText.text = text;
			} else if (playerText.text.indexOf(";") != -1 || playerText.text.indexOf("_") != -1) {
				playerText.text = "Can't use ; or _";
				playerText.borderColor = 0xff0000;
			}
			congratsText.visible = true;
			button.visible = true;
			scoreText.visible = true;
			scoreField.y = scoreText.y + scoreText.height + 5;
			playerText.y = scoreField.y + scoreField.height + Config.SPACING_BENEATH_PX;
		}
		
		public function saveResults(event:Event):void {
			if (playerText.text.indexOf(";") != -1 || playerText.text.indexOf("_") != -1) {
				playerText.text = "Can't use ; or _";
				playerText.borderColor = 0xff0000;
				return;
			}
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
			main.loadScreen("highscores_menu"); //exit
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