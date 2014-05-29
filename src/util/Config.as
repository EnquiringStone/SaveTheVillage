package util 
{
	/**
	 * The global settings file that can be seen but not altered throughout the application
	 * @author Johan
	 */
	public class Config 
	{
		//Styling
		public static const SPACING_BENEATH_PX:int 			= 10;
		public static const SPACING_ABOVE_PX:int 			= 10;
		public static const SPACING_LEFT_PX:int 			= 10;
		public static const SPACING_RIGHT_PX:int 			= 10;
		public static const MIN_HEIGHT_ADD_SCREEN:int		= 300;
		public static const SPACING_ABOVE_LARGE_PX:int		= 50;
		public static const SPACING_BENEATH_LARGE_PX:int	= 50;
		public static const GAME_MENU_COLOR:uint 			= 0x000000;
		public static const TEXT_COLOR_BUTTON:uint 			= 0xffffff;
		public static const TEXT_COLOR_GENERAL:uint			= 0xffffff;
		public static const TEXT_SIZE_BUTTON:Number 		= 12;
		public static const TEXT_SIZE_GENERAL:Number		= 12;
		public static const TEXT_SIZE_TITLE:Number			= 16;
		public static const TEXT_FONT_TYPE:String			= "Verdana";
		
		//Standard settings
		public static const STANDARD_DIFFICULTY_SETTING:int = 1;
		public static const STANDARD_DURATION_SETTING:int 	= 3;
		
		//Available Setting
		public static const DIFFICULTY_SETTINGS:Array 	= new Array("Easy", "Medium", "Hard");
		public static const DURATION_SETTINGS:Array 	= new Array("10", "30", "60", "Unlimited");
		
		//File and Directory Paths
		public static const SAVE_SETTINGS_FILE:String 		= "Save the Village/settings.txt";
		public static const SAVED_HIGHSCORES_FILE:String 	= "Save the Village/highscores.dat";
		public static const SAVE_GAME_DIRECTORY:String 		= "Save the Village/saves/";
		public static const ID_NUMBERS_FILE:String			= "Save the Village/id.txt";
		
		//Village, City and HQ locations on map
		public static const STRUCTURE_POSITIONS:Object = { 	"Pinopilis": 		{ "x":423, "y":419, "type":"city", 		"name":"Pinopilis", 		"description":"Pinopilis is a municipality and a city in the northeastern Netherlands, and is the capital of the province of Drenthe. It received city rights in 1809. Pinopilis's main claim to fame is the TT Circuit Assen the motorcycle racing circuit, where on the last Saturday in June the Dutch TT is run. Assen has a railway station.", "asset":"StructureCityImage" },
															"Head Quarters": 	{ "x":539, "y":315, "type":"hq", 		"name":"Head Quarters", 	"description":"This is the HQ. Your operation base.", 	"asset":"StructureCityImage" },
															"Village1": 		{ "x":659, "y":460, "type":"village", 	"name":"Village1", 			"description":"The first village of the game", 			"asset":"StructureCityImage" },
															"Village2": 		{ "x":701, "y":301, "type":"village", 	"name":"Village2", 			"description":"The second village of the game", 		"asset":"StructureCityImage"}};
		
		//Vilage and City dimensions
		public static const VILLAGE_HEIGHT:int 	= 60;	//in pixels
		public static const VILLAGE_WIDTH:int 	= 45;	//in pixels
		public static const CITY_HEIGHT:int 	= 60;	//in pixels
		public static const CITY_WIDTH:int 		= 45;	//in pixels
		public static const HQ_HEIGHT:int 		= 60;	//in pixels
		public static const HQ_WIDTH:int		= 45;	//in pixels
		
		//Day settings
		public static const DAYS_IN_SECONDS:int = 5;	//Default 60
		
		//Text
		public static const DEAD_TEXT:String			= "The city is dead because of your incompetence. Think hard about what you did to all these people who lived here. The horror they have experienced. And it's all your fault!";
		public static const TRANSFER_HELP_TEXT:String 	= "Touch the village or city you want to have the knowledge/resources";
		
		//Economy
		public static const DEFAULT_DATA_OBJECT:Object					= { "Pinopilis": 	{ "Spread rate": "", "Infected": "", "Resources": "", "Knowledge": "", "Resource consume": "", "Population": "", "Limit resources": "", "Limit knowledge": "", "Knowledge gain": "" },
																			"Village1": 	{ "Spread rate": "", "Infected": "", "Resources": "", "Knowledge": "", "Resource consume": "", "Population": "", "Limit resources": "", "Limit knowledge": "" },
																			"Village2": 	{ "Spread rate": "", "Infected": "", "Resources": "", "Knowledge": "", "Resource consume": "", "Population": "", "Limit resources": "", "Limit knowledge": "" }};
		//Population
		public static const DEFAULT_TOTAL_POPULATION_VILLAGE:int = 1000;
		public static const DEFAULT_TOTAL_POPULATION_CITY:int = 5000;
		//Number of infected people
		public static const DEFAULT_INFECTED_PEOPLE_VILLAGE:int = 30;
		public static const DEFAULT_INFECTED_PEOPLE_CITY:int = 100;
		//The spread rate of HIV
		public static const DEFAULT_BASE_SPREAD_RATE:Number = 0.1;
		public static const DEFAULT_SPREAD_RATE_VILLAGE:Number = 2;
		public static const DEFAULT_SPREAD_RATE_CITY:Number = 3;
		//Starting resources
		public static const DEFAULT_STARTING_RESOURCES_VILLAGE:int = 100;
		public static const DEFAULT_STARTING_RESOURCES_CITY:int = 400;
		//Limit of resources and knowledge
		public static const DEFAULT_LIMIT_RESOURCES_VILLAGE:int = 5000;
		public static const DEFAULT_LIMIT_RESOURCES_CITY:int = 10000;
		public static const DEFAULT_LIMIT_KNOWLEDGE_VILLAGE:int = 40;
		public static const DEFAULT_LIMIT_KNOWLEDGE_CITY:int = 50;
		//The number of resources that will be consumed (daily)
		public static const DEFAULT_CONSUME_RESOURCES_VILLAGE:int = 30;
		public static const DEFAULT_CONSUME_RESOURCES_CITY:int = 80;
		//Starting knowledge and education points
		public static const DEFAULT_STARTING_KNOWLEDGE_CITY:int = 5;
		public static const DEFAULT_STARTING_EDUCATION_POINTS:int = 450;
		//Buying value of resources/knowledge
		public static const DEFAULT_VALUE_RESOURCES:int = 150;
		public static const DEFAULT_VALUE_KNOWLEDGE:int = 300;
		//Growing rates
		public static const DEFAULT_GROWING_RATE_KNOWLEDGE:Number = 0.2;
		public static const DEFAULT_GROWTH_EDUCATION_POINTS:int = 275;
		//Penalty/Reward when having enough resources
		public static const DEFAULT_HAS_ENOUGH_RESOURCES:Number = 0.05;
		//Max number of infected
		public static const DEFAULT_MAX_PERCENTAGE_INFECTED:int = 80;
		
		//Prices
		public static const BASE_COST_KNOWLEDGE:int		= 30;
		public static const BASE_COST_RESOURCES:int		= 50;
		
	}

}