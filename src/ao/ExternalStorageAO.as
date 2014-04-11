package ao 
{
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.utils.ByteArray;
	import util.Config;
	/**
	 * ...
	 * @author Johan
	 */
	public class ExternalStorageAO 
	{
		
		public static function saveSettings(settings:String):void {
			var myFile:File = File.documentsDirectory.resolvePath(Config.SAVE_SETTINGS_FILE);
			var fs:FileStream = new FileStream();
			fs.open(myFile, FileMode.WRITE);
			fs.writeUTFBytes(settings);
			fs.close();
		}
		
		public static function loadSettings():String {
			var file:File = File.documentsDirectory.resolvePath(Config.SAVE_SETTINGS_FILE);
			if (file.exists) {
				var fs:FileStream = new FileStream();
				fs.open(file, FileMode.READ);
				var text:String = fs.readUTFBytes(fs.bytesAvailable);
				fs.close;
				return text;
			}
			return "";
		}
		
	}

}