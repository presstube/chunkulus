package com.presstube.chunkulus {
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(frameRate = "30", width = "700", height = "500", backgroundColor = "#222222")]
	
	public class Main extends Sprite {
		
		private var chunkulusApp:ChunkulusApp;
		
		public function Main() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addChild(chunkulusApp = new ChunkulusApp);
			
			stage.addEventListener(Event.RESIZE, function(e:Event=null):void {
				chunkulusApp.x = stage.stageWidth / 2;
				chunkulusApp.y = stage.stageHeight / 2;
			});
			stage.dispatchEvent(new Event(Event.RESIZE));
		
		}
	}
}
