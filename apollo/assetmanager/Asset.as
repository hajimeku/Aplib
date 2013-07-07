package apollo.assetmanager 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class Asset extends EventDispatcher
	{
		private var _group:AssetGroupLoader;
		private var _name:String;
		private var _path:String;
		private var _altName:String;
		private var _base:Object;
		private var _subbase:Object;
		private var _type:String;
		
		private var urlLoader:URLLoader;
		
		
		public function Asset() 
		{
			
		}
		
		public function finished():void {
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function startLoading():void 
		{
			var url:URLRequest = new URLRequest(this.path);
			this.urlLoader = new URLLoader();
			this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			this.urlLoader.addEventListener(Event.COMPLETE, onRawAssetLoaded);
			this.urlLoader.load(url);
		}
		
		private function onRawAssetLoaded(e:Event):void 
		{
			var bytes:ByteArray = this.urlLoader.data as ByteArray;
			var assetEvent:AssetEvent = new AssetEvent(AssetEvent.BASE_ASSET_LOADED);
			assetEvent.data 		= bytes;
			assetEvent.asset 		= this;
			this.group.dispatchEvent(assetEvent);
		}
		
		private function onError(e:IOErrorEvent):void 
		{
			trace("- ASSET ERROR - asset:"+this.name+" can not be loaded from path:"+this.path);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get altName():String 
		{
			return _altName;
		}
		
		public function set altName(value:String):void 
		{
			_altName = value;
		}
		
		public function get path():String 
		{
			return _path;
		}
		
		public function set path(value:String):void 
		{
			_path = value;
		}
		
		public function get name():String 
		{
			if (this.altName) return this.altName;
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get base():Object 
		{
			return _base;
		}
		
		public function set base(value:Object):void 
		{
			_base = value;
		}
		
		public function get group():AssetGroupLoader 
		{
			return _group;
		}
		
		public function set group(value:AssetGroupLoader):void 
		{
			_group = value;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		public function get subbase():Object
		{
			return _subbase;
		}
		
		public function set subbase(value:Object):void
		{
			_subbase = value;
		}

	}

}