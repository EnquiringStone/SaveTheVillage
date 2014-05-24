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
		public static const STRUCTURE_POSITIONS:Object = { "structure1":{"x":445, "y":560, "type":"city", "name":"Pinopilis", "description":"Pinopilis is a municipality and a city in the northeastern Netherlands, and is the capital of the province of Drenthe. It received city rights in 1809. Pinopilis's main claim to fame is the TT Circuit Assen the motorcycle racing circuit, where on the last Saturday in June the Dutch TT is run. Assen has a railway station.", "asset":"StructureCityImage"}};
		
		//Vilage and City dimensions
		public static const VILLAGE_HEIGHT:int 	= 20;	//in pixels
		public static const VILLAGE_WIDTH:int 	= 20;	//in pixels
		public static const CITY_HEIGHT:int 	= 45;	//in pixels (41)
		public static const CITY_WIDTH:int 		= 25;	//in pixels (24)
		
		//Day settings
		public static const DAYS_IN_SECONDS:int = 5;	//Default 60
		
		//Text
		public static const DEAD_TEXT:String	= "The city is dead because of your incompetence. Think hard about what you did to all these people who lived here. The horror they have experienced. And it's all your fault!";
		
		//Economy
		public static const DEFAULT_DATA_OBJECT:Object		= { "Pinopilis": { "Infection rate": "", "Infected": "", "Resources": "", "Knowledge": "", "Knowledge gain": "", "Resource consume": "" }};
		
	}

}