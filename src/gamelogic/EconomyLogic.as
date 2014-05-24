package gamelogic 
{
	import screens.MainGameScreen;
	import util.Config;
	/**
	 * ...
	 * @author Johan
	 */
	public class EconomyLogic implements LogicInterface
	{
		private var mainGame:MainGameScreen;
		private var allData:Object;
		
		//The class that updates and remembers everything that has to do with the economy
		public function EconomyLogic(mainGame:MainGameScreen, allData:Object = null) 
		{
			this.mainGame = mainGame;
			if (allData == null) {
				this.allData = Config.DEFAULT_DATA_OBJECT;
			}
			this.allData = allData == null ? Config.DEFAULT_DATA_OBJECT : allData;
			
		}
		
		public function getValuesByStructureName(name:String):Object {
			if (!this.mainGame.getMapLogic().isDead(name)) {
				var data:Object = { "Infection rate": "10%", "Infected": "19%", "Resources": "267", "Knowledge": "25" };
				return data;
			}
			return null;
		}
		
		public function setValuesByName(name:String):void {
			
		}
		
		public function update():void {
			
		}
		
		public function getRawData():String {
			return "{\"EconomyLogic\":{}}";
		}
		
		public function setValuesFromRawData(json:String):void {
			
		}
		
		private function setDefaultValues():void {
			var difficulty:String = this.mainGame.processSettings().difficulty;
			difficulty = difficulty == "" ? Config.DIFFICULTY_SETTINGS[Config.STANDARD_DIFFICULTY_SETTING] : difficulty;
			for each(var values:Object in allData) {
				
			}
		}
		
	}

}