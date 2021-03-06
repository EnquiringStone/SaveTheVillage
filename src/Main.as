package 
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import starling.core.Starling;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	
	/**
	 * The overall class of the application
	 * @author Johan
	 */
	public class Main extends Sprite 
	{
		private var _starling:Starling;
		
		/**
		 * Initializes the Starling entity
		 */
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			//initialize Starling
			Starling.handleLostContext = true;
			_starling = new Starling(ScreenMaster, stage);
			_starling.start();
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}