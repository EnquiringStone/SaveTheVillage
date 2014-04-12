package screens 
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import util.AssetManager;
	/**
	 * ...
	 * @author Johan
	 */
	public class MainGameScreen extends BaseScreen 
	{
		private var bgImage:Image;
		
		public function MainGameScreen(main:ScreenMaster) 
		{
			super(main);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize(event:Event):void {
			bgImage = new Image(AssetManager.getSingleAsset("ui", "MainGameBg"));
			addChild(bgImage);
			
			bgImage.addEventListener(TouchEvent.TOUCH, detectMoveTouch);
		}
		
		public function detectMoveTouch(event:TouchEvent) {
			var touch:Touch = event.getTouch(this);
			var target:Image = event.target as Image;
			if (touch != null) {
				if (touch.phase == TouchPhase.MOVED) {
					moveImageByTouch(touch, target);
				}
			}
		}
		
		public function moveImageByTouch(touch:Touch, target:Image) {
			var point:Point = touch.getMovement(this);
			target.x += point.x;
			if (target.x > 0) target.x = 0;
			if (target.x < (target.width - stage.stageWidth) * -1) target.x = (target.width - stage.stageWidth) * -1;
			
			target.y += point.y;
			if (target.y > 0) target.y = 0;
			if (target.y < (target.height - stage.stageHeight) * -1) target.y = (target.height - stage.stageHeight) * -1;
		}
	}

}