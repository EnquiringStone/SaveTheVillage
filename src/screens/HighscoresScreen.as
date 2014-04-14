package screens 
{
	import starling.display.Button;
	import starling.events.Event;
	
	import util.AssetManager;
	import util.Config;
	/**
	 * ...
	 * @author Johan
	 */
	public class HighscoresScreen extends BaseScreen 
	{
		private var backBtn:Button;
		
		public function HighscoresScreen(main:ScreenMaster) 
		{
			super(main);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize(event:Event):void {
			putLogoOnScreen();
			
			backBtn = new Button(AssetManager.getSingleAsset("ui", "MenuBtn"));
			setButtonAttributes((stage.stageWidth - backBtn.width) / 2, getLogo().height + Config.SPACING_ABOVE_PX, backBtn, "Back to menu");
			
			addChild(backBtn);
			backBtn.addEventListener(Event.TRIGGERED, toStart);
		}
	}

}