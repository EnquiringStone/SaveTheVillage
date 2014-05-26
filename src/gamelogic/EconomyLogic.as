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
		private var educationPoints:int;
		private var transferAmount:int;
		
		//The class that updates and remembers everything that has to do with the economy
		public function EconomyLogic(mainGame:MainGameScreen, allData:Object = null, educationPoints:int = -1) 
		{
			this.mainGame = mainGame;
			if (allData == null) {
				this.allData = Config.DEFAULT_DATA_OBJECT;
				setDefaultValues();
			} else {
				this.allData = allData;
			}
			this.educationPoints = educationPoints == -1 ? Config.DEFAULT_STARTING_EDUCATION_POINTS : educationPoints;
		}
		
		public function getValuesByStructureName(name:String):Object {
			if (!this.mainGame.getMapLogic().isDead(name)) {
				return allData[name];
			}
			return null;
		}
		
		public function setValuesByName(name:String):void {
			
		}
		
		public function update():void {
			
		}
		
		public function getEducationPoints():int {
			return this.educationPoints;
		}
		
		public function addResources(name:String):void {
			var data:Object = allData[name];
			data["Resources"] = parseInt(data["Resources"]) + transferAmount;
		}
		
		public function removeResources(name:String, amount:int):void {
			var data:Object = allData[name];
			data["Resources"] = parseInt(data["Resources"]) - amount;
		}
		
		public function addKnowledge(name:String):void {
			var data:Object = allData[name];
			data["Knowledge"] = parseInt(data["Knowledge"]) + transferAmount;
		}
		
		public function removeKnowledge(name:String, amount:int):void {
			var data:Object = allData[name];
			trace(data["Knowledge"]);
			data["Knowledge"] = parseInt(data["Knowledge"]) - amount;
			trace(data["Knowledge"]);
		}
		
		
		public function getRawData():String {
			return "{\"EconomyLogic\":{}}";
		}
		
		public function setValuesFromRawData(json:String):void {
			
		}
		
		public function setTransferAmount(amount:int):void {
			this.transferAmount = amount;
		}
		
		private function setDefaultValues():void {
			var difficulty:String = this.mainGame.processSettings().difficulty;
			difficulty = difficulty == "" ? Config.DIFFICULTY_SETTINGS[Config.STANDARD_DIFFICULTY_SETTING] : difficulty;
			for (var name:String in allData) {
				if (Config.STRUCTURE_POSITIONS[name].type == "city") {
					allData[name]["Knowledge gain"] = Config.DEFAULT_GROWING_RATE_KNOWLEDGE;
					allData[name]["Spread rate"] = Config.DEFAULT_SPREAD_RATE_CITY;
					allData[name]["Infected"] = Config.DEFAULT_INFECTED_PEOPLE_CITY;
					allData[name]["Resources"] = Config.DEFAULT_STARTING_RESOURCES_CITY;
					allData[name]["Knowledge"] = Config.DEFAULT_STARTING_KNOWLEDGE_CITY;
					allData[name]["Resource consume"] = Config.DEFAULT_CONSUME_RESOURCES_CITY;
					allData[name]["Population"] = Config.DEFAULT_TOTAL_POPULATION_CITY;
					allData[name]["Limit resources"] = Config.DEFAULT_LIMIT_RESOURCES_CITY;
					allData[name]["Limit knowledge"] = Config.DEFAULT_LIMIT_KNOWLEDGE_CITY;
				} else if (Config.STRUCTURE_POSITIONS[name].type == "village") {
					allData[name]["Spread rate"] = Config.DEFAULT_SPREAD_RATE_VILLAGE;
					allData[name]["Infected"] = Config.DEFAULT_INFECTED_PEOPLE_VILLAGE;
					allData[name]["Resources"] = Config.DEFAULT_STARTING_RESOURCES_VILLAGE;
					allData[name]["Knowledge"] = 0;
					allData[name]["Resource consume"] = Config.DEFAULT_CONSUME_RESOURCES_VILLAGE;
					allData[name]["Population"] = Config.DEFAULT_TOTAL_POPULATION_VILLAGE;
					allData[name]["Limit resources"] = Config.DEFAULT_LIMIT_RESOURCES_VILLAGE;
					allData[name]["Limit knowledge"] = Config.DEFAULT_LIMIT_KNOWLEDGE_VILLAGE;
					
				}
			}
		}
		
	}

}