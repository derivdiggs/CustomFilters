package com.baseclasses.preloader {

import flash.events.*;

public class PreloaderController extends EventDispatcher {
	
	private static var _instance:PreloaderController;
	private var _preloader:Preloader;
	protected var _bytesTotal:int = 0;
	protected var _bytesLoaded:int = 0;
	protected var _totCnt:int = 1;
	protected var _loaderCnt:int = 0;
	
	public function PreloaderController(){
		if (_instance != null) {
			throw new Error("Dis is a singleton");
		}
	}
	
	public function setPreloader(preloader:Preloader):void{
	//	trace("preloader in the controller: " + preloader)
		_preloader = preloader;
	}
	
	public function updateValues(value:Number):void{
		_preloader.updateText = value;
	}
	
	public function updateBytesTotal(num:Number):void{
		_bytesTotal += num;
	//	trace("BYTES TOTAL: " + _bytesTotal);
	} 
	
	public function endPreloadAnimation():void{
		_preloader.stopPreloader();
		dispatchEvent(new Event("imageLoadComplete"))
	}
	
	public function updateBytesLoaded(num:Number):void{
		_bytesLoaded += num;
		incrementLoadCount();
		var perc:Number = ((_bytesLoaded / _bytesTotal)/_totCnt)* _loaderCnt;
		updateValues(perc);
	//	trace("perc: " + perc);
		if(perc >= 1.0){
		//	trace("PERC IS 100: " + perc);
		//	dispatchEvent(new Event("imageLoadComplete"))
		}
		perc = NaN;
	//	trace(_totCnt + " BYTES LOADED: " + _loaderCnt);
	}
	
	public function updateTotalCount(num:int):void{
		_totCnt = ++num;
	}
	
	public function incrementLoadCount():void{
		_loaderCnt++;
	}
	
	/*
	* GET INSTANCE
	* - the access point for this class
	*
	*/
	public static function getInstance():PreloaderController{
		if (!_instance){
			_instance = new PreloaderController();
		}
		return _instance;
	}

	

	
}

}

