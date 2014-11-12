/*
* XML READER
* - loads data
* - accepts a filepath and loads an xml file from that filepath
*/

package com.baseclasses.dataLoader{
    import com.baseclasses.events.CustomEvent;
	import flash.display.Sprite;
    import flash.events.*;
    import flash.net.*;
	import flash.xml.*;

    public class XMLReader extends Sprite {
		public var externalXML:XML;
		public var notifyArray:Array = new Array();
		public var displayData:Array = new Array();
		private var _loader:URLLoader;
	
        public function XMLReader(file:String = null){
            //is file is == to a filepath then loadData
			if (file != null){
			//	trace("FILE PATH: " + file)
				loadData(file);
			} 
        }
		
		/*
		* LOAD DATA
		* - loads data from an extenal xml source
		*/
		public function loadData(file:String):void{
            _loader = new URLLoader();
			//add listeners to the _loader, listeners call functions once events occur
            configureListeners(_loader);

            var request:URLRequest = new URLRequest(file);
            try {
			//	trace("loading.. : " + request);
                _loader.load(request);
            } catch (error:Error){
                trace("Unable to load requested document.");
            }
        }

		/* 
		* 	Configure listeners 	
		*/
        private function configureListeners(dispatcher:IEventDispatcher):void{
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }
		
		/*
		* COMPLETE HANDLER
		* @param - event that is generated from the loading of xml text in _loader
		* - dispatches event if the text is successfully loaded
		*/
        private function completeHandler(event:Event):void{
			var loader:URLLoader = event.target as URLLoader;
			if (loader != null){
				dispatchEvent(new CustomEvent("dataLoaded", {data:loader.data}));
			}else{
				trace("loader is not a URLLoader!");
			}
			
        }

				
		private function openHandler(event:Event):void{
            trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void{
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void{
            trace("securityErrorHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void{
            trace("httpStatusHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void{
            trace("ioErrorHandler: " + event);
        }
    }
}


