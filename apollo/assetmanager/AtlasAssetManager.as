package apollo.assetmanager 
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class AtlasAssetManager extends AssetManager
	{
		private var textureAtlasLib:Dictionary;
		private var callers:Dictionary;
		static private var instance:AtlasAssetManager;
		
		//this class is for use of Atlas bitmaps only
		public function AtlasAssetManager() 
		{
			this.textureAtlasLib = new Dictionary();
			this.callers = new Dictionary();
		}
		
		public static function getInstance():AtlasAssetManager
		{
			if (!instance) {
				instance = new AtlasAssetManager();
			}
			return instance;
		}
		
		public function createTextureAtlas(_xml_link:String, _image_link:String, _name:String, _onComplete:Function = null, _onCompleteParams:Array = null):void {
			this.callers[_name] = { func:_onComplete, params:_onCompleteParams };
			var type:String = "";
			if (_image_link.indexOf(".atf") != -1) {
				type = ".atf";
			}else {
				type = ".png";
			}
			this.loadAssets([_xml_link, _image_link], onTexturePackComplete, [_name, type]);
		}
		
		public function onTexturePackComplete(_name:String, _type:String):void {
			var xml:XML = this.getXml(_name + ".xml");
			var atlas:TextureAtlas;
			var png:Bitmap = this.getBitmap(_name + _type);
			if (_type == ".atf") atlas = new TextureAtlas(this.getTextureFromAtf(_name), xml);
			if (_type == ".png") atlas = new TextureAtlas(this.getTextureFromBitmap(_name), xml);
			
			textureAtlasLib[_name] = atlas;
			if (this.callers[_name].func) {
				var func:Function = this.callers[_name].func;
				var params:Array = this.callers[_name].params;
				if (!params) params = [];
				func.apply(params, params);
			}
		}
		
		public function getTextureFromAtlas(_name:String , _atlasName:String):Texture {
			var atlas:TextureAtlas = this.textureAtlasLib[_atlasName];
			if (!atlas) {
				throw new Error("getTextureFromAtlas - TextureAtlas " + _atlasName + " can not be found");
			}
			return atlas.getTexture(_name);
		}
		
		public function getTexturesFromAtlas(_name:String , _atlasName:String):Vector.<Texture> {
			var atlas:TextureAtlas = this.textureAtlasLib[_atlasName];
			if (!atlas) {
				throw new Error("getTexturesFromAtlas - TextureAtlas " + _atlasName + " can not be found");
			}
			return atlas.getTextures(_name);
		}
	}

}