package gamelogic 
{
	
	/**
	 * The interface LogicInterface is used for having an uniform game logic handler. It will
	 * have a couple of methods mainly used for saving/loading a game. The meaning of raw data
	 * in this context is a string that can be put in the save file. The string is made up of
	 * readable JSON. The setValuesFromRawData function does what you'll expect. It will set all
	 * the values that comes from the string.
	 * @author Johan
	 */
	public interface LogicInterface 
	{
		/**
		 * Gets the raw data from the logic class
		 * @return json
		 */
		function getRawData():String;
		
		/**
		 * Sets the values from the load file (json)
		 * @param	json
		 */
		function setValuesFromRawData(data:Object):void;
	}
	
}