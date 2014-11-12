
/* Loaded from RenderFilter.FLA, which is a test project that will use TransitionRenderer.as.
***	This file grabs a reference to the initial stage and passes it to the ViewController that is loads.
*/
	
package com.customfilters
{

	import flash.display.*;
	import com.customfilters.view.ViewController
	
	public class RenderFilter extends Sprite
		{
			private var _ViewController:ViewController;
			private static var _docStage:DisplayObject;
		
			public function RenderFilter()
				{
					trace("RenderFilter()");
					
					_docStage = this.stage;
					super();
					initAll();
				
				}
				
			private function initAll()
				{
					_ViewController = new ViewController();
					_ViewController.initStage(_docStage); // pass a reference of the stage to the ViewController
					addChild(_ViewController);
					
				}
		}
}