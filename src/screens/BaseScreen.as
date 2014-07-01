package screens 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
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
		private var background:Image;
		private var bgGradient:Quad;
		
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
		 * Disposes current screen and removes the logo and background, if present
		 */
		public function disposeScreen():void {
			if (getChildIndex(logo) != -1) {
				removeChild(logo);
			} if (getChildIndex(background) != -1) {
				removeChild(background);
			} if (getChildIndex(bgGradient) != -1) {
				removeChild(bgGradient);
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
		 * Adds a background to the screen. Needs to be called before putLogoOnScreen!
		 */
		protected function putBackgroundOnScreen():void {
			putBackgroundColor();
			if (background == null) {
				background = new Image(AssetManager.getSingleAsset("ui", "MenuBG"));
				background.x = (stage.stageWidth - background.width) / 2;
				background.y = 0;
			}
			addChild(background);
		}
		
		protected function putBackgroundColor():void {
			if (bgGradient == null) {
				bgGradient = new Quad(stage.stageWidth, stage.stageHeight);
				bgGradient.setVertexColor(0, 0xa49e14);
				bgGradient.setVertexColor(1, 0xa49e14);
				bgGradient.setVertexColor(2, 0x34502c);
				bgGradient.setVertexColor(3, 0x34502c);
			}
			addChild(bgGradient);
		}
		
		/**
		 * Return the image of the logo
		 * @return Image
		 */
		protected function getLogo():Image {
			return logo;
		}
		
		/**
		 * Return the background of the screen
		 * @return Image
		 */
		protected function getBackground():Image {
			return background;
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
			button.fontName = Config.TEXT_FONT_TYPE;
		}
		
		/**
		 * Loads the start screen
		 */
		protected function toStart():void {
			var sound:Sound = AssetManager.getAudioAsset(AssetManager.MenuBackwardsSound);
			sound.play();
			main.loadScreen("start");
		}
		
		public function getMain():ScreenMaster {
			return this.main;
		}
	}

}