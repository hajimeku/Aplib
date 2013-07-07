package apollo.assetmanager 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class AssetGroupLoader extends EventDispatcher
	{
		public var assets:Array;
		public var assetAltNames:Dictionary;
		
		private var _onCompleteParams:Array;
		private var _onComplete:Function;
		private var _id:Number;
		private var _prio:Number;
		private var _groupName:String;
		
		private var currentAssetLoading:Asset;
		
		public function AssetGroupLoader(_assets:Array, _altNames:Array) 
		{
			if (!_altNames) 	_altNames = [];
			
			assets 				= _assets;
			assetAltNames 		= this.createAltLibDictionary(assets,_altNames);
			
		}
		
		public function getNameFromUrl(_str:String):String 
		{
			var name:String = _str;
			var splitArray:Array = _str.split("/");
			if (splitArray.length == 1) {
				splitArray = _str.split("\\");
			}
			name = splitArray[splitArray.length - 1];
			return name;
		}
		
		public function startLoading():void 
		{
			this.processNextAssetInQueue();
		}
		
		private function processNextAssetInQueue():void 
		{
			if (this.currentAssetLoading) return;
			
			if (this.assets.length) {
				var assetPath:String = this.assets.shift();
				currentAssetLoading = new Asset();
				currentAssetLoading.group = this;
				currentAssetLoading.name = getNameFromUrl(assetPath);
				currentAssetLoading.path = assetPath;
				currentAssetLoading.type = assetPath.split(".").pop().toLowerCase();
				if (assetAltNames[assetPath]) {
					currentAssetLoading.altName = assetAltNames[assetPath];
				}
				currentAssetLoading.addEventListener(Event.COMPLETE, onAssetLoaded);
				currentAssetLoading.startLoading();
			}else {
				if (this.onComplete != null) {
					this.onComplete.apply(null, this.onCompleteParams);
					this.dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		
		public function createAltLibDictionary(_assets:Array, _altNames:Array):Dictionary 
		{
			var dic:Dictionary = new Dictionary();
			for (var i:int = 0; i < _assets.length; i++) 
			{
				var asset:String = _assets[i];
				if (_altNames.length <= i) continue;
				dic[asset] = _altNames[i];
			}
			return dic;
		}

		
		private function onAssetLoaded(e:Event):void 
		{
			var asset:Asset = e.target as Asset;
			var assetEvent:AssetEvent = new AssetEvent(AssetEvent.ASSET_COMPLETE);
			assetEvent.asset = asset;
			this.dispatchEvent(assetEvent);
			
			currentAssetLoading = null;
			this.processNextAssetInQueue();
		}
		
		public function get id():Number 
		{
			return _id;
		}
		
		public function set id(value:Number):void 
		{
			_id = value;
		}
		
		public function get onComplete():Function 
		{
			return _onComplete;
		}
		
		public function set onComplete(value:Function):void 
		{
			_onComplete = value;
		}
		
		public function get onCompleteParams():Array 
		{
			if (!_onCompleteParams) _onCompleteParams = [];
			return _onCompleteParams;
		}
		
		public function set onCompleteParams(value:Array):void 
		{
			_onCompleteParams = value;
		}
		
		public function get prio():Number 
		{
			return _prio;
		}
		
		public function set prio(value:Number):void 
		{
			_prio = value;
		}
		
		public function get groupName():String 
		{
			return _groupName;
		}
		
		public function set groupName(value:String):void 
		{
			_groupName = value;
		}
		
	}

}