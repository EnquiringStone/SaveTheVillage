package screens 
{
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.core.Starling;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import util.Config;
	import util.AssetManager;
	/**
	 * ...
	 * @author Johan
	 */
	public class TutorialScreen extends BaseScreen 
	{
		private var mainGame:MainGameScreen;
		private var video:Loader;
		private var context:LoaderContext;
		private var textBaloon:TextField;
		private var imageBaloon:Image;
		private var index:int;
		private var readTimer:Timer;
		
		public function TutorialScreen(main:ScreenMaster) 
		{
			super(main);
			index = 0;
			context = new LoaderContext();
			context.allowCodeImport = true; //Android specific
			mainGame = new MainGameScreen(main);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize(event:Event):void {
			addChild(mainGame);
			this.mainGame.disableListeners();
			this.mainGame.getDayLogic().getTimer().stop();
			
			video = new Loader();
			addCharacter();
			
			index ++;
			
			this.mainGame.getMenuBtn().addEventListener(Event.TRIGGERED, disableSave);
			
			readTimer = new Timer(Config.READ_TIME_IN_SECONDS * 1000, Config.INTRODUCTION_TEXT.length);
			readTimer.addEventListener(TimerEvent.TIMER, nextDialogue);
			readTimer.addEventListener(TimerEvent.TIMER_COMPLETE, swipeMap);
			readTimer.start();
		}
		
		public function disableSave(event:Event):void {
			if (this.mainGame.getSaveButton() != null) {
				this.mainGame.getSaveButton().enabled = false;
			}
		}
		
		public function nextDialogue(event:TimerEvent):void {
			textBaloon.text = Config.INTRODUCTION_TEXT[index];
			index ++;
		}
		
		public function swipeMap(event:TimerEvent):void {
			removeCharacter();
			
			video.loadBytes(AssetManager.getVideoAsset(AssetManager.SwipeMap), context);
			video.x = (stage.stageWidth - 105) / 2;
			video.y = (stage.stageHeight - 120) / 2;
			
			this.mainGame.addHelpMessage(Config.SWIPE_MAP_TEXT);
			this.mainGame.enableListeners();
			
			index = 0;
			readTimer = new Timer(Config.READ_TIME_IN_SECONDS * 1000, 1);
			readTimer.addEventListener(TimerEvent.TIMER, tap);
			readTimer.start();
			
			Starling.current.nativeOverlay.addChild(video);
		}
		
		public function tap(event:TimerEvent):void {
			this.mainGame.removeHelpMessage();
			Starling.current.nativeOverlay.removeChild(video);
			video.unloadAndStop();
			
			video.loadBytes(AssetManager.getVideoAsset(AssetManager.TapGesture), context);
			video.x = (stage.stageWidth - 105) / 2;
			video.y = (stage.stageHeight - 120) / 2;
			
			this.mainGame.addHelpMessage(Config.TAP_VILLAGE_TEXT);
			
			Starling.current.nativeOverlay.addChild(video);
			this.mainGame.getBGImage().addEventListener(TouchEvent.TOUCH, tapVillage);
		}
		
		public function tapVillage(event:TouchEvent):void {
			if (tappedStructure(event, "village")) {
				this.mainGame.removeHelpMessage();
				this.mainGame.getBGImage().removeEventListener(TouchEvent.TOUCH, tapVillage);
				Starling.current.nativeOverlay.removeChild(video);
				video.unloadAndStop();
				
				this.mainGame.disableListeners();
				if (this.mainGame.getStructureScreen() != null) {
					this.mainGame.getStructureScreen().disableListeners();
				}
				addCharacter();
				readTimer = new Timer(Config.READ_TIME_IN_SECONDS * 1000, Config.TAPPED_VILLAGE_SUCCESS_TEXT.length);
				readTimer.addEventListener(TimerEvent.TIMER, tappedVillage);
				readTimer.addEventListener(TimerEvent.TIMER_COMPLETE, tappedVillageEnd);
				readTimer.start();
				textBaloon.text = Config.TAPPED_VILLAGE_SUCCESS_TEXT[index];
				index ++;
			}
		}
		
		public function tappedVillage(event:TimerEvent):void {
			textBaloon.text = Config.TAPPED_VILLAGE_SUCCESS_TEXT[index];
			index ++;
		}
		
		public function tappedVillageEnd(event:TimerEvent):void {
			index = 0;
			removeCharacter();
			this.mainGame.getStructureScreen().getBuyButton().addEventListener(Event.TRIGGERED, hqInfo);
			this.mainGame.addHelpMessage(Config.TAP_VILLAGE_END_TEXT);
		}
		
		public function hqInfo(event:Event):void {
			this.mainGame.getStructureScreen().toHQ(event);
			this.mainGame.removeHelpMessage();
			this.mainGame.getStructureScreen().disableListeners();
			addCharacter();
			textBaloon.text = Config.HQ_INFO_TEXT[index];
			index ++;
			readTimer = new Timer(Config.READ_TIME_IN_SECONDS * 1000, Config.HQ_INFO_TEXT.length);
			readTimer.addEventListener(TimerEvent.TIMER, hqInfoText);
			readTimer.addEventListener(TimerEvent.TIMER_COMPLETE, hqInfoEnd);
			readTimer.start();
		}
		
		public function hqInfoText(event:TimerEvent):void {
			if (this.mainGame.getStructureScreen() != null) {
				this.mainGame.getStructureScreen().disableListeners();
			}
			if (index == 1) {
				this.mainGame.getEducationPointsText().visible = true;
			} else if (index == 2) {
				this.mainGame.getDayCountText().visible = true;
			}
			textBaloon.text = Config.HQ_INFO_TEXT[index];
			index ++;
		}
		
		public function hqInfoEnd(event:TimerEvent):void {
			removeCharacter();
			index = 0;
			this.mainGame.getStructureScreen().enableListeners();
			this.mainGame.addHelpMessage(Config.HQ_INFO_END_TEXT);
			this.mainGame.getStructureScreen().addEventListener(Event.REMOVED_FROM_STAGE, buyInfo);
		}
		
		public function buyInfo(event:Event):void {
			this.mainGame.removeHelpMessage();
			this.mainGame.getBGImage().addEventListener(TouchEvent.TOUCH, boughtResource);
		}
		
		public function boughtResource(event:TouchEvent):void {
			if (tappedStructure(event, "village") || tappedStructure(event, "city") || tappedStructure(event, "hq")) {
				this.mainGame.getBGImage().removeEventListener(TouchEvent.TOUCH, boughtResource);
				this.mainGame.getDayLogic().getTimer().stop();
				this.mainGame.disableListeners();
				addCharacter();
				textBaloon.text = Config.BOUGHT_RESOURCE_TEXT[index];
				index ++;
				readTimer = new Timer(Config.READ_TIME_IN_SECONDS * 1000, Config.BOUGHT_RESOURCE_TEXT.length);
				readTimer.addEventListener(TimerEvent.TIMER, boughtText);
				readTimer.addEventListener(TimerEvent.TIMER_COMPLETE, boughtResourceEnd);
				readTimer.start();
			}
		}
		
		public function boughtText(event:TimerEvent):void {
			this.mainGame.getDayLogic().getTimer().stop();
			if (this.mainGame.getStructureScreen() != null) {
				this.mainGame.getStructureScreen().disableListeners();
			}
			textBaloon.text = Config.BOUGHT_RESOURCE_TEXT[index];
			index ++;
		}
		
		public function boughtResourceEnd(event:TimerEvent):void {
			index = 0;
			removeCharacter();
			this.mainGame.addHelpMessage(Config.CITY_TRANSFER_INFO_TEXT);
			this.mainGame.enableListeners();
			this.mainGame.getBGImage().addEventListener(TouchEvent.TOUCH, cityInfo);
		}
		
		public function cityInfo(event:TouchEvent):void {
			if (tappedStructure(event, "city")) {
				if (this.mainGame.getStructureScreen() != null) {
					this.mainGame.getStructureScreen().disableListeners();
				}
				this.mainGame.getBGImage().removeEventListener(TouchEvent.TOUCH, cityInfo);
				this.mainGame.removeHelpMessage();
				addCharacter();
				textBaloon.text = Config.CITY_TRANSFER_TEXT[index];
				index ++;
				this.mainGame.disableListeners();
				readTimer = new Timer(Config.READ_TIME_IN_SECONDS * 1000, Config.CITY_TRANSFER_TEXT.length);
				readTimer.addEventListener(TimerEvent.TIMER, cityInfoUpdate);
				readTimer.addEventListener(TimerEvent.TIMER_COMPLETE, cityInfoEnd);
				readTimer.start();
			}
		}
		
		public function cityInfoUpdate(event:TimerEvent):void {
			if (this.mainGame.getStructureScreen() != null) {
				this.mainGame.getStructureScreen().disableListeners();
			}
			textBaloon.text = Config.CITY_TRANSFER_TEXT[index];
			index ++;
		}
		
		public function cityInfoEnd(event:TimerEvent):void {
			removeCharacter();
			index = 0;
			this.mainGame.enableListeners();
			
			this.mainGame.getBGImage().addEventListener(TouchEvent.TOUCH, finalLesson);
		}
		
		public function finalLesson(event:TouchEvent):void {
			if (tappedStructure(event, "village") || tappedStructure(event, "city") || tappedStructure(event, "hq")) {
				this.mainGame.getBGImage().removeEventListener(TouchEvent.TOUCH, finalLesson);
				this.mainGame.disableListeners();
				this.mainGame.removeHelpMessage();
				
				addCharacter();
				readTimer = new Timer(Config.READ_TIME_IN_SECONDS * 1000, Config.FINAL_LESSON_SPEECH.length);
				readTimer.addEventListener(TimerEvent.TIMER, finalLessonUpdate);
				readTimer.addEventListener(TimerEvent.TIMER_COMPLETE, finalLessonEnd);
				readTimer.start();
				textBaloon.text = Config.FINAL_LESSON_SPEECH[index];
				index ++;
			}
			
		}
		
		public function finalLessonUpdate(event:TimerEvent):void {
			this.mainGame.getDayLogic().getTimer().stop();
			if (this.mainGame.getStructureScreen() != null) {
				this.mainGame.getStructureScreen().disableListeners();
			}
			textBaloon.text = Config.FINAL_LESSON_SPEECH[index];
			index ++;
		}
		
		public function finalLessonEnd(event:TimerEvent):void {
			removeCharacter();
			this.main.loadScreen("start");
		}
		
		private function tappedStructure(event:TouchEvent, structureType:String):Boolean {
			var touch:Touch = event.getTouch(mainGame);
			var target:Image = event.target as Image;
			if (touch != null) {
				if (touch.phase == TouchPhase.BEGAN) {
					var structure:Object = this.mainGame.getMapLogic().isStructure(touch.getLocation(mainGame), new Point(this.mainGame.getBGImage().x, this.mainGame.getBGImage().y));
					if (structure != null) {
						return structure.type == structureType;
					}
				}
			}
			return false;
		}
		
		private function addCharacter():void {
			video.loadBytes(AssetManager.getVideoAsset(AssetManager.Character), context);	
			video.x = Config.SPACING_LEFT_PX;
			video.y = stage.stageHeight - 280 - Config.SPACING_BENEATH_PX; //280 is the height of the video (.height doesn't work)
			
			imageBaloon = new Image(AssetManager.getSingleAsset("ui", "TextBaloon"));
			imageBaloon.x = stage.stageWidth - imageBaloon.width - Config.SPACING_RIGHT_PX;
			imageBaloon.y = video.y - imageBaloon.height - Config.SPACING_BENEATH_PX;
			
			textBaloon = new TextField(175, 200, Config.INTRODUCTION_TEXT[index], Config.TEXT_FONT_TYPE, Config.TEXT_SIZE_GENERAL, Config.TEXT_COLOR_GENERAL);
			textBaloon.hAlign = HAlign.LEFT;
			textBaloon.vAlign = VAlign.TOP;
			textBaloon.x = imageBaloon.x + 30;
			textBaloon.y = imageBaloon.y + 15;
			
			addChild(imageBaloon);
			addChild(textBaloon);
			Starling.current.nativeOverlay.addChild(video);
		}
		
		private function removeCharacter():void {
			removeChild(imageBaloon);
			removeChild(textBaloon);
			Starling.current.nativeOverlay.removeChild(video);
			video.unloadAndStop();
		}
	}

}