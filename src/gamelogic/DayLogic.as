package gamelogic 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import util.Config;
	import util.ArrayUtil;
	import ao.ExternalStorageAO;
	import ScreenMaster;
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
		private var main:ScreenMaster;
		
		//Create timer, wait for events
		//Update meters, When timer is dispatched see if there is a random event
		public function DayLogic(main:ScreenMaster, durationSetting:int = -1) 
		{
			this.main = main;
			randomEvent = new RandomEventLogic();
			this.duration = durationSetting == -1 ? Config.DURATION_SETTINGS[processSettings()] : Config.DURATION_SETTINGS[durationSetting];
			dayTimer = new Timer(Config.DAYS_IN_SECONDS * 1000);
			dayTimer.addEventListener(TimerEvent.TIMER, update);
			dayTimer.start();
		}
		
		public function update(event:TimerEvent):void {
			dayCount ++;
			if (dayCount > duration) {
				dayTimer.stop();
				main.loadScreen("score");
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
		
		public function processSettings():Number {
			var dataString:String = ExternalStorageAO.loadFile(Config.SAVE_SETTINGS_FILE);
			var dataObject:Object = ArrayUtil.getValuePair(dataString);
			return parseInt(dataObject.duration);
		}
		
		public function calculateScore():Number {
			return 0;
		}
	}

}