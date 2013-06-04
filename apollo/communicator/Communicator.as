package apollo.communicator 
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.system.System;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class Communicator 
	{
		static public var instance:Communicator;
		private var netConnection:NetConnection;
		private var connectionList:Array;
		
		public function Communicator() 
		{
			netConnection = new NetConnection();
			netConnection.objectEncoding = ObjectEncoding.AMF0;
			netConnection.proxyType = "none";
		
			
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			//netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			netConnection.connect("http://api.communities.equatordevelopment.com/");
			
			connectionList = new Array();
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void 
		{
			trace(e.errorID);
		}
		
		public function netStatusHandler(event:NetStatusEvent):void {
			trace(event.info.code);
		}

		static public function getInstance():Communicator {
			if (!instance) {
				instance = new Communicator();
			}
			return instance;
		}
		
		public function callJavascript(_method:String):* {
			var returnVal:* = ExternalInterface.call(_method);
			return returnVal;
		}
		
		public function requestPhp(_method:String, _callBack:Function, _params:*):void {
			var phpCommunicator:PhpCommunicator = new PhpCommunicator(_method,_callBack, this.netConnection,_params);
			connectionList.push(phpCommunicator);
			phpCommunicator.addEventListener(PhpCommunicator.FINISHED_CALL, onCommunicatorFinished);
		}
		
		private function onCommunicatorFinished(e:Event):void 
		{
			if (connectionList.indexOf(e.currentTarget) !== -1) {
				var c:* = connectionList.splice(connectionList.indexOf(e.currentTarget), 1)[0];
				c.destroy();
			}
		}
	}

}