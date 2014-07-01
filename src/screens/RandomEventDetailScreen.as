package screens 
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import util.Config;
	import util.AssetManager;
	/**
	 * ...
	 * @author Johan
	 */
	public class RandomEventDetailScreen extends Sprite
	{
		private var message:String;
		private var mainGame:MainGameScreen;
		
		public function RandomEventDetailScreen(data:Object, mainGame:MainGameScreen) 
		{
			this.message = data.message;
			this.mainGame = mainGame;
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize(event:Event):void {
			var popUp:Image = new Image(AssetManager.getSingleAsset("ui", "PopupScreen"));
			popUp.x = (stage.stageWidth - popUp.width) / 2;
			popUp.y = (stage.stageHeight - popUp.height) / 2;
			
			var textField:TextField = new TextField(popUp.width - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, 0, message, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			textField.autoSize = TextFieldAutoSize.VERTICAL;
			
			var exitBtn:Button = new Button(AssetManager.getSingleAsset("ui", "SmallPlayBtn"));
			exitBtn.text = "Ok";
			exitBtn.fontColor = Config.TEXT_COLOR_BUTTON;
			exitBtn.fontSize = Config.TEXT_SIZE_BUTTON;
			exitBtn.fontName = Config.TEXT_FONT_TYPE;
			exitBtn.addEventListener(Event.TRIGGERED, this.mainGame.removeRandomEventMessage);
			
			textField.x = popUp.x + Config.SPACING_LEFT_PX;
			textField.y = popUp.y + Config.SPACING_ABOVE_PX;
			
			exitBtn.x = popUp.x + popUp.width - exitBtn.width;
			exitBtn.y = popUp.y + popUp.height - Config.SPACING_BENEATH_PX - exitBtn.height;
			
			addChild(popUp);
			addChild(textField);
			addChild(exitBtn);
		}
	}

}