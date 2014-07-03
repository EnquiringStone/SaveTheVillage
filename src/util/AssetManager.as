package util 
{
	import flash.media.Sound;
	import flash.media.Video;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * Manages all the assets of the game.
	 * @author Johan
	 */
	public class AssetManager 
	{
		//Images
		[Embed(source = "/assets/SaveTheVillageAssets.xml", mimeType = "application/octet-stream")]
		private static const UIData:Class;
		[Embed(source = "/assets/SaveTheVillageAssets.png")]
		private static const UITexture:Class;
		
		//Sounds
		[Embed(source = "../assets/sounds/BackwardsMenu.mp3")]
		public static const MenuBackwardsSound:Class;
		[Embed(source = "../assets/sounds/ClickSoundMap.mp3")]
		public static const MapClickSound:Class;
		[Embed(source = "../assets/sounds/ForwardsMenu.mp3")]
		public static const MenuForwardSound:Class;
		[Embed(source = "../assets/sounds/SaveTheIslandMapTune.mp3")]
		public static const MapThemeSound:Class;
		[Embed(source = "../assets/sounds/SaveTheIslandMenuTune.mp3")]
		public static const MenuThemeSound:Class;
		
		//Videos
		[Embed(source = "../assets/videos/Character.swf", mimeType = "application/octet-stream")]
		public static const Character:Class;
		[Embed(source = "../assets/videos/SwipeMap.swf", mimeType = "application/octet-stream")]
		public static const SwipeMap:Class;
		[Embed(source = "../assets/videos/TapGesture.swf", mimeType = "application/octet-stream")]
		public static const TapGesture:Class;
		
		
		private static var textures:Dictionary = new Dictionary();
		private static var sounds:Dictionary = new Dictionary();
		private static var videos:Dictionary = new Dictionary();
		
		public function AssetManager() 
		{
			
		}
		
		/**
		 * Gets a single texture from the textureAtlas
		 * @param	sheet
		 * @param	name
		 * @return Texture
		 */
		public static function getSingleAsset(sheet:String, name:String):Texture {
			var texture:Texture;
			var atlas:TextureAtlas;
			
			if (sheet === "ui") {
				if (textures[sheet] == null) {
					var uiTexture:Texture = Texture.fromBitmap(new UITexture());
					var uiXmlData:XML = XML(new UIData());
					atlas = new TextureAtlas(uiTexture, uiXmlData);
					textures[sheet] = atlas;
				}
			}
			
			atlas = textures[sheet];
			return atlas.getTexture(name);
		}
		
		public static function getAudioAsset(name:Class):Sound {
			var sound:Sound = new name() as Sound;
			if (sounds[sound.toString()] == null) {
				sounds[sound.toString()] = sound;
			}
			return sounds[sound.toString()];
		}
		
		public static function getVideoAsset(name:Class):ByteArray {
			var video:ByteArray = new name() as ByteArray;
			if (videos[video.toString()] == null) {
				videos[video.toString()] = video;
			}
			return videos[video.toString()];
		}
	}

}