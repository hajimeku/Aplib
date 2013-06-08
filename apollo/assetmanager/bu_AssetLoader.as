package apollo.assetmanager 
{
	import apollo.debugger.Debug;
	import apollo.mystage.MyStage;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
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
		private var assetManager:AssetManager;
		private var onComplete:Function;
		private var urlLoaderLib:Dictionary = new Dictionary();
		private var params:Array;
		private var altNames:Array;
		private var local:Boolean;
		
		public function AssetLoader(_assetManager:AssetManager, _assets:Array,_onComplete:Function, _params:Array, _altNames:Array, _local:Boolean) 
		{
			onComplete 		= _onComplete;
			loadedAssets 	= _assets.concat();
			assetManager 	= _assetManager;
			params			= _params;
			altNames		= _altNames;
			local			= _local;
			
			if (!altNames) 	altNames = [];
			if (!params) 	params = [];
			
			var l:Number = _assets.length;
			for (var i:int = 0; i < l; i++) 
			{
				var str:String = _assets[i];
				var name:String = "";
				if (altNames[i]) name = altNames[i];
				else {	
					var splitArray:Array = str.split("/");
					name = splitArray[splitArray.length - 1];
				}
	
				var assetName:String = _assetManager.checkAssetLoaded(name);
				if (assetName) {
					var url:URLRequest = new URLRequest(str);
					var securityDomain:* = (this.local)?null:SecurityDomain.currentDomain;
					var loaderContext:LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain, securityDomain);
					if (assetName.indexOf(".xml") != -1) {
						//LOAD XML
						var urlLoader:URLLoader = new URLLoader();
						urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
						urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
						
						urlLoaderLib[urlLoader] = str;
						urlLoader.addEventListener(Event.COMPLETE, onAssetLoaded);
						urlLoader.load(url);
					}else {
						//LOAD DISPLAY OBJECT SWF, PNG etc...
						var loader:Loader = new Loader();
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
						loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
						//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, traceProgress);
						
						urlLoaderLib[loader] = str;
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoaded);
						loader.load(url, loaderContext);
					}
				}else {
					loadedAssets.splice(loadedAssets.indexOf(str));
					//check if all assets  are loaded
					if (!loadedAssets.length && onComplete != null) onComplete.apply(null, params);
				}
			}
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
			var splitArray:Array;
			var name:String;
			var index:Number;
			var url:String;
			var asset:* = e.target.content;
			if (e.currentTarget is LoaderInfo) {
				//handle bitmap data
				url = urlLoaderLib[e.target.loader];
				splitArray = url.split("/");
				name = splitArray[splitArray.length -1];
				
				if (name.indexOf(".atf") != -1) {
					var byteArray:ByteArray = new ByteArray();
					byteArray.readBytes(e.target.bytes);
					asset = byteArray;
				}
				
				
				index = this.loadedAssets.indexOf(url);
				if (index < 0) {
					throw new Error("Url " + url +" index is -1");
				}
				if (this.altNames[index]) {
					name = this.altNames[index];
				}
				
				assetManager.setAsset(name, asset);
				loadedAssets.splice(index , 1);
			}else {
				//handle xml, json data
				var extension:String = url.split(".").pop().toLowerCase();
				url = urlLoaderLib[e.target];
				splitArray = url.split("/");
				name = splitArray[splitArray.length -1];
				index = this.loadedAssets.indexOf(url);
				if (index < 0) {
					throw new Error("Url " + url +" index is -1");
				}
				if (this.altNames[index]) {
					name = this.altNames[index];
				}
				assetManager.setAsset(name, new XML(e.target.data))
				loadedAssets.splice(index,1);
			}
			//check if all assets are loaded
			if (!loadedAssets.length && onComplete != null) onComplete.apply(null, params);
		}
		
	}

}