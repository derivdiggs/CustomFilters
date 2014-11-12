/*
* FLV PLAYER
* 
*  created by GREGORY BOLAND 
*	Copyright (c) 2008 __ICON_NICHOLSON 06/14/08__. All rights reserved.
*
*  - based off of my as2 version and updated for as3
*  - consists of a Video Object that makes a connection with an rtmp site
*  - controls class that consists of play/pause, stop, volume, statusbar(draggable), etc...
* 
* 
*  FLV PLAYER HAS TWO MODES -
*  - progressive download - 
*      1. in the xml file set the rtmp attribute to null
*			 - rtmp="null"
*	- streaming from rtmp server - 
*	   1. in the xml file set the rtmp path with an absolute path to an rtmp server
*	   2. use the filepath node (or whatever u call it, filename, location, etc...)
*
* 
*  2.  Make a new instance of the FLV Player and call its init() function
*        init function parameters:  wid:Number = 320, hei:Number = 240, path:String = null
*
*/

package com.baseclasses.components.media {

import com.baseclasses.GenericSprite;
import com.baseclasses.events.*;
import com.baseclasses.events.CustomEvent;
import flash.media.*;
import flash.net.*;
import flash.text.*;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.events.*;
import flash.display.Bitmap;
import flash.utils.Timer;
import gs.*;
import fl.motion.easing.*;  
import nl.demonsters.debugger.MonsterDebugger; 


public class FLVPlayer extends GenericSprite{
	
	//video components
	private var nc:NetConnection;
	private var ns:NetStream;
	private var video:Video;
	private var infoclient:Object;
	private var sound:SoundTransform;
	private var duration:Number;
	private var scrub_time:Number;
	private var sliderTimer:Timer;
	//
	private var rtmpPath:String;
	private var fadeTime:Number = .15;
	//
	private var curr_path:String;
	//BOOLEANS
	//play boolean to determine if the video is playing
	public var play_bool:Boolean = false;
	// pause bool to be true if the program is paused
	public var pause_bool:Boolean = false;
	//scrubbing bool
	private var scrub_bool:Boolean = false;
	// public variable that sets up a prepended path for all assets, fed in through a flashvar on the top of the program
	public var assetsPath:String;
	//
	private var _time_to_load_to:Number;

	
	public function FLVPlayer():void{
		super();
		var d:MonsterDebugger = new MonsterDebugger(this);
	}
	
	/*
	* PLAY
	* - always starts the playing of video
	* - checks to see if anything is currently playnig, if it is it closes it and then it plays 
	* new video handled by filePath
	*/
	public function play(filePath:String):void{
		if(play_bool){
			play_bool = false;
			ns.close();
			video.clear();
		}
		if(curr_path == null || curr_path == ""){
			
		}else{
			if(curr_path != filePath){
				play_bool = false;
				ns.close();
				video.clear();	
			}

		}
		curr_path = filePath;
		ns.play(curr_path, 0);
		play_bool = true;
		pause_bool = false;
	}
	
	/*
	* RESUME
	* - after a video is pause calling this method will resume it
	*
	*/
	public function resume():void{
		ns.resume();
		play_bool = true;
		pause_bool = false;
	}
	
	/*
	* PAUSE
	* - stops the video from being played 
	* - toggles the play/pause button
	*/
	public function pause():void{
		if(play_bool){
			ns.pause();
			play_bool = false;
			pause_bool = true;
		}

	}
	
	/*
	* STOP VIDEO
	* - closes the ns stream and clears the video screen
	*/
	public function stopVideo():void{
		if(play_bool){
			play_bool = false;
			pause_bool = false;
			ns.close();
			video.clear();
		}
	}
	
	public function clearVideo():void{
		if(ns != null){
			play_bool = false;
			pause_bool = false;
			ns.close();
			video.clear();
		}
	}
	
	public function init(wid:Number = 320, hei:Number = 240, path:String = "null"):void{
		rtmpPath = path;
		video = new Video(wid, hei);
		video.x = 0;
		video.y = 0;
		addChild(video);
		// if the flash media server is not version 2 then adjust this accordingly
		NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
		nc = new NetConnection();
		setzVideoMode();
		sound = new SoundTransform();
		sound.volume = 1.0;
		initTimer(50, 0);
		
	}
	
	private function setzVideoMode():void{
		if(rtmpPath == "null"){
			nc.connect(null);
			ns = new NetStream(nc);
			ns.addEventListener(NetStatusEvent.NET_STATUS, onStatusEvent);
			video.attachNetStream(ns);
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler);
			infoclient = new Object();
			infoclient.onCuePoint = cuePointHandler;
			infoclient.onMetaData = metaDataHandler;
			ns.client = infoclient;	
  
			//init the timer so check the loading progress
			ns.soundTransform = sound;
			
			dispatchEvent(new Event("videoLoaded"));	
		}else{
			nc.connect(rtmpPath);
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			nc.client = this;
		}
		
	}
	  
	private function handleVideoEnded(e:Event):void{
		dispatchEvent(new Event("videoEndede"))
	}
	
	private function onNetStatus(e:NetStatusEvent):void{
		ns = new NetStream(nc);
		ns.addEventListener(NetStatusEvent.NET_STATUS, onStatusEvent);
		ns.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		video.attachNetStream(ns);
		ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler);
		infoclient = new Object();
		infoclient.onCuePoint = cuePointHandler;
		infoclient.onMetaData = metaDataHandler;
		ns.client = infoclient;	
		
		ns.soundTransform = sound;
		dispatchEvent(new Event("videoLoaded"));
	}
	
	private function setRTMP():String{
		if(rtmpPath != null || rtmpPath != "null"){
			return rtmpPath;
		}else{
			return null;
		}
	}
	
	/**
	* EVENT HANDLERS FOR THE DIFFERENT FORMS OF DATA SPEWING 
	* FROM THE VIDEO PLAYER
	**/
	private function onStatusEvent(stat:Object):void{
		//this tells us what state the stream is in ex...NetStream.Buffer.Full
	//	trace(stat.info.details + " NET MESSAGES : " + stat.info.code);    
        
		for(var i in ns.client){
			//trace("TOTAL BYTES: " + i);   
		}
		
		switch(stat.info.code){
		  case  "NetStream.Play.Failed":
			break;
		  case "NetStream.Buffer.Flush":
			break;
		  case "NetStream.Play.Start":
		//	trace("DETAILS ON PLAYING OBJET: " + stat.info.details);   
			break;	
		  case "NetStream.Play.StreamNotFound":
		//	trace("FILE NOT FOUND"); 
			break;
	 
		}
	}
	
	private function handleIOError(e:IOErrorEvent):void{
		//  trace("AbstractScreem.ioError:"+e.text);
	}
	
	/*
	* ON BW DONE
	* - needed for the callback function
	* - doens't do anything but its needed cause otherwise will throw an error
	* - its a pain in the ass cause this thing only matters in FLEX but we have to account for it here
	*/
	public function onBWDone():void{
	//	trace("ON BW BEING CALLED: ");
	}
	
	private function onSecurityError(evt:SecurityErrorEvent):void{
	//	trace("SECURITY ERROR: " + evt.toString());
	}
	private function onAsyncError(evt:AsyncErrorEvent):void{
	//	trace("NET CONNECTION ASYNCH ERROR: " + evt.toString());
	}
	
	private function asyncErrorEventHandler(event:AsyncErrorEvent):void {
	    // ignore
	//	trace("SYNC ERROR: " + event);
	}
	private function cuePointHandler(infoObject:Object):void{
	//	trace("MOVIE MESSAGING: " + infoObject.name);
	}
	private function metaDataHandler(infoObject:Object):void{
	//	trace("DURATION: " + infoObject.duration + " bytesLoaded: " + ns.bytesLoaded + " total: " + ns.bytesTotal);
		duration = Number(infoObject.duration);
		//controls.setTotalTime(duration);
	}
	
	override protected function handleOnTimer(evtObj:Event):void{
		var result:Boolean = isVideoLoadedPastSeekPoint(_time_to_load_to);
		if(result){
			stopTimer();
			dispatchEvent(new CustomEvent("hideLoadingAnimation", {time:_time_to_load_to}));
		}
		result = null;
	}
	
	private function isVideoLoadedPastSeekPoint(cur_time:Number):Boolean{
		var seekToPerc:Number = cur_time/duration;
		var loadPerc:Number = ns.bytesLoaded/ns.bytesTotal;
		var result:Boolean = false;
		if(loadPerc >= seekToPerc){
			result = true;
		}
		seekToPerc = NaN;
		loadPerc = NaN;
		return result;
	}
	
	/**
	* METHODS ASSOCIATED WITH CONTROLS
	*	◊ pause
	*	◊ play
	*	◊ time scrubbing
	**/
	private function handlePause(e:Event):void{
		ns.pause();
		play_bool = false;
		pause_bool = true;   
		//start the timer to see if the mouse is over the video screen  
		dispatchEvent(new Event("trackPause"));         
		
	}
	
	private function handlePlay(e:Event):void{
		if(pause_bool){
			ns.resume(); 
			dispatchEvent(new Event("trackResume"));    
		}else{
			play(curr_path);
		}
		play_bool = true;
		pause_bool = false;
	}
   
	/*
    *  DEFAULT VOLUME
	* - sets the default volume of the player
	*/
   public function defaultVolume(num:Number):void{
	   setVolume(num);
	 //  controls.setVolume(num);
   }

	public function setVolume(num:Number):void{
		if(num > 1.0){
			num = 1.0;
		}
		sound.volume = num;
		ns.soundTransform = sound;
	}
	
	/*
	* GOTO TIME
	* - use a number to find the current time to seek to 
	*
	*/
	public function gotoTime(curr_time:Number):Boolean{
		scrub_bool = true;
		play_bool = false;
		ns.pause();
		var result:Boolean = true;
		if(isVideoLoadedPastSeekPoint(curr_time)){
			ns.seek(curr_time);
		}else{
			_time_to_load_to = curr_time;
			startTimer();
			dispatchEvent(new Event("displayLoadingAnimation"));
			result = false;
		}
		return result;
	}

	private function handleChangeVolume(e:CustomEvent):void{
		setVolume(Number(e.evtObj.volume));
	}

	public function setFilePath(location:String):void{
		curr_path = location;
	}
	
	public function getFilePath():String{
		return curr_path;
	}  
	
	public function getDuration():Number{
		return duration;
	}   
	
	public function getCurrentTime():Number{
		return ns.time;
	}
	
	public function get videoInstance():Video{
		return video;
	}
	
	public function set videoInstance(value:Video):void {
		video = value;
	}

	
	
	
}

}

