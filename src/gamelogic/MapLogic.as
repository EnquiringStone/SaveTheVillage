package gamelogic 
{
	import flash.geom.Point;
	import screens.MainGameScreen;
	import starling.display.Quad;
	import starling.display.Sprite;
	import util.Config;
	/**
	 * ...
	 * @author Johan
	 */
	public class MapLogic implements LogicInterface
	{
		private var deadStructures:Array = new Array();
		private var mainGame:MainGameScreen;
		//City/Village touch, When touched create a Village/City/MainHQ screen
		//Create getters for the positions of the cities and villages
		public function MapLogic(mainGame:MainGameScreen) 
		{
			this.mainGame = mainGame;
		}
		
		public function isStructure(touchPoint:Point, bgPos:Point):Object {
			var x:int = touchPoint.x + (bgPos.x * -1);
			var y:int = touchPoint.y + (bgPos.y * -1);
			
			for (var key:String in Config.STRUCTURE_POSITIONS) {
				var data:Object = Config.STRUCTURE_POSITIONS[key];
				
				var width:int = 0;
				var height:int = 0;
				
				if (data.type == "city") {
					width = Config.CITY_WIDTH / 2;
					height = Config.CITY_HEIGHT / 2;
				}
				else if (data.type == "village") {
					width = Config.VILLAGE_WIDTH / 2;
					height = Config.VILLAGE_HEIGHT / 2;
				} else if (data.type == "hq") {
					width = Config.HQ_WIDTH / 2;
					height = Config.HQ_HEIGHT / 2;
				}
				
				if (x >= data.x - width && x <= data.x + width && y >= data.y - height && y <= data.y + height) {
					if (!isDead(data.name)) {
						return data;
					}
				}
			}
			return null;
		}
		
		public function addDeadStructure(structureName:String):void {
			deadStructures.push(structureName);
		}
		
		public function isDead(name:String):Boolean {
			for (var it:int = 0; it < deadStructures.length; it ++) {
				if (deadStructures[it] == name) {
					return true;
				}
			}
			return false;
		}
		
		public function update():void {
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function getRawData():String {
			return "{\"MapLogic\": {}}";
		}
		
		/**
		 * @inheritDoc
		 */
		public function setValuesFromRawData(json:String):void {
			
		}
	}

}