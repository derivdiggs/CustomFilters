package com.ddiggs.transitions.view
{
	import com.ddiggs.transitions.events.CustomEvent
	import flash.display.*;
	import flash.utils.*;
	import flash.events.*;
	import gs.*;
	import gs.easing.*;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.net.URLVariables;

	public class PicHolder extends MovieClip
	{
		private var _size:Number;
		private var _id:int;
		private var _x:Number;
		private var _y:Number;
		private var _oX:Number;
		private var _oY:Number;
		private var _imgPath:String;
		private var _image:Bitmap;
		private var _path:String;
		private var _iwidth:int = 10;
		private var _fadeInTime:int;
		private var _myBitmapData:BitmapData;
		
        
        public function PicHolder():void
        {
        	super();
        }
		
	
		public function loadImage(imagePath:String, fadeInTime:int):void
		{
		
			_imgPath = imagePath;
			_fadeInTime = fadeInTime;
			var _loaders:Loader = new Loader();
			var tmpURL:String = _imgPath;
			_loaders.load(new URLRequest(tmpURL));
			_loaders.contentLoaderInfo.addEventListener(Event.COMPLETE, handleImageLoadComplete);
			_loaders.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			//_loaders.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler)
		}
		
		private function handleImageLoadComplete(e:Event):void
		{
			var tmp_img:Bitmap =  Bitmap(e.target.content);
			var tmp_data:BitmapData = BitmapData(tmp_img.bitmapData);
			_myBitmapData = tmp_data;
			
			_image = tmp_img;
			
			_image.alpha=0;
			addChild(_image);
			TweenMax.to(_image, _fadeInTime, {alpha:1});
			
			trace("PicHolder Image loaded width: " + _image.width);
			var _type:String = "hello";
			dispatchEvent(new CustomEvent("picLoaded", {type:_type}));
			
		}
		
		public function get iwidth():int{
			
			return _iwidth;
		}
		
		public function get image():Bitmap{
		
			return _image;	
		}
		
		public function get myBitmapData():BitmapData{
		
			return _myBitmapData;
		}
		
		private function progressHandler(event:ProgressEvent):void 
		{
			//var file:FileReference = FileReference(event.target);
			//trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void 
		{
	            trace("* ioErrorHandler: " + event.text);
		}
	}
}

