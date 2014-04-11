package util 
{
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author Johan
	 */
	public class AssetManager 
	{
		[Embed(source = "/assets/SaveTheVillageAssets.xml", mimeType = "application/octet-stream")]
		private static const UIData:Class;
		[Embed(source = "/assets/SaveTheVillageAssets.png")]
		private static const UITexture:Class;
		
		private static var textures:Dictionary = new Dictionary();
		
		public function AssetManager() 
		{
			
		}
		
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
	}

}