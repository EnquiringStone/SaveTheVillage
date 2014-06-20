package gamelogic 
{
	import flash.geom.Point;
	import screens.MainGameScreen;
	import starling.display.Quad;
	import starling.display.Sprite;
	import util.Config;
	import util.ArrayUtil;
	/**
	 * ...
	 * @author Johan
	 */
	public class MapLogic implements LogicInterface
	{
		private var deadStructures:Array = new Array();
		private var mainGame:MainGameScreen;

		public function MapLogic(mainGame:MainGameScreen = null) 
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
				} else if (data.type == "village") {
					width = Config.VILLAGE_WIDTH / 2;
					height = Config.VILLAGE_HEIGHT / 2;
				} else if (data.type == "hq") {
					width = Config.HQ_WIDTH / 2;
					height = Config.HQ_HEIGHT / 2;
				}
				
				if (x >= data.x - width && x <= data.x + width && y >= data.y - height && y <= data.y + height) {
					return data;
				}
			}
			return null;
		}
		
		public function getStructure(name:String):Object {
			return Config.STRUCTURE_POSITIONS[name];
		}
		
		public function addDeadStructure(structureName:String):void {
			deadStructures.push(structureName);
		}
		
		public function isDead(name:String):Boolean {
			return ArrayUtil.inArray(deadStructures, name);
		}
		
		public function update():void {
			var data:Object = this.mainGame.getEconomyLogic().getAllData();
			for (var key:String in data) {
				if (this.mainGame.getEconomyLogic().getInfectedPercentageByName(key) >= Config.DEFAULT_MAX_PERCENTAGE_INFECTED) {
					addDeadStructure(key);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getRawData():String {
			var structures:String = "[";
			for each(var item:String in deadStructures) {
				structures += "\""+item+"\",";
			}
			if (structures != "[") {
				structures = structures.slice(0, -1);
			}
			structures += "]";
			return "\"MapLogic\": { \"deadStructures\": "+structures+" }";
		}
		
		/**
		 * @inheritDoc
		 */
		public function setValuesFromRawData(data:Object):void {
			this.deadStructures = data.deadStructures;
		}
		
		public function setMainGame(mainGame:MainGameScreen):void {
			this.mainGame = mainGame;
		}
	}

}