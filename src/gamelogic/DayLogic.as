package gamelogic 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import screens.CityDetailScreen;
	import screens.HQDetailScreen;
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
		private var durationSetting:String;
		
		//Update meters, When timer is dispatched see if there is a random event
		public function DayLogic(mainGame:MainGameScreen = null) 
		{
			this.mainGame = mainGame;
			randomEvent = new RandomEventLogic();
			
			if (mainGame != null) {
				parseDuration(this.mainGame.processSettings().duration);
				this.durationSetting = this.mainGame.processSettings().duration;
			}
			
			dayTimer = new Timer(Config.DAYS_IN_SECONDS * 1000);
			dayTimer.addEventListener(TimerEvent.TIMER, update);
			dayTimer.start();
		}
		
		/**
		 * 
		 * @param	event
		 */
		public function update(event:TimerEvent):void {
			dayCount ++;
			if (!unlimited && dayCount > duration) {
				dayTimer.stop();
				this.mainGame.disableListeners(); //Too avoid any nullpointer exceptions
				this.mainGame.getMain().loadScreen("score");
			}
			
			this.mainGame.getEconomyLogic().update();
			this.mainGame.getMapLogic().update();
			this.mainGame.updateBars();
			this.mainGame.updateDayField();
			this.mainGame.updateEducationPointsField();
			this.mainGame.getRandomEventLogic().update();
			
			if (this.mainGame.getStructureScreen() != null) {
				var name:String = this.mainGame.getStructureScreen().getInfo().name;
				if (this.mainGame.getMapLogic().isDead(name)) this.mainGame.getStructureScreen().updateValues();
				else { this.mainGame.getStructureScreen().updateValues(this.mainGame.getEconomyLogic().getAllData()[name]); }
				
				var type:String = this.mainGame.getStructureScreen().getInfo().type;
				if (type == "city" && !this.mainGame.getMapLogic().isDead(name)) {
					var cityScreen:CityDetailScreen = this.mainGame.getStructureScreen() as CityDetailScreen;
					cityScreen.updateTransferKnowledgeBtn();
				} else if (type == "hq") {
					var hqScreen:HQDetailScreen = this.mainGame.getStructureScreen() as HQDetailScreen;
					hqScreen.updateButtons();
				}
			}
		}
		
		public function getTimer():Timer {
			return this.dayTimer;
		}
		
		public function getRawData():String {
			return "\"DayLogic\" : {\"dayCount\":"+this.dayCount+", \"durationSetting\": \""+this.durationSetting+"\"}";
		}
		
		public function setValuesFromRawData(data:Object):void {
			setDayCount(parseInt(data.dayCount));
			parseDuration(data.durationSetting);
		}
		
		public function setDayCount(dayCount:Number):void {
			this.dayCount = dayCount;
		}
		
		public function getDayCount():int {
			return this.dayCount;
		}
		
		public function calculateScore():Number {
			return 0;
		}
		
		public function setMainGame(mainGame:MainGameScreen):void {
			this.mainGame = mainGame;
		}
		
		private function parseDuration(value:String):void {
			this.durationSetting = value;
			if 		(value == "Unlimited") 	{ unlimited = true; } 
			else if (value == "") 			{ this.duration = Config.DURATION_SETTINGS[Config.STANDARD_DURATION_SETTING]; } 
			else 							{ this.duration = parseInt(value); }
		}
	}

}