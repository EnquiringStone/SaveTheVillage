package screens 
{
	import starling.display.Button;
	import starling.events.Event;
	import util.AssetManager;
	/**
	 * ...
	 * @author Johan
	 */
	public class ScoreScreen extends BaseScreen 
	{
		private var score:int;
		
		public function ScoreScreen(main:ScreenMaster, score:String) 
		{
			super(main);
			this.score = parseInt(score);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize():void {
			var button:Button = new Button(AssetManager.getSingleAsset("ui", "BackBtn"));
			setButtonAttributes((stage.stageWidth - button.width) / 2, (stage.stageHeight - button.height) / 2, button, "Back to menu");
			button.addEventListener(Event.TRIGGERED, toStart);
			
			addChild(button);
		}
		
	}

}