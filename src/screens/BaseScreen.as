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
	 * Acts as a view within the MVC
	 * @author Johan
	 */
	public class BaseScreen extends Sprite 
	{
		protected var main:ScreenMaster;
		private var logo:Image;
		
		/**
		 * Constructor of the BaseScreen
		 * @param	main
		 */
		public function BaseScreen(main:ScreenMaster) 
		{
			super();
			this.main = main;
		}
		
		/**
		 * Disposes current screen and removes the logo, if present
		 */
		public function disposeScreen():void {
			if (getChildIndex(logo) != -1) {
				removeChild(logo);
			}
		}
		
		/**
		 * Adds the logo of the game on the screen at a set position
		 */
		protected function putLogoOnScreen():void {
			if (logo == null) {
				logo = new Image(AssetManager.getSingleAsset("ui", "GameLogo"));
				logo.x = (stage.stageWidth - logo.width) / 2;
				logo.y = 0;
			}
			addChild(logo);
		}
		
		/**
		 * Return the image of the logo
		 * @return Image
		 */
		protected function getLogo():Image {
			return logo;
		}
		
		/**
		 * Sets the buttons attributes like the x and y positions, and the text
		 * @param	x
		 * @param	y
		 * @param	button
		 * @param	text
		 */
		protected function setButtonAttributes(x:int, y:int, button:Button, text:String):void {
			button.x = x;
			button.y = y;
			button.text = text;
			button.fontColor = Config.TEXT_COLOR_BUTTON;
			button.fontSize = Config.TEXT_SIZE_BUTTON;
		}
		
		/**
		 * Loads the start screen
		 */
		protected function toStart():void {
			main.loadScreen("start");
		}
		
		public function getMain():ScreenMaster {
			return this.main;
		}
	}

}