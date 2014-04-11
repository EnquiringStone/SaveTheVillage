package screens 
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import util.AssetManager;
	import util.Config;
	
	/**
	 * ...
	 * @author Johan
	 */
	public class BaseScreen extends Sprite 
	{
		protected var main:ScreenMaster;
		private var logo:Image;
		
		public function BaseScreen(main:ScreenMaster) 
		{
			super();
			this.main = main;
		}
		
		public function disposeScreen():void {
			trace("Disposing of: " + this);
			if (getChildIndex(logo) != -1) {
				removeChild(logo);
			}
		}
		
		protected function putLogoOnScreen():void {
			if (logo == null) {
				logo = new Image(AssetManager.getSingleAsset("ui", "GameLogo"));
				logo.x = (stage.stageWidth - logo.width) / 2;
				logo.y = 0;
			}
			addChild(logo);
		}
		
		protected function getLogo():Image {
			return logo;
		}
		
		protected function setButtonAttributes(x:int, y:int, button:Button, text:String):void {
			button.x = x;
			button.y = y;
			button.text = text;
			button.fontColor = Config.TEXT_COLOR_BUTTON;
			button.fontSize = Config.TEXT_SIZE_BUTTON;
		}
	}

}