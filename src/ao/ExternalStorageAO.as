package ao 
{
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.utils.ByteArray;
	import util.Config;
	
	/**
	 * Controls the access to and from the external storage of the phone
	 * @author Johan
	 */
	public class ExternalStorageAO 
	{
		/**
		 * Saves a file to the filePath with as content settings
		 * @param	filePath
		 * @param	settings
		 */
		public static function saveFile(filePath:String, settings:String):void {
			var myFile:File = File.documentsDirectory.resolvePath(filePath);
			var fs:FileStream = new FileStream();
			fs.open(myFile, FileMode.WRITE);
			fs.writeUTFBytes(settings);
			fs.close();
		}
		
		public static function saveFileToDirectory(fileName:String, directory:String, data:String):void {
			var direct:File = File.documentsDirectory.resolvePath(directory);
			if (direct.isDirectory) {
				direct.createDirectory();
			}
			var file:File = File.documentsDirectory.resolvePath(direct.url + "/" + fileName);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes(data);
			fs.close();
		}
		
		/**
		 * Loads a file from the given filePath
		 * @param	filePath
		 * @return String
		 */
		public static function loadFile(filePath:String):String {
			var file:File = File.documentsDirectory.resolvePath(filePath);
			var text:String = "";
			if (file.exists) {
				var fs:FileStream = new FileStream();
				fs.open(file, FileMode.READ);
				text = fs.readUTFBytes(fs.bytesAvailable);
				fs.close();
			}
			return text;
		}
		
		/**
		 * Loads all files from a certain directoryPath
		 * @param	directoryPath
		 * @return File
		 */
		public static function loadFilesFromDirectory(directoryPath:String):Array {
			var directory:File = File.documentsDirectory.resolvePath(directoryPath);
			var files:Array = new Array();
			if (directory.isDirectory) {
				files = directory.getDirectoryListing();
			}
			return files;
		}
		
	}

}