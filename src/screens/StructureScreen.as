package screens 
{
	import gamelogic.EconomyLogic;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import util.Config;
	import util.AssetManager;
	/**
	 * ...
	 * @author Johan
	 */
	public class StructureScreen extends BaseScreen 
	{
		private var info:Object;
		private var quad:Quad;
		private var economyLogic:EconomyLogic;
		public function StructureScreen(main:ScreenMaster, info:Object, economyLogic:EconomyLogic) 
		{
			super(main);
			this.info = info;
			this.economyLogic = economyLogic;
		}
		
		public function initialize(event:Event):void {
			var height:int = (Config.MIN_HEIGHT_ADD_SCREEN <= stage.stageHeight - Config.SPACING_BENEATH_LARGE_PX - Config.SPACING_ABOVE_LARGE_PX) 
				? Config.MIN_HEIGHT_ADD_SCREEN 
				: stage.stageHeight - Config.SPACING_BENEATH_LARGE_PX - Config.SPACING_ABOVE_LARGE_PX;
			quad = new Quad(stage.stageWidth - Config.SPACING_LEFT_PX - Config.SPACING_RIGHT_PX, height, Config.GAME_MENU_COLOR);
			quad.x = (stage.stageWidth - quad.width) / 2;
			quad.y = (stage.stageHeight - quad.height) / 2;
			
			if (info != null) {
				var structureImage:Image = new Image(AssetManager.getSingleAsset("ui", info.asset));
				structureImage.x = quad.x;
				structureImage.y = quad.y;
				
				var textWidthNextToPicture:int = quad.width - structureImage.width - Config.SPACING_LEFT_PX;
				
				var title:TextField = new TextField(textWidthNextToPicture, 20, info.name, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_TITLE, Config.TEXT_COLOR_GENERAL, true);
				title.hAlign = HAlign.LEFT;
				var descriptionHeight:int = structureImage.height - title.height;
				
				title.x = quad.x + structureImage.width + Config.SPACING_LEFT_PX;
				title.y = quad.y + Config.SPACING_ABOVE_PX;
				
				var description:TextField = new TextField(textWidthNextToPicture, descriptionHeight, info.description, Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
				description.autoScale = true;
				description.hAlign = HAlign.LEFT;;
				description.x = structureImage.x + structureImage.width + Config.SPACING_LEFT_PX;
				description.y = title.y + title.height;
			}
			addChild(quad);
			addChild(structureImage);
			addChild(title);
			addChild(description);
		}
		
		protected function getInfo():Object {
			return this.info;
		}
		
		protected function getQuad():Quad {
			return this.quad;
		}
		
		protected function getEconomyLogic():EconomyLogic {
			return this.economyLogic;
		}
		
	}

}