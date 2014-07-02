package screens 
{
	import starling.display.Button;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import util.AssetManager;
	import util.Config;
	import util.ArrayUtil;
	import ao.ExternalStorageAO;
	
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
			putBackgroundOnScreen();
			putLogoOnScreen();
			
			var data:String = ExternalStorageAO.loadFile(Config.SAVED_HIGHSCORES_FILE);
			
			var highscores:Object = ArrayUtil.getValuePair(data);
			var ordered:Array = orderResults(highscores);
			var indexFieldName:TextField = new TextField((stage.stageWidth / 2) - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, 50, "Name:", Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_TITLE, Config.TEXT_COLOR_GENERAL, true);
			var indexFieldScore:TextField = new TextField(indexFieldName.width, 50, "Score:", Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_TITLE, Config.TEXT_COLOR_GENERAL, true);
			
			indexFieldName.x = Config.SPACING_LEFT_PX;
			indexFieldName.y = getLogo().y + getLogo().height + Config.SPACING_ABOVE_PX;
			indexFieldName.hAlign = HAlign.LEFT;
			
			indexFieldScore.x = indexFieldName.x + indexFieldName.width + Config.SPACING_LEFT_PX;
			indexFieldScore.y = indexFieldName.y;
			indexFieldScore.hAlign = HAlign.LEFT;
			
			addChild(indexFieldName);
			addChild(indexFieldScore);
			
			var height:Number = getLogo().height + Config.SPACING_ABOVE_PX +indexFieldName.height;
			
			for (var i:int = 0; i < ordered.length; i++ ) {
				var nameField:TextField = new TextField(indexFieldName.width, 60, "(" + new Number(i + 1).toFixed().toString() + ") " + ordered[i].name, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
				nameField.x = indexFieldName.x;
				nameField.y = height + Config.SPACING_ABOVE_PX;
				nameField.hAlign = HAlign.LEFT;
				
				var scoreField:TextField = new TextField(nameField.width, nameField.height, ordered[i].score, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
				scoreField.x = nameField.x + nameField.width + Config.SPACING_LEFT_PX;
				scoreField.y = nameField.y;
				scoreField.hAlign = HAlign.LEFT;
				
				addChild(nameField);
				addChild(scoreField);
				
				height += nameField.height;
			}
			
			backBtn = new Button(AssetManager.getSingleAsset("ui", "BackBtn"));
			setButtonAttributes((stage.stageWidth - backBtn.width) / 2, stage.stageHeight - backBtn.height - Config.SPACING_BENEATH_PX, backBtn, "Back to menu");
			
			addChild(backBtn);
			backBtn.addEventListener(Event.TRIGGERED, toStart);
		}
		
		private function orderResults(results:Object):Array {
			var scores:Array = new Array();
			for (var name:String in results) {
				scores.push({"name": name, "score": results[name]});
			}
			return scores.sortOn("score", Array.DESCENDING | Array.NUMERIC);
		}
	}

}