//
//  GenericSprite
//
//  Created by Greg Boland on 2008-04-01.
//  Copyright (c) 2008 __Icon_Nicholson__. All rights reserved.
//

package com.baseclasses {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import com.baseclasses.events.CustomEvent;

	public class GenericSprite extends Sprite {
		
		protected var _loader:Loader;
		protected var _altloader:Loader;
		protected var _genericLoader:Loader;
		protected var _anythingImage:*;
		protected var _imageButton:Bitmap;
		protected var _altImage:Bitmap;
		protected var _mc:MovieClip;
		protected var _bitmap:BitmapData;
		protected var _altBitmap:BitmapData;
		protected var _imagePath:String;
		protected var _timer:Timer;
		protected var _timer_running:Boolean = false;
		//timer info
		protected var _interval:uint = 10;
		protected var _reps:uint = 0;
		protected var _rewind_bool:Boolean = false;
		//id here
		protected var _id_num:uint;
		
		public function GenericSprite(){
				_loader = new Loader();
				_altloader = new Loader();
				_genericLoader = new Loader();
				addChild(_loader);
				addChild(_altloader);
		}
		
		public function loadImage(imagePath:String):void{
		  //  trace("ATTEMPTING TO LOAD IMAGE: " + imagePath);
			_imagePath = imagePath;
			_loader.load(new URLRequest(_imagePath));
			_loader.contentLoaderInfo.addEventListener(Event.INIT, handleInit);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleMove);  
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleMovieProgress); 
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoadingError);
		}
		
		public function loadAnything(imagePath:String):void{
			_imagePath = imagePath;
			_genericLoader.load(new URLRequest(_imagePath));
			_genericLoader.contentLoaderInfo.addEventListener(Event.INIT, handleInitAnything);
			_genericLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleCompleteAnything);
		}
		
		public function loadAltImage(altImg:String):void{
			_altloader.load(new URLRequest(altImg));
			_altloader.contentLoaderInfo.addEventListener(Event.INIT, handleAltInit);
			_altloader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleAltComplete);
		}
		
		public function loadMovie(moviePath:String):void{
			_loader.load(new URLRequest(moviePath));
			//////trace("LOADING INFO: " + moviePath)
			_loader.contentLoaderInfo.addEventListener(Event.INIT, handleMovieInit);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleMovieProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleMovieComplete);
		}
		
		protected function handleMovieProgress(e:ProgressEvent):void{
			dispatchEvent(new CustomEvent("progressLoaded", {bLoaded:e.bytesLoaded, bTotal:e.bytesTotal}));
		}
		
		public function handleInitAnything(event:Event):void{
			_anythingImage = _genericLoader.content
			addChild(_anythingImage);
		}
		
		public function handleInit(event:Event):void{
			_imageButton = Bitmap(_loader.content);
		//	////trace("IMAGE BUTTON: " + _imageButton);
			_bitmap = _imageButton.bitmapData;
			//always set the background to be set at 0
			addChild(_imageButton);
		}
		
		public function handleAltInit(evtObj:Event):void{
			_altImage = Bitmap(_altloader.content);
			_altBitmap = _altImage.bitmapData;
			addChild(_altImage);
		}
		
		
		/*
		* PLAY MOVIE
		*   - plays movieclip forwards or backwards 
		* @param start - frame to start from
		*/
		public function playMovie(_start:uint):void{
			//set the playhead
			////trace("PLAYING MOVIE");
			_mc.gotoAndStop(_start);
			//if the starting point is greater than 1 go backwards
			if(_start > 1){
				while(_mc.currentFrame > 1){
					_mc.gotoAndStop(_start);
					_start--;
					//dispatch the event if we're done animating
					if(_mc.currentFrame < 9){
						dispatchEvent(new Event("firstFrame"));
					}
				}
			}else{
				while(_mc.currentFrame != (_mc.totalFrames - 1)){
					_mc.gotoAndStop(_start);
					_start++;
					if(_mc.currentFrame == (_mc.totalFrames-1)){
						dispatchEvent(new Event("lastFrame"));
					}
				}
			}
		}
		
		/*
		* reset movie
		*  - resets the animation to the beginning
		*/
		public function resetMovie():void{
			_mc.gotoAndStop(1);
		}
		
		/* ========== PROTECTED =================== */
		protected function handleMovieInit(evtObj:Event):void{
			//can't Cast as2 movieclips as MovieClip
			_mc = MovieClip(_loader.content);
		//	////trace("LOADING MC: " + _mc);
			addChildAt(_mc, 1);
			initTimer(_interval, _reps);
		}
		  
	    protected function handleLoadingError(e:Event):void{
		   // trace("LOADING ERROR OCCURED");
			dispatchEvent(new Event("errorLoadingImage"));
		}
	
		protected function handleMove(event:Event):void{
			//trace("MOVE COMPLETE: " + event.target);
			dispatchEvent(new Event("imageLoaded"));
		}
		
		protected function handleCompleteAnything(evtObj:Event):void{
			addChild(_mc);
		}
		
		protected function handleMovieComplete(evtObj:Event):void{
			//if you want to interact with the movie this is where u would do it
			//////trace("THE MOVIE IS LOADED: " + _mc);
			dispatchEvent(new Event("movieLoaded"));
		}
		
		protected function handleAltComplete(evtObj:Event):void{
			//overwrite me if you want to do somehting with the altImage once loaded
		}
		
		protected function handleOnTimer(evtObj:Event):void{
		//	//////trace("THIS IS HAPPENING NOW: " + evtObj);
			//this needs to be true for it to play backwards
			if(_rewind_bool){
				_mc.prevFrame();
				if(_mc.currentFrame < 2){
					dispatchEvent(new Event("firstFrame"));
					stopTimer();
				//move this out of the Generic Class
				//	_mc.visible = false;
				}
			}else{
				_mc.nextFrame();
				if(_mc.currentFrame == (_mc.totalFrames-1)){
					dispatchEvent(new Event("lastFrame"));
					stopTimer();
				}
			}
		}
		
		protected function initTimer(interval:uint, reps:uint):void{
			_timer = new Timer(interval, reps);
			_timer.addEventListener(TimerEvent.TIMER, handleOnTimer);
		}
		
		/* ======== GET / SET METHODS ============== */
		
		public function setX(xpos:Number):void{
			this.x = xpos;
		}

		public function setY(ypos:Number):void{
			this.y = ypos;
		}
		
		/*
		* START TIMER
		*  - start the Timer
		*/
		public function startTimer():void{
			_timer.start();
			_timer_running = true;
		}
		
		/* 
		* STOP TIMER
		*   - stop the timer
		*/
		public function stopTimer():void{
			_timer.stop();
			_timer_running = false;
			dispatchEvent(new Event("timerStopped"));
		}
		
		/* ========== MC METHODS ============= */
		
		/*
		* HIDE MC
		* - hides the animated movieclip
		*/
		public function hideMC():void{
			_mc.visible = false;
		}
		
		public function showMC():void{
			_mc.visible = true;
		}
		
		public function setXofMC(xPos:Number):void{
			_mc.x = xPos;
		}
		
		public function getXofMC():Number{
			return _mc.x;
		}
		
		public function setYofMC(yPos:Number):void{
			_mc.y = yPos;
		}
		
		/* ====== ID GET / SET =========== */
		public function setID(num:uint):void{
			_id_num = num;
		}
		
		public function getID():uint{
			return _id_num;
		}
		
		public function getHeight():Number{
			return _loader.height;
		}
		
		public function getImageHeight():Number{
			return _imageButton.height;
		}
		
		public function getImageWidth():Number{
			return _imageButton.width;
		}
		
		public function getMovieHeight():Number{
			return _mc.height;
		}
		
		public function setXofImage(num:Number):void{
			_imageButton.x = num;
		}
		
		public function setYofImage(num:Number):void{
			_imageButton.y = num;
		}
		
		public function setImageWidth(num:Number):void{
			_imageButton.width = num;
		}
		
		public function getImage():Bitmap{
			return _imageButton;
		}
	}
}