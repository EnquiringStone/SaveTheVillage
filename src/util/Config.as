package util 
{
	/**
	 * The global settings file that can be seen but not altered throughout the application
	 * @author Johan
	 */
	public class Config 
	{
		//Styling
		public static const SPACING_BENEATH_PX:int = 10;
		public static const SPACING_ABOVE_PX:int = 10;
		public static const SPACING_LEFT_PX:int = 10;
		public static const SPACING_RIGHT_PX:int = 10;
		public static const GAME_MENU_COLOR:uint = 0x000000;
		public static const TEXT_COLOR_BUTTON:uint = 0xffffff;
		public static const TEXT_SIZE_BUTTON:Number = 12;
		
		//Standard settings
		public static const STANDARD_DIFFICULTY_SETTING:int = 1;
		public static const STANDARD_DURATION_SETTING:int = 3;
		public static const STANDARD_VILLAGES_COUNT_SETTING:int = 1;
		
		//Available Setting
		public static const DIFFICULTY_SETTINGS:Array = new Array("Easy", "Medium", "Hard");
		public static const DURATION_SETTINGS:Array = new Array("10", "30", "60", "Unlimited");
		public static const VILLAGE_COUNT_SETTINGS:Array = new Array("3", "4", "5", "6");
		
		//File and Directory Paths
		public static const SAVE_SETTINGS_FILE:String = "Save the Village/settings.txt";
		public static const SAVED_HIGHSCORES_FILE:String = "Save the Village/highscores.dat";
		public static const SAVE_GAME_DIRECTORY:String = "Save the Village/saves/";
	}

}