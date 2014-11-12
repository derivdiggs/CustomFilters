package com.baseclasses.utils
{
    import com.adobe.images.JPGEncoder;
 
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import com.adobe.images.JPGEncoder;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.ByteArray;
    import com.adobe.images.PNGEncoder;
    import com.adobe.serialization.json.JSON;
    import flash.events.IEventDispatcher;
 
    public class SaveImage extends EventDispatcher
    {
 
        public static var SERVICE_PATH:String = "http://www.fbstorage.com/zts/lib/php/saveimage.php";
        public static var PNG_SAVE_SUCCESS:String = "pngSaved";
        public static var JPG_SAVE_SUCCESS:String = "jpgSaved";
        public static var PNG_SAVE_ERROR:String = "pngError";
        public static var JPG_SAVE_ERROR:String = "jpgError";
 
        public function SaveImage(target:IEventDispatcher = null):void { super(target); }
 
        public function savePNG(image:BitmapData, filename:String):void
        {
            var imageFile:ByteArray = (PNGEncoder.encode(image));
            var imageFileName:String = filename + ".png";
 
            var loader:URLLoader = new URLLoader();
            var url:String = SERVICE_PATH + "?name=" + imageFileName;
 
            var req:URLRequest = new URLRequest(url);
            req.requestHeaders =  new Array(new URLRequestHeader("Content-Type", "image/png"));
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            req.contentType = "image/png";
            req.method = URLRequestMethod.POST;
            req.data = imageFile;
            loader.addEventListener(Event.COMPLETE, onCompletePNG);
            loader.load(req);
 
        }
 
        private function onCompletePNG(e:Event):void {
 
            trace(e.target.data);
 
            var result:Object = JSON.decode(e.target.data);
            if (result.success == "true") {
                dispatchEvent(new Event(SaveImage.PNG_SAVE_SUCCESS));
            } else {
                dispatchEvent(new Event(SaveImage.PNG_SAVE_ERROR));
            }
 
        }
 
        public function saveJPG(image:BitmapData, filename:String, quality:Number = 90):void
        {
            var imageFile:ByteArray = (new JPGEncoder(quality)).encode(image);
            var imageFileName:String = filename + ".jpg";
 
            var loader:URLLoader = new URLLoader();
            var url:String = SERVICE_PATH + "?name=" + imageFileName;
 
            var req:URLRequest = new URLRequest(url);
            req.requestHeaders =  new Array(new URLRequestHeader("Content-Type", "image/jpeg"));
 
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            req.contentType = "image/jpeg";
            req.method = URLRequestMethod.POST;
            req.data = imageFile;
            loader.addEventListener(Event.COMPLETE, onCompleteJPG);
            loader.load(req);
 
        }
 
        private function onCompleteJPG(e:Event):void {
            trace(e.target.data);
            var result:Object = JSON.decode(e.target.data);
            if (result.success == "true") {
                dispatchEvent(new Event(SaveImage.JPG_SAVE_SUCCESS));
            } else {
                dispatchEvent(new Event(SaveImage.JPG_SAVE_ERROR));
            }
        }
 
    }
}