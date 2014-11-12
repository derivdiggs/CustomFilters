package com.ddiggs.transitions.view{
	import flash.display.*;
	import flash.net.*;
	import com.ddiggs.transitions.baseclasses.BasicStage;
	import com.ddiggs.transitions.TransitionRenderer;
	import com.ddiggs.transitions.events.CustomEvent;
	import com.ddiggs.transitions.view.*;
	import gs.*;
	import gs.easing.*;
	import gs.plugins.*;
	
	public class StageView extends BasicStage{
		
		public static const IMAGE_LOCATION:String = "images/NYSkyline.jpg";
		
		private var _TransitionRenderer:TransitionRenderer;
		private var _MyLogo:MyLogo = new MyLogo(); //reference to a movie clip within main FLA : the logo
		private var _City:City = new City(); //reference to a movie clip within main FLA : the city in color
		private var _CityBW:CityBW = new CityBW(); //reference to a movie clip within main FLA : the city in black and white
		private var _Sky:Sky = new Sky(); //reference to a movie clip within main FLA : the sky in color
		private var _SkyBW:SkyBW = new SkyBW(); //reference to a movie clip within main FLA : the sky in black and white
		private var _MultButton:MultButton = new MultButton(); //reference to a movie clip within main FLA : Multimedia button
		private var _RecButton:RecButton = new RecButton(); //reference to a movie clip within main FLA : Record Label button
		
		private var _imageArray:Array //holds the image used for transition
		private var _circleHolder:Sprite = new Sprite; //holds a circle created in this class
		private var _circleMaskHolderCity:Sprite = new Sprite; //holds a circle created in this class used as a mask for city
		private var _circleMaskHolderSky:Sprite = new Sprite; //holds a circle created in this class
		
		public function StageView():void{
		
			super();
			initAll();
		}
		
		/*
		*** initate variables, place movieclips on stage, place transitional image on stage
		*/ 
			
		private function initAll():void{
			
			_TransitionRenderer = new TransitionRenderer();
			_imageArray = new Array();
			_TransitionRenderer.addEventListener("picLoaded", picLoadComplete); //listen for when the pic used for transition is loaded
			_TransitionRenderer.addEventListener("transComplete", transComplete); //listen for when the animated transition is complete
			_RecButton.addEventListener("NavEvent", buttonHit); //listen for button press
			_MultButton.addEventListener("NavEvent", buttonHit); //listen for button press
			_City.alpha = 0;
			_CityBW.alpha = 0;
			_Sky.alpha = 0;
			_SkyBW.alpha = 0;
			addChild(_Sky);
			addChild(_SkyBW);
			addChild(_City);
			addChild(_CityBW);
			
			addChild(_TransitionRenderer); //add the holder for the transition to the stage
			_City.y = 2;
			_CityBW.y = 2;
			_MultButton.y = 501;
			_MultButton.x = 594;
			_MultButton.alpha = 0;
			_RecButton.y = 501;
			_RecButton.x = 44;
			_RecButton.alpha = 0;
			_MultButton.setButton(1); // sets the id of the button to 1
			_RecButton.setButton(2); // sets the id of the button to 2
			/*
			*** add masks to stage (invisible) so they center properly and attach them later to what they mask later
			*/
			_circleMaskHolderCity.alpha=0;
			addChild(_circleMaskHolderCity);
			_circleMaskHolderSky.alpha=0;
			addChild(_circleMaskHolderSky);
			/*
			*** after embed assets are placed and ready, begin transition
			*/
			testImageLoad();
			
		}
		
		/*
		*** send the transition renderer the image to be used
		*/
			
		private function testImageLoad(){
			
			_imageArray.push(IMAGE_LOCATION); //hold the image used for filter
			_TransitionRenderer.createTransition(1, _imageArray, 0, 40, 10);
		}
		
		/*
		*** called when main image is loaded in transition renderer
		*/
		
		private function picLoadComplete(e:CustomEvent):void{
			
			centerItem(_TransitionRenderer); //center the transition image to the display stage
			var circle:Shape = new Shape(); // The instance name circle is created
			circle.graphics.beginFill(0x000000, .5); // Fill the circle with the color 990000
			circle.graphics.lineStyle(1, 0xffffff); // Give the ellipse a black, 2 pixels thick line
			circle.graphics.drawCircle(400, 260, 216); // Draw the circle, assigning it a x position, y position, raidius.
			circle.graphics.endFill(); // End the filling of the circle
			_circleHolder.addChild(circle);
			_circleHolder.alpha = 0;
			addChild(_circleHolder);
			
			var circleMask:Shape = new Shape(); // The instance name circle is created
			circleMask.graphics.beginFill(0x000000, 1); // Fill the circle with the color 990000
			circleMask.graphics.lineStyle(1, 0xffffff); // Give the ellipse a black, 2 pixels thick line
			circleMask.graphics.drawCircle(400, 260, 216); // Draw the circle, assigning it a x position, y position, raidius.
			circleMask.graphics.endFill(); // End the filling of the circle
			_circleMaskHolderCity.addChild(circleMask);
			
			var circleMask2:Shape = new Shape(); // The instance name circle is created
			circleMask2.graphics.beginFill(0x000000, 1); // Fill the circle with the color 990000
			circleMask2.graphics.lineStyle(1, 0xffffff); // Give the ellipse a black, 2 pixels thick line
			circleMask2.graphics.drawCircle(400, 260, 216); // Draw the circle, assigning it a x position, y position, raidius.
			circleMask2.graphics.endFill(); // End the filling of the circle
			_circleMaskHolderSky.addChild(circleMask2);
			
			
			_MyLogo.x = 205;
			_MyLogo.y = 110;
			_MyLogo.alpha = 0;
			
			TweenMax.to(_MyLogo, 0, {blurFilter:{blurX:400}}); // initially blurr logo
			TweenMax.to(_MyLogo, 5, {blurFilter:{delay:5, blurX:0, ease:Bounce.easeInOut}, onComplete:animateTitle}); // unblur logo and call animateTitle when complete
			TweenMax.to(_MyLogo, 6, {alpha:1}); // fade in logo
			TweenMax.to(_circleHolder, 4, {alpha:.8}); // fade in circle that's around logo
			TweenMax.to(_circleHolder, 4, {delay:4,alpha:.5}); 
			
			
			addChild(_MyLogo);
		}
		
		/*
		*** called when main image has completed its build in transition renderer
		*** animates the movement of the city and clouds
		*/
			
		private function transComplete(e:CustomEvent):void{
			
			addChild(_circleMaskHolderCity);
			_CityBW.mask = _circleMaskHolderCity; // masks the city to create a black and white circle
			_SkyBW.mask = _circleMaskHolderSky; // masks the sky to create a black and white circle
			_CityBW.alpha = 1;
			_Sky.alpha = 1;
			_SkyBW.alpha = 1;
			_City.alpha = 1;
			_TransitionRenderer.alpha = 0; // makes the image in transition renderer invisible
			removeChild(_TransitionRenderer); // removes the image in, and the transistion renderer from display list
			
			
			TweenMax.to(_Sky, 250, {yoyo:0, width:2124, height:607, x:-1150, y:-100});
			TweenMax.to(_SkyBW, 250, {yoyo:0, width:2124, height:607, x:-1150, y:-100});
			TweenMax.to(_City, 180, {yoyo:0, width:1600, height:1200, x:-23, y:-300});
			TweenMax.to(_CityBW, 180, {yoyo:0, width:1600, height:1200, x:-23, y:-300});
		}
		
		/*
		*** animates the title text and animates in the buttons
		*/
			
		private function animateTitle():void{
			
			_MyLogo.play(); // plays animation that is embeded in the movieClip _MyLogo
			addChild(_MultButton);
			addChild(_RecButton);
			TweenMax.to(_RecButton, 1, {delay:2, alpha:.9, x:444, ease:Quint.easeOut});
			TweenMax.to(_MultButton, 1, {delay:2, alpha:.9, x:194, ease:Quint.easeOut});
		}
		
		/*
		*** Handles the navigation buttons and loads new page
		*/
			
		private function buttonHit(e:CustomEvent):void{
			
			
			if(e.evtObj.id == 2){
				
				navigateToURL(new URLRequest("http://thoughtrender.com/music"),"_self");
			}
			else
			{
				navigateToURL(new URLRequest("http://thoughtrender.com/interactive"),"_self");
			}
			
		}
		
	}
}