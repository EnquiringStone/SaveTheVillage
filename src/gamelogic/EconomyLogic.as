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
		
		public function setValuesByName(keyName:String, valueName:String, value:Number):void {
			this.allData[keyName][valueName] = value;
		}
		
		public function update():void {
			for (var name:String in this.allData) {
				if (!this.mainGame.getMapLogic().isDead(name)) {
					calculateInfected(name);
					calculateSpreadRate(name);
					calculateResources(name);
					if (Config.STRUCTURE_POSITIONS[name].type == "city") {
						calculateKnowledge(name);
					}
				}
			}
			if (this.mainGame.getDayLogic().getDayCount() % 5 == 0) {
				calculateEducationPoints();
			}
		}
		
		public function getEducationPoints():int {
			return this.educationPoints;
		}
		
		public function addResources(name:String):void {
			var data:Object = allData[name];
			data["Resources"] = data["Resources"] + transferAmount;
		}
		
		public function removeResources(name:String, amount:int):void {
			var data:Object = allData[name];
			data["Resources"] = data["Resources"] - amount;
		}
		
		public function addKnowledge(name:String):void {
			var data:Object = allData[name];
			data["Knowledge"] = data["Knowledge"] + transferAmount;
		}
		
		public function removeKnowledge(name:String, amount:int):void {
			var data:Object = allData[name];
			data["Knowledge"] = data["Knowledge"] - amount;
		}
		
		public function addEducationPoints(amount:Number):void {
			this.educationPoints += parseInt(amount.toFixed());
		}
		
		public function removeEducationPoints(amount:Number):void {
			this.educationPoints -= parseInt(amount.toFixed());
		}
		
		
		public function getRawData():String {
			return "{\"EconomyLogic\":{}}";
		}
		
		public function setValuesFromRawData(json:String):void {
			
		}
		
		public function setTransferAmount(amount:int):void {
			this.transferAmount = amount;
		}
		
		public function getInfectedPercentageByName(structureName:String):Number {
			var infected:Number = this.allData[structureName]["Infected"];
			var totalPop:Number = this.allData[structureName]["Population"];
			
			return parseInt(new Number(infected / totalPop * 100).toFixed(1));
		}
		
		public function getKnowledgePercentageByName(structureName:String):Number {
			var knowledge:Number = this.allData[structureName]["Knowledge"];
			var totalKnowledge:Number = this.allData[structureName]["Limit knowledge"];
			
			return parseInt(new Number(knowledge / totalKnowledge * 100).toFixed(1));
		}
		
		public function getResourcesPercentageByName(structureName:String):Number {
			var resources:Number = this.allData[structureName]["Resources"];
			var totalResources:Number = this.allData[structureName]["Limit resources"];
			
			return parseInt(new Number(resources / totalResources * 100).toFixed(1));
		}
		
		public function getTotalKnowledgePoints():Number {
			var value:Number = 0;
			for (var key:String in this.allData) {
				value += this.allData[key]["Knowledge"];
			}
			return value;
		}
		
		public function getAllData():Object {
			return this.allData;
		}
		
		/**
		 * Checks whether the structure has enough resources
		 * @param	structureName
		 * @return
		 */
		private function hasEnoughResources(structureName:String):Boolean {
			return this.allData[structureName]["Resources"] >= this.allData[structureName]["Resource consume"];
		}
		
		/**
		 * Calculates the spread rate increase/decrease
		 * @param	structureName
		 */
		private function calculateSpreadRate(structureName:String):void {
			var value:Number = this.allData[structureName]["Spread rate"];
			var infected:Number = (getInfectedPercentageByName(structureName) + 100) / 100;
			var knowledge:Number = 1 - ((100 - getKnowledgePercentageByName(structureName)) / 100);
			
			value = hasEnoughResources(structureName) 	? value * (infected - knowledge - Config.DEFAULT_HAS_ENOUGH_RESOURCES)
														: value * (infected - knowledge + Config.DEFAULT_HAS_ENOUGH_RESOURCES);
			if (value <= Config.DEFAULT_BASE_SPREAD_RATE) {
				value = Config.DEFAULT_BASE_SPREAD_RATE;
			}
			this.allData[structureName]["Spread rate"] = parseFloat(new Number(value).toFixed(2));
		}
		
		/**
		 * Calculates the resources that will be consumed. Will take knowledge into consideration
		 * @param	structureName
		 */
		private function calculateResources(structureName:String):void {
			var value:Number = this.allData[structureName]["Resources"];
			var knowledge:Number = (100 - getKnowledgePercentageByName(structureName)) / 100;
			value -= this.allData[structureName]["Resource consume"];
			value += this.allData[structureName]["Resource consume"] * (1 - knowledge);
			
			if (value < 0) value = 0;
			this.allData[structureName]["Resources"] = parseInt(value.toFixed());
		}
		
		/**
		 * Calculates the knowledge
		 * @param	structureName
		 */
		private function calculateKnowledge(structureName:String):void {
			var value:Number = this.allData[structureName]["Knowledge"];
			value += parseFloat(new Number(Config.DEFAULT_GROWING_RATE_KNOWLEDGE).toFixed(1));
			
			this.allData[structureName]["Knowledge"] = value;
		}
		
		private function calculateEducationPoints():void {
			educationPoints += parseInt(new Number(Config.DEFAULT_GROWTH_EDUCATION_POINTS + (3 * getTotalKnowledgePoints())).toFixed());
		}
		
		private function calculateInfected(structureName:String):void {
			var value:Number = this.allData[structureName]["Population"] - this.allData[structureName]["Infected"];
			value = this.allData[structureName]["Spread rate"] / 100 * value;
			this.allData[structureName]["Infected"] += value;
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