package gamelogic 
{
	import screens.MainGameScreen;
	/**
	 * ...
	 * @author Johan
	 */
	public class EconomyLogic implements LogicInterface
	{
		private var mainGame:MainGameScreen;
		
		//The class that updates and remembers everything that has to do with the economy
		public function EconomyLogic(mainGame:MainGameScreen) 
		{
			this.mainGame = mainGame;
		}
		
		public function getValuesByStructureName(name:String):Object {
			if (!this.mainGame.getMapLogic().isDead(name)) {
				var data:Object = { "Infection rate": "10%", "Infected": "19%", "Resources": "267", "Knowledge": "25" };
				return data;
			}
			return null;
		}
		
		public function getRawData():String {
			return "{\"EconomyLogic\":{}}";
		}
		
		public function setValuesFromRawData(json:String):void {
			
		}
		
	}

}