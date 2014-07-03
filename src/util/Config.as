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
		public static const TEXT_SIZE_BUTTON:Number 		= 16;
		public static const TEXT_SIZE_GENERAL:Number		= 16;
		public static const TEXT_SIZE_TITLE:Number			= 24;
		public static const TEXT_FONT_TYPE:String			= "Verdana";
		
		//Standard settings
		public static const STANDARD_DIFFICULTY_SETTING:int = 1;
		public static const STANDARD_DURATION_SETTING:int 	= 3;
		
		//Available Setting
		public static const DIFFICULTY_SETTINGS:Array 	= new Array("Easy", "Medium", "Hard");
		public static const DURATION_SETTINGS:Array 	= new Array("30", "60", "90", "Unlimited");
		
		//File and Directory Paths
		public static const SAVE_SETTINGS_FILE:String 		= "Save the Village/settings.txt";
		public static const SAVED_HIGHSCORES_FILE:String 	= "Save the Village/highscores.txt";
		public static const SAVE_GAME_DIRECTORY:String 		= "Save the Village/saves/";
		public static const ID_NUMBERS_FILE:String			= "Save the Village/id.txt";
		
		//Village, City and HQ locations on map
		public static const STRUCTURE_POSITIONS:Object = { 	"Mommbass": 		{ "x":541, "y":223, "type":"city", 		"name":"Mommbass", 			"description":"Mommbass has a population of about 9.700. A regional cultural and economic hub, Mommbass has a large port and an international airport, and is an important regional tourism centre.", "asset":"MommbassImage" },
															"Hospital":	 		{ "x":428, "y":426, "type":"hq", 		"name":"Hospital", 			"description":"This is the Hospital. Your base of operations. Here you can buy knowledge and resources.", 	"asset":"StructureCityImage" },
															"Kisusme": 			{ "x":658, "y":460, "type":"city", 		"name":"Kisusme", 			"description":"Kisusme is a city with a population of 10.000. It is one of the largest cities in the island. Kisusme has highly fertile land and variations in temperature and rainfall with two rainy seasons per year.", 			"asset":"KisusmeImage" },
															"Sauura": 			{ "x":333, "y":219, "type":"village", 	"name":"Sauura", 			"description":"Sauura’s well-watered humid and semi-humid zones support arable agriculture and hence a high population density.", 		"asset":"SauuraImage" },
															"Dertua":			{ "x":429, "y":283, "type":"village", 	"name":"Dertua", 			"description":"Dertua is a low-lying area and is characterized by high poverty levels and for years there has been a high level of dependency on food aid.", "asset":"DertuaImage" },
															"Gumulio": 			{ "x":544, "y":318, "type":"village", 	"name":"Gumulio", 			"description":"Farming is the primary occupation of at least 25% of the population. The main rain-fed planting season is in November for April harvest.", "asset":"GumulioImage" },
															"Tiuy": 			{ "x":711, "y":308, "type":"village", 	"name":"Tiuy", 				"description":"Tiuy is one of the poorest villages in the island. It has a long dry season of 9 to 11 months and the cluster only receives about 250-500 millimeters of rain per year.", "asset":"TiuyImage" },
															"Koriru": 			{ "x":545, "y":436, "type":"village", 	"name":"Koriru", 			"description":"The area is semi-arid with a short rainy season, receiving about 500 millimeters of rain per year.", "asset":"KoriruImage"}};
		
		//Vilage and City dimensions
		public static const VILLAGE_HEIGHT:int 	= 60;	//in pixels
		public static const VILLAGE_WIDTH:int 	= 45;	//in pixels
		public static const CITY_HEIGHT:int 	= 60;	//in pixels
		public static const CITY_WIDTH:int 		= 45;	//in pixels
		public static const HQ_HEIGHT:int 		= 60;	//in pixels
		public static const HQ_WIDTH:int		= 45;	//in pixels
		
		//Day settings
		public static const DAYS_IN_SECONDS:int = 1;
		
		//Text
		public static const DEAD_TEXT:String			= "All the people who lived here are sick. This means you can't play with this city/village anymore";
		public static const TRANSFER_HELP_TEXT:String 	= "Touch the village or city you want to have the knowledge/resources";
		public static const SCORE_TEXT:String			= "Your score is:";
		
		//Economy
		public static const DEFAULT_DATA_OBJECT:Object					= { "Mommbass": { "Spread rate": "", "Infected": "", "Resources": "", "Knowledge": "", "Resource consume": "", "Population": "", "Limit resources": "", "Limit knowledge": "", "Knowledge gain": "" },
																			"Kisusme": 	{ "Spread rate": "", "Infected": "", "Resources": "", "Knowledge": "", "Resource consume": "", "Population": "", "Limit resources": "", "Limit knowledge": "" },
																			"Sauura": 	{ "Spread rate": "", "Infected": "", "Resources": "", "Knowledge": "", "Resource consume": "", "Population": "", "Limit resources": "", "Limit knowledge": "" },
																			"Dertua": 	{ "Spread rate": "", "Infected": "", "Resources": "", "Knowledge": "", "Resource consume": "", "Population": "", "Limit resources": "", "Limit knowledge": "" },
																			"Gumulio": 	{ "Spread rate": "", "Infected": "", "Resources": "", "Knowledge": "", "Resource consume": "", "Population": "", "Limit resources": "", "Limit knowledge": "" },
																			"Tiuy": 	{ "Spread rate": "", "Infected": "", "Resources": "", "Knowledge": "", "Resource consume": "", "Population": "", "Limit resources": "", "Limit knowledge": "" },
																			"Koriru": 	{ "Spread rate": "", "Infected": "", "Resources": "", "Knowledge": "", "Resource consume": "", "Population": "", "Limit resources": "", "Limit knowledge": "" }};
		//Population
		public static const DEFAULT_TOTAL_POPULATION_VILLAGE:int = 2000;
		public static const DEFAULT_TOTAL_POPULATION_CITY:int = 5000;
		//Number of infected people
		public static const DEFAULT_INFECTED_PEOPLE_VILLAGE:int = 30;
		public static const DEFAULT_INFECTED_PEOPLE_CITY:int = 100;
		//The spread rate of HIV
		public static const DEFAULT_BASE_SPREAD_RATE:Number = 0.1;
		public static const DEFAULT_SPREAD_RATE_VILLAGE:Number = 1.0; //2
		public static const DEFAULT_SPREAD_RATE_CITY:Number = 1.3; //3
		//Starting resources
		public static const DEFAULT_STARTING_RESOURCES_VILLAGE:int = 200;
		public static const DEFAULT_STARTING_RESOURCES_CITY:int = 400;
		//Limit of resources and knowledge
		public static const DEFAULT_LIMIT_RESOURCES_VILLAGE:int = 500;
		public static const DEFAULT_LIMIT_RESOURCES_CITY:int = 500;
		public static const DEFAULT_LIMIT_KNOWLEDGE_VILLAGE:int = 40;
		public static const DEFAULT_LIMIT_KNOWLEDGE_CITY:int = 50;
		//The number of resources that will be consumed (daily)
		public static const DEFAULT_CONSUME_RESOURCES_VILLAGE:int = 20;
		public static const DEFAULT_CONSUME_RESOURCES_CITY:int = 70;
		//Starting knowledge and education points
		public static const DEFAULT_STARTING_KNOWLEDGE_CITY:int = 3;
		public static const DEFAULT_STARTING_EDUCATION_POINTS:int = 450;
		public static const DEFAULT_VARIATION_DIFFICULTY_EDUCATION_POINTS:int = 100;
		//Buying value of resources/knowledge
		public static const DEFAULT_VALUE_RESOURCES:int = 150;
		public static const DEFAULT_VALUE_KNOWLEDGE:int = 300;
		public static const DEFAULT_VALUE_RESOURCES_BOUGHT:int = 100;
		public static const DEFAULT_VALUE_KNOWLEDGE_BOUGHT:int = 5;
		//Growing rates
		public static const DEFAULT_GROWING_RATE_KNOWLEDGE:Number = 0.2;
		public static const DEFAULT_GROWTH_EDUCATION_POINTS:int = 275;
		//Penalty/Reward when having enough resources
		public static const DEFAULT_HAS_ENOUGH_RESOURCES:Number = 0.03;
		//Max number of infected
		public static const DEFAULT_MAX_PERCENTAGE_INFECTED:int = 80;
		
		//Score
		public static const DEFAULT_MAX_SCORE_VILLAGE:int = 1000;
		public static const DEFAULT_MAX_SCORE_CITY:int = 2000;
		public static const DEFAULT_MAX_SAVES:int = 4;
		
		//Game over condition
		public static const AMOUNT_DEAD_STRUCTURES:int = 5;
		
		//Random Events
		public static const RANDOM_EVENTS:Object = { 	"Event1": { "message": "Needles are being shared! This means that all cities and villages will get more infected", "type": ["village", "city"], "effects": { "Infected": 3 } },
														"Event2": { "message": "Church opposes condoms! This means that all cities and villages will get an increased change to get infected", type: ["village", "city"], effects: { "Spread rate": 0.4 } },
														"Event3": { "message": "Myths about HIV are spreading! This means that all cities and villages will get an increased change to get infected", type: ["village", "city"], effects: { "Spread rate": 0.2, "Infected": 2 } },
														"Event4": { "message": "Doctors appear at all the cities! This means that all cities will get a decreased change to get infected", type: ["city"], effects: { "Spread rate": -0.7 } },
														"Event5": { "message": "Condoms are being used more often! This means that all cities and villages will get a decreased change to get infected", type: ["village", "city"], effects: { "Spread rate": -1.0 } },
														"Event6": { "message": "Medicines are being sent to all the villages! This means that all villages will get a decreased change to get infected", type: ["village"], effects: { "Spread rate": -0.6 } }, 
														"Event7": { "message": "Hospitals in cities are using clean needles! This means that all villages and cities will get a decreased change to get infected", type: ["city"], effects: { "Spread rate": -0.7 } },
														"Event8": { "message": "Teachers are teaching the children about HIV/AIDS in the villages! This means that all villages will extra knowledge", type: ["village"], effects: { "Knowledge": 2 } },
														"Event9": { "message": "Europe has send condoms to all the villages and cities! This means that all villages and cities will get extra resources", type: ["village", "city"], effects: { "Resources": 200 } },
														"Event10": { "message": "The president launches an HIV campaign to let everyone know the dangers of not using a condom ", type: ["city", "village"], effects: { "Knowledge": 1, "Resources": 250, "Spread rate": -0.2 } }
		};
		public static const STARTING_CHANGE:Number = 1.5;
		public static const CHANGE_INCREASE:Number = 0.5;
		
		//Tutorial
		public static const INTRODUCTION_TEXT:Array = new Array(	"Welcome to the island Mauchelle! It is an island in the Indian Ocean with two cities and five villages.", 
																	"It used to be a peaceful, healthy island but now the HIV virus is spreading. HIV affects the immune system and the population of Mauchelle is slowly dying because of it.",
																	"Can you help us?");
		public static const READ_TIME_IN_SECONDS:int = 2;
		public static const SWIPE_MAP_TEXT:String = "Use your finger to move around the map";
		public static const TAP_VILLAGE_TEXT:String = "Use your finger to tap a village";
		public static const TAPPED_VILLAGE_SUCCESS_TEXT:Array = new Array(	"Good work! This is a village. There are some things you should know, to help me!",
																			"You can buy condoms, medicine, clean needles and knowledge when you touch the buy button",
																			"Every city and village needs resources (condoms, medicine and clean needles) to help against the Infection spread",
																			"You also need knowledge to make the resources help more!");
		public static const TAP_VILLAGE_END_TEXT:String = "Use your finger to press the Buy button";
		public static const HQ_INFO_TEXT:Array = new Array(	"This is the hospital. You can buy condoms, medicine, clean needles and knowledge here.",
															"The resources and knowledge cost education points. To see how much education points you have, look at the top of the screen",
															"Every 5 days, you will get more education points to spend. Remember that the yellow bar (right) has to be filled, while the bad red bar (left) should be empty");
		public static const HQ_INFO_END_TEXT:String = "Buy a resource (condoms, medicine or clean needles) or some knowledge";
		public static const BOUGHT_RESOURCE_TEXT:Array = new Array( "If you bought resources, you see that the yellow bar got more filled in. This is a good thing!",
																	"If you bought knowledge, you can tap the village/city you send it too. You can see that the knowledge number got higher. Also a good thing!",
																	"If you canceled the payment (You tapped the hospital), than you will see that the education points remain the same",
																	"Remember that cities make knowledge! You can give that knowledge by tapping the city and press the transfer knowledge button. Go ahead and try!");
		public static const CITY_TRANSFER_INFO_TEXT:String = "Use your finger to tap a city";
		public static const NOT_A_CITY_TEXT:String = "Not a city!";
		public static const CITY_TRANSFER_TEXT:Array = new Array( 	"Good work! This is the city screen. You can see that it is the same as the village screen. Except for one difference, the Transfer knowledge button",
																	"The transfer knowledge button can be used to get knowledge from the city and \"Transfer\" it to another village or city!",
																	"Each day the city will make more knowledge, you can \"Tranfer\" 1 whole knowledge at a time.");
		public static const FINAL_LESSON_SPEECH:Array = new Array( 	"Great, keep up the good work! You now know how to play the game. A quick explanation, to make you remember the rules. Each day the yellow bar will go down while the red bar will go up!",
																	"Your job is to keep the yellow bar high and the red bar low. Buy resources and knowledge at the hospital. Remember you can transfer knowledge from cities to villages!",
																	"Make sure the infected people (The red bar) is as low as possible. Lose too many villages and cities and the game is over!",
																	"If you play with a time limit (which you can set in the settings menu), the game will be over when the days reach the limit. Try to get the best score!",
																	"Thank you for helping me! Have fun and i hope you will like this game!");
	}

}