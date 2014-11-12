/*
*** This class takes an image and chops it up in any number of rows and columns. The pieces are initially moved then
*** animate back in to create the original image. The class dispatches picLoaded once the passed in image has loaded and
*** dispatches transComplete once the entire transition is finished.
*/

package com.ddiggs.transitions
{
	
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import com.ddiggs.transitions.baseclasses.CustomSprite;
	import com.ddiggs.transitions.events.CustomEvent;
	import com.ddiggs.transitions.view.BitHolder;
	import com.ddiggs.transitions.view.PicHolder;
	import gs.*;
	import gs.easing.*;
	import gs.plugins.*;
	
	
		
	public class TransitionRenderer extends CustomSprite{
			
		private var _imageURLs:Array; // an array the hold the image(s) URLs used for the transition
		private var _imageArray:Array; // an array the hold the actual image(s) data used for the transition
		private var _transitionTime:int; // the amount of time to animate the transition in seconds
		private var _rowDivisions:int; // the amount of rows used to divide the image
		private var _colDivisions:int; // the amount of colomns used to divide the image
		private var  _allBlocks:Array; // an array that holds all of the image blocks
		private var _totalBoxes:int; // the total number of blocks when the image is divided by rows and coloms
		private var _doneBoxCount:int; // keeps track of blocks that have complete their animation
		private var _id:int; // keeps an idea of the instance of this class and is appended to events dispatched
		
			
		public function TransitionRenderer(){
			trace("TransitionRenderer()");
			initAll();
		}
		
		private function initAll(){
			_imageArray = [];
			 _allBlocks = [];
			_totalBoxes = 0;
			_doneBoxCount = 0;
			
		}
		
		/*
		*** Activates this class when called. Class is dorment otherwise.
		*/
			
		public function createTransition(id:int, imageURLs:Array, transitionTime:int, rowDivisions:int, colDivisions:int){
			
			_id = id;
			_imageURLs = imageURLs;
			_transitionTime = transitionTime;
			_rowDivisions = rowDivisions;
			_colDivisions = colDivisions;
			
			makeImageArray(_imageURLs)
		}
		
		/*
		*** takes an array of image URLs and loads them into an array of actual image data
		*/
			
		private function makeImageArray(images:Array){
			
			for (var i:int = 0; i<images.length; i++){

				var pic = new PicHolder();
				pic.addEventListener("picLoaded", picLoadComplete);
				pic.loadImage(images[i],1);
				_imageArray.push(pic);
			}
		}
		
		/*
		*** creates slices of the main image. Once the slices are created calls animateTransition() to actually
		*** animate in each block.
		*/
		
		private function sliceBitmap(mImage):void{
			
		       var mainImage:BitmapData = mImage.myBitmapData; // converts passed image to bitmap data
		       var tileX:Number = _rowDivisions; // holds total rows that were passed in createTransition()
		       var tileY:Number = _colDivisions; // holds total colomns that were passed in createTransition()
		      
		       var tilesH:uint = Math.ceil(mainImage.width / tileX); // determine column width in pixels
		       var tilesV:uint = Math.ceil(mainImage.height / tileY);// determind row height in pixels
			   
			   var bitmapArray:Array = []; // hold bitmap in an array
			   var row_ar:Array = []; // hold an array of rows
		     
			   	/*
				*** creates a 3d array of each block's bitmap data
				*/
					
		       for (var i:Number = 0; i < tilesH; i++)
		       {
		           bitmapArray[i] = new Array();
		           for (var n:Number = 0; n < tilesV; n++)
		           {
		               var tempData:BitmapData=new BitmapData(tileX,tileY);
		               var tempRect = new Rectangle((tileX * i),(tileY * n),tileX,tileY);
		               tempData.copyPixels(mainImage,tempRect,new Point(0,0));
		               bitmapArray[i][n]=tempData;
		           }
		       }
			   
		   		/*
				*** renders the 3d array of each block's bitmap data and places in a grid
				*/
		   	
		       for (var j:uint =0; j<bitmapArray.length; j++)
		       {
				   row_ar=[];
		           for (var k:uint=0; k<bitmapArray[j].length; k++)
		           {

		              var bitmap:Bitmap=new Bitmap(bitmapArray[j][k]); // makes bitmap from bitmap data of each piece
					  var myImage:BitHolder = new BitHolder((k * _rowDivisions),(j * _colDivisions), _rowDivisions, _colDivisions);
					  myImage.alpha = 0; // make image block invisible
		              myImage.addChild(bitmap); // add rendered bitmap data to block
					 
					  addChild(myImage);
					    
					  var myGrid:Sprite = new Sprite(); // hold 1 pixel border
					  myGrid.graphics.lineStyle(1, 0xffffff, .9);
					  myGrid.graphics.moveTo(j * bitmap.width, k * bitmap.height); 
					  myGrid.graphics.lineTo((j+1) * bitmap.width, k * bitmap.height);
					  TweenLite.to(myGrid, .5, {delay:(((bitmapArray[j].length- k)*.08)), alpha:0}); //fade out 1 pixel boder
					  myImage.addChild(myGrid); // add pixel line to image block
				
		              bitmap.x = j * bitmap.width; // set x of image block
		              bitmap.y = k * bitmap.height; // set y of image block
					  row_ar.push(myImage);
					  _totalBoxes++;
		           }
				    _allBlocks[j]=(row_ar);
		       }
			   
			   animateTransition( _allBlocks);  
		}
		
		/*
		*** animate each block in 
		*/
			
		private function animateTransition(allBlocks:Array):void{
			
			var i:int = 0;
			for (var col:int = 0; col < allBlocks.length; col++){
					
				for (var row:int = 0; row < allBlocks[col].length; row++){
						
					allBlocks[col][row].y = getRandom(-60,120); // offset position of each block at a random y
					
					TweenLite.to(allBlocks[col][row], 0, {tint:0x333399}); // tint each block
					TweenLite.to(allBlocks[col][row], 8, {tint:null, onComplete:trackProgress}); // untint each block and track completetion of each block's transition
					TweenMax.to(allBlocks[col][row], (1), {x:0, y:0, ease:Quad.easeIn, delay:getRandom(1,50)*.1 + _transitionTime, alpha:1}); // animate block to correct position with a random delay
					
					i++;
				}
			}	
		}
		
		/*
		*** Called at the completion of each block's transition. When all blocks are finished, dispatches transComplete
		*/
			
		private function trackProgress():void{
			
			_doneBoxCount++; // increments for each blocks completion
			
			if( _doneBoxCount == _totalBoxes){ // checks to see of ALL block are complete
				
				trace("BOXTRANSITIONS COMPLETE");
				dispatchEvent(new CustomEvent("transComplete", {id:_id}));
			}
		}
		
		/*
		*** Events
		*/
			
		/*
		*** called once all images are loaded and dispatches picLoaded event to host.
		*** Calls sliceBitmap which begins the actual transition process
		*/
		
		private function picLoadComplete(e:CustomEvent):void
		{
			sliceBitmap(_imageArray[0]);
			var _type:String = "hello"; // no data is needed, just a test string to fullfill eventObj
			dispatchEvent(new CustomEvent("picLoaded", {type:_type}));
		}
		
		/*
		
		Experimental piece for making blocks interact with mouse movement	
			
		private function onMouseMove(evt:MouseEvent){
			
			var target:* = evt.target;
			

			var location:Point = new Point(target.mouseX, target.mouseY);
			location = target.localToGlobal(location);
			trace(target.mouseY + ": "+ location.y);
			var _type:Object = {x:target.mouseX, y:target.mouseY};
			for (var col:int = 0; col <  _allBlocks.length; col++){
					
				for (var row:int = 0; row <  _allBlocks[col].length; row++){
					
					 _allBlocks[col][row].tellCoords(target.mouseX, target.mouseY);
				}
			}
		}
		*/
	}
}