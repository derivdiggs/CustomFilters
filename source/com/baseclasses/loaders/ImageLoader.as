/*
* IMAGE LOADER 
* - loads takes in an array of objects and loads all the images 
*
*   - the data object in the array needs to have a these following methods:
*          ◊   (string) - id to store so it can find it again once its loaded
*          ◊ getImagePath():String - string that is a filepath to the image 
*    - data object also needs these props:
*         ◊ image:Bitmap - place to store the image once its loaded
* 
*/

package com.baseclasses.loaders {

import com.baseclasses.GenericSprite;
import com.baseclasses.events.CustomEvent;
import flash.display.*;
import flash.events.*;
import flash.net.URLRequest;
import flash.utils.Timer;

public class ImageLoader extends GenericSprite {
	
	private var _img_arr:Array;
	protected var _cnt:int = 0;
	protected var _loaderCnt:int = 1;
	protected var _bytesTotal:int = 0;
	protected var _bytesLoaded:int = 0;
	protected var _percent:Number = 0; 
	
	public function ImageLoader(){
		super();
	}
	
	/*
	* SET IMAGE ARRAY
	* - sets the image array with loading info
	* - resets the counter to zero
	*/
	public function setImageArr(arrgh:Array):void{
		_img_arr = arrgh;
		_cnt = 0;
		//trace("IMAHGE ARRAY: " + _img_arr);
	}
	
	/*
	* LOAD IMAGES
	* - for the length of the array load an image
	* from the method getImagePath()
	*/
	public function loadImages():void{
		for(var i:int = 0; i < _img_arr.length; i++){
			var _loaders:Loader = new Loader(); 
			_img_arr[i].id = String(i);      
			_loaders.name = String(i);
			_loaders.load(new URLRequest(_img_arr[i].getImagePath()));
			_loaders.contentLoaderInfo.addEventListener(Event.INIT, handleImageInit);
			_loaders.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
		}
	}
	
	/*
	* HANDLE IMAGE INIT
	* 
	* 
	*/
	protected function handleImageInit(e:Event):void{	
		_bytesTotal += e.target.bytesTotal;
		adjustLoadProgress();
	
	}
	
	private function adjustLoadProgress():void{
		//the percent is divide the loaded bytes by the total bytes
		//multiply by 1.0 to give it a number b/w 0 and 1 and then 
		//divide by the total num of photos to load, multiply by the num actually loaded
		_percent = (((_bytesLoaded / _bytesTotal) *1.0)/_img_arr.length)* _loaderCnt;
		dispatchEvent(new CustomEvent("percentLoaded", _percent));
		//trace("PERCENT LOADED: " + _percent + " cnt: " + _cnt); 
	}
	
	/*
	* HANDLE LOAD COMPLETE
	* - storing the image in the array
	* TODO - commented out the bitmap data cast but might have to go back and make it work if u have to manipulate data
	*/
	protected function handleLoadComplete(e:Event):void{
		_bytesLoaded += int(e.target.bytesLoaded);
		adjustLoadProgress();
		var tmp_img:Bitmap =  Bitmap(e.target.content);
		var tmp_data:BitmapData = BitmapData(tmp_img.bitmapData);
		for(var t:int = 0; t < _img_arr.length; t++){   
		     if(e.target.loader.name == _img_arr[t].id){ 
		           _img_arr[t].image = Bitmap(e.target.content)  
		          // trace(_img_arr[t].id + " IMAGE: " + _img_arr[t].image);      
		         //  trace(e.target.loader.name + " IMAGE: " + _img_arr[t].image);  
		     }
			//match the name of the file with the right ElementInfo
		}
		tmp_img = null; 
		tmp_data = null;
		_cnt++;
		_loaderCnt++;
		//check to see if all the images are loaded
		//if they are dispatchEvent
		if(_cnt == _img_arr.length){
		//	//trace("EVERYTHING GOT LOADED: " + _cnt);
			dispatchEvent(new CustomEvent("allLoaded", _img_arr));
		}
		
	}
	
	public function parseFilePath(str:String):String{
		var tmp_arr:Array = str.split("/");
	//	//trace("name:  " + tmp_arr[tmp_arr.length - 1]);
		return tmp_arr[tmp_arr.length - 1]; 
	}
	
}

}

