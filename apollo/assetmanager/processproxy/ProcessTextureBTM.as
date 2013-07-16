package apollo.assetmanager.processproxy 
{
	import apollo.assetmanager.Asset;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import starling.textures.Texture;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class ProcessTextureBTM extends ProcessDefault
	{
		private var scale:Number = 1;
		private var mipMaps:Boolean = false;
		
		public function ProcessTextureBTM(_asset:Asset, _bytes:ByteArray, _applicationDomain:ApplicationDomain = null, _mipMaps:Boolean = false, _scale:Number = 1) 
		{
			this.scale 		= _scale;
			this.mipMaps 	= _mipMaps;
			super(_asset, _bytes , _applicationDomain);
		}
		
		override public function onDefauldAssetLoaded(e:Event):void 
		{
			if (Starling.context){
				var texture:Texture = Texture.fromBitmap(e.target.content, mipMaps, false, scale);
				this.asset.base = texture;
				texture.root.onRestore = function():void {
					texture.root.uploadBitmap(e.target.content);
				}
			}
			this.asset.subbase = e.target.content;
			this.onProcessComplete();
		}
	}

}