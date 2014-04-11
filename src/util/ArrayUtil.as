package util 
{
	/**
	 * ...
	 * @author Johan
	 */
	public class ArrayUtil
	{
		public static function inArray(array:Array, name:String):Boolean {
			for (var i:int = 0; i < array.length; i++) {
				if (array[i] == name) return true;
			}
			return false;
		}
		
		public static function getValuePair(stringObject:String):Object {
			var map:Object = new Object();
			var keyValueArray:Array = stringObject.split(";");
			for (var i:int = 0; i < keyValueArray.length; i++) {
				var key:String = keyValueArray[i].split(":")[0];
				var value:String = keyValueArray[i].split(":")[1];
				map[key] = value;
			}
			return map;
		}
	}

}