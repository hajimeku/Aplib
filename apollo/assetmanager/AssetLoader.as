package apollo.assetmanager 
{
	import apollo.debugger.Debug;
	import apollo.mystage.MyStage;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.DataEvent;
	import flash.events.Event;
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
	import starling.display.Sprite;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class AssetLoader 
	{
		private var loadedAssets:Array;
		private var loadedAssetsContentCheck:Array;
		private var assetManager:AssetManager;
		private var onComplete:Function;
		private var urlLoaderLib:Dictionary = new Dictionary();
		private var params:Array;
		private var altNames:Array;
		private var local:Boolean;
		
		public function AssetLoader(_assetManager:AssetManager, _assets:Array,_onComplete:Function, _params:Array, _altNames:Array, _local:Boolean) 
		{
			onComplete 					= _onComplete;
			loadedAssets 				= _assets.concat();
			loadedAssetsContentCheck 	= _assets.concat();
			assetManager 				= _assetManager;
			params						= _params;
			altNames					= _altNames;
			local						= _local;
			
			if (!altNames) 	altNames = [];
			if (!params) 	params = [];
			
			var l:Number = _assets.length;
			for (var i:int = 0; i < l; i++) 
			{
				var str:String = _assets[i];
				var name:String = "";
				if (altNames[i]) name = altNames[i];
				else {
					name = this.getNameFromUrl(str);
				}
	
				var assetName:String = _assetManager.checkAssetLoaded(name);
				if (assetName) {
					var url:URLRequest = new URLRequest(str);
					var urlLoader:URLLoader = new URLLoader();
					urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
					urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
					urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
					
					urlLoaderLib[urlLoader] = str;
					urlLoader.addEventListener(Event.COMPLETE, onRawAssetLoaded);
					urlLoader.load(url);
					
				}else {
					loadedAssetsContentCheck.splice(loadedAssets.indexOf(str), 1);
					//check if all assets  are loaded
					if (!loadedAssetsContentCheck.length && onComplete != null) onComplete.apply(null, params);
				}
			}
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
		
		private function onRawAssetLoaded(e:Event):void 
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			var bytes:ByteArray = urlLoader.data as ByteArray;
			var sound:Sound;
			var url:String;
			var index:Number;
			var name:String;
			
			url = urlLoaderLib[urlLoader];
			name = getNameFromUrl(url);
			var dataType:String = url.split(".").pop().toLowerCase();
			
			index = this.loadedAssets.indexOf(url);
			if (index < 0) {
				throw new Error("Url " + url +" index is -1");
			}
			if (this.altNames[index]) {
				name = this.altNames[index];
			}
				
			switch (dataType)
			{
				case "atf":
					assetManager.setAsset(name, bytes);
					break;
				case "fnt":
				case "xml":
					assetManager.setAsset(name, new XML(bytes));
					onComplete();
					break;
				case "mp3":
					sound = new Sound();
					sound.loadCompressedDataFromByteArray(bytes, bytes.length);
					assetManager.setAsset(name, sound);
					break;
				default:
					var loader:Loader = new Loader();
					var securityDomain:* = (this.local)?null:SecurityDomain.currentDomain;
					var loaderContext:LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain, securityDomain);
					loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoaded);
					loader.loadBytes(urlLoader.data as ByteArray, loaderContext);
					return;
					break;
			}
			
			//check if all assets are loaded
			loadedAssetsContentCheck.splice(this.loadedAssetsContentCheck.indexOf(url) , 1);
			if (!loadedAssetsContentCheck.length && onComplete != null) onComplete.apply(null, params);
		}

		
		private function onError(e:IOErrorEvent):void 
		{
			try {
				Debug.getInstance().doTrace(e);
			}catch (e:Error) {
				
			}
			
			trace(e);
		}
		
		private function onAssetLoaded(e:Event):void 
		{
			var name:String;
			var index:Number;
			var url:String;
			var asset:* = e.target.content;
			
			if (e.currentTarget is LoaderInfo) {
				//handle bitmap data
				url = urlLoaderLib[e.target.loader];
				name = getNameFromUrl(url);
				
				index = this.loadedAssets.indexOf(url);
				if (index < 0) {
					throw new Error("Url " + url +" index is -1");
				}
				if (this.altNames[index]) {
					name = this.altNames[index];
				}
				
				assetManager.setAsset(name, asset);
				loadedAssetsContentCheck.splice(this.loadedAssetsContentCheck.indexOf(url) , 1);
				
				//check if all assets are loaded
				if (!loadedAssetsContentCheck.length && onComplete != null) onComplete.apply(null, params);
			}
		}
		
	}

}