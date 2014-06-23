package screens 
{
	import starling.display.Button;
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
			var textField:TextField = new TextField(stage.stageWidth - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, 0, message, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			textField.autoSize = TextFieldAutoSize.VERTICAL;
			
			var exitBtn:Button = new Button(AssetManager.getSingleAsset("ui", "SmallPlayBtn"));
			exitBtn.text = "Ok";
			exitBtn.fontColor = Config.TEXT_COLOR_BUTTON;
			exitBtn.fontSize = Config.TEXT_SIZE_BUTTON;
			exitBtn.fontName = Config.TEXT_FONT_TYPE;
			exitBtn.addEventListener(Event.TRIGGERED, this.mainGame.removeRandomEventMessage);
			
			var quad:Quad = new Quad(stage.stageWidth, 100 + exitBtn.height + Config.SPACING_BENEATH_PX + Config.SPACING_ABOVE_PX, Config.GAME_MENU_COLOR);
			quad.x = 0;
			quad.y = (stage.stageHeight - quad.height) / 2;
			
			textField.x = quad.x + Config.SPACING_LEFT_PX;
			textField.y = quad.y + Config.SPACING_ABOVE_PX;
			
			exitBtn.x = quad.x + quad.width - exitBtn.width;
			exitBtn.y = quad.y + quad.height - Config.SPACING_BENEATH_PX - exitBtn.height;
			
			addChild(quad);
			addChild(textField);
			addChild(exitBtn);
		}
	}

}