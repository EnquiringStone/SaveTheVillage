package util 
{
	/**
	 * Gives more utillability to the array
	 * @author Johan
	 */
	public class ArrayUtil
	{
		/**
		 * Looks if the given name is present in the array
		 * @param	array
		 * @param	name
		 * @return Boolean
		 */
		public static function inArray(array:Array, name:String):Boolean {
			for (var i:int = 0; i < array.length; i++) {
				if (array[i] == name) return true;
			}
			return false;
		}
		
		/**
		 * Get the key and value from a string seperated with ";" and "_"
		 * @param	stringObject
		 * @return Object
		 */
		public static function getValuePair(stringObject:String):Object {
			var map:Object = new Object();
			var keyValueArray:Array = stringObject.split(";");
			for (var i:int = 0; i < keyValueArray.length; i++) {
				var key:String = keyValueArray[i].split("_")[0];
				var value:String = keyValueArray[i].split("_")[1];
				map[key] = value;
			}
			return map;
		}
		
		public static function getObjectSize(data:Object):int {
			var counter:int = 0;
			for (var name:String in data) {
				counter ++;
			}
			return counter;
		}
	}

}