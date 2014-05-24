package gamelogic 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import screens.MainGameScreen;
	import util.Config;
	import util.ArrayUtil;
	import ao.ExternalStorageAO;
	/**
	 * ...
	 * @author Johan
	 */
	public class DayLogic implements LogicInterface
	{
		private var dayTimer:Timer;
		private var randomEvent:RandomEventLogic;
		private var dayCount:int = 0;
		private var duration:int;
		private var mainGame:MainGameScreen;
		private var unlimited:Boolean = false;
		
		//Create timer, wait for events
		//Update meters, When timer is dispatched see if there is a random event
		public function DayLogic(mainGame:MainGameScreen, durationSetting:int = -1) 
		{
			this.mainGame = mainGame;
			randomEvent = new RandomEventLogic();
			
			var duration:String = durationSetting == -1 ? processSettings() : Config.DURATION_SETTINGS[durationSetting];
			if (duration == "Unlimited") unlimited = true;
			else if (duration == "") { this.duration = Config.DURATION_SETTINGS[Config.STANDARD_DURATION_SETTING]; } //file doesn't exist
			else { this.duration = parseInt(duration); }
			
			dayTimer = new Timer(Config.DAYS_IN_SECONDS * 1000);
			dayTimer.addEventListener(TimerEvent.TIMER, update);
			dayTimer.start();
		}
		
		public function update(event:TimerEvent):void {
			dayCount ++;
			if (!unlimited && dayCount > duration) {
				dayTimer.stop();
				this.mainGame.getMain().loadScreen("score");
			}
			
			//update all the things
			trace("update");
		}
		
		public function getTimer():Timer {
			return this.dayTimer;
		}
		
		public function getRawData():String {
			return "{\"DayLogic\" : {\"dayCount\":"+this.dayCount+"}}";
		}
		
		public function setValuesFromRawData(json:String):void {
			var data:Object = JSON.parse(json);
			setDayCount(parseInt(data.dayCount));
		}
		
		public function setDayCount(dayCount:Number):void {
			this.dayCount = dayCount;
		}
		
		public function processSettings():String {
			var dataString:String = ExternalStorageAO.loadFile(Config.SAVE_SETTINGS_FILE);
			if (dataString == null || dataString == "") return ""; //file doesn't exist (not yet changed the settings)
			var dataObject:Object = ArrayUtil.getValuePair(dataString);
			return dataObject.duration;
		}
		
		public function calculateScore():Number {
			return 0;
		}
	}

}