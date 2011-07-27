package {
	import com.presstube.flyingchunk.FlyingChunkApp;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(frameRate = "30", backgroundColor = "#222222")]
	
	public class Main extends Sprite {
		
		private var flyingChunkApp:FlyingChunkApp;
		
		public function Main() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addChild(flyingChunkApp = new FlyingChunkApp);
			
			stage.addEventListener(Event.RESIZE, function(e:Event=null):void {
				flyingChunkApp.x = stage.stageWidth / 2;
				flyingChunkApp.y = stage.stageHeight / 2;
			});
			stage.dispatchEvent(new Event(Event.RESIZE));
		
		}
	}
}
