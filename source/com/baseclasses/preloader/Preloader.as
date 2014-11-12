package com.baseclasses.preloader {

import flash.display.*;
import flash.text.*;
import gs.*;
import gs.easing.*;

public class Preloader extends MovieClip {
	
	private var _bg:Sprite;
	private var _preloadText:TextField;
	private var _amountLoaded:MovieClip;
	
	public function Preloader():void{
		super();
		init();
	}
	
	public function init():void{
		stop();
		_bg = getChildByName("bg") as Sprite;
		_preloadText = getChildByName("preloadText") as TextField;
		_amountLoaded = getChildByName("amountLoaded") as MovieClip;
		if(_amountLoaded){
			_amountLoaded.scaleX = .01;
		}
	}
	
	public function startPreloader():void{
		gotoAndPlay(0);
	}
	
	public function stopPreloader():void{
		gotoAndStop(0);
	}
	
	public function set updateText(value:Number):void {
	//	trace("VALUE COMING IN: " + value);
		if(_preloadText){
			_preloadText.text = Math.ceil(value*100).toString();
		}
		if(_amountLoaded){
			//_amountLoaded.scaleX = value;
			TweenMax.to(_amountLoaded, .15, {scaleX:value, ease:Cubic.easeIn});
		//	trace("SCAE X: " + _amountLoaded.scaleX);
		}
	}
	
}

}

