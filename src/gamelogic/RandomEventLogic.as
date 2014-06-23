package gamelogic 
{
	import screens.MainGameScreen;
	import util.Config;
	import util.ArrayUtil;
	/**
	 * ...
	 * @author Johan
	 */
	public class RandomEventLogic implements LogicInterface
	{
		private var change:Number;
		private var mainGame:MainGameScreen;

		public function RandomEventLogic(mainGame:MainGameScreen = null) 
		{
			change = Config.STARTING_CHANGE;
			this.mainGame = mainGame;
		}
		
		public function update():void {
			if (hasRandomEvent()) {
				var allEvents:Object = Config.RANDOM_EVENTS;
				var number:Number = Math.ceil(Math.random() * 10);
				number = number == 0 ? number + 1 : number;
				
				var event:Object = getEvent();
				setValues(event);
				this.mainGame.createRandomEventMessage(event);
				
				change = Config.STARTING_CHANGE;
			} else {
				change += Config.CHANGE_INCREASE;
			}
		}
		
		public function getRawData():String {
			return "\"RandomEventLogic\": { \"change\": "+change+" }";
		}
		
		public function setValuesFromRawData(data:Object):void {
			this.change = data.change;
		}
		
		public function setMainGame(mainGame:MainGameScreen):void {
			this.mainGame = mainGame;
		}
		
		private function hasRandomEvent():Boolean {
			var number:Number = Math.random() * 100;
			return number < change;
		}
		
		private function getEvent():Object {
			var allEvents:Object = Config.RANDOM_EVENTS;
			var number:Number = Math.ceil(Math.random() * 10);
			number = number == 0 ? number + 1 : number;
			
			return allEvents["Event" + number];
		}
		
		private function setValues(data:Object):void {
			for (var name:String in Config.STRUCTURE_POSITIONS) {
				if (ArrayUtil.inArray(data.type, Config.STRUCTURE_POSITIONS[name].type)) {
					for (var effect:String in data.effects) {
						this.mainGame.getEconomyLogic().getAllData()[name][effect] += data.effects[effect];
					}
				}
			}
		}		
	}

}