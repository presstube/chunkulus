package com.presstube.flyingchunk {
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.presstube.utils.PTmove;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	public class Chunklet extends Sprite {
		
		private var activeStage:ActiveStage;
		private var radius:Number;
		
		private var velocity:Point = new Point;
		private var drag:Number = .98;
		private var directionInDegrees:Number = 0;
		private var amountToRotate:Number;
		
//		private var colors:Array = [0xf800ff, 0xe6e6e6, 0xbcf200, 0x00ffda, 0x0afb00, 0x0304c4, 0xf20086, 0x7c0005, 0x9099ff, 0x614730, 0x20150d, 0xf800ff, 0x301d0d, 0xfffc80, 0x07302f, 0x04fb79, 0x996208, 0xfff809, 0x82ff00, 0xf70609, 0x4c4a3e, 0x271f2f, 0x20150d, 0x603f80];
		
		public function Chunklet(activeStage:ActiveStage, radius:Number, force:Number=10, direction:Number=0, initVelocity:Point=null) {
			this.activeStage = activeStage;
			this.radius = radius;
			this.amountToRotate = ((direction - 45) * force) / 5;
			if (initVelocity)
				velocity = initVelocity;
			
//			trace("VELOCITY: " + velocity);
			rotation = direction;
			var forceToAdd:Point = Point.polar(force, PTmove.degreesToRadsAdjusted(rotation));
			velocity.x = forceToAdd.x;
			velocity.y = forceToAdd.y;
//			makeGraphics();
			var chunkyAsset:MovieClip = makeChunky();
			chunkyAsset.scaleX = chunkyAsset.scaleY = 0;
			
			TweenLite.to(chunkyAsset, 1, {scaleX:.5, scaleY:.5, ease:Expo.easeOut});
			addChild(chunkyAsset);
			
//			var ct:ColorTransform = new ColorTransform;
//			var colorIndex:int = Math.floor(Math.random() * colors.length);
//			ct.color = colors[colorIndex];
//			this.transform.colorTransform = ct;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function makeGraphics():void {
			graphics.beginFill(0x222222);
			graphics.lineTo(5, 0);
			graphics.lineTo(0, -10);
			graphics.lineTo(-5, 0);
			graphics.lineTo(0, 0);
			graphics.endFill();
		}
		
		private function onEnterFrame(e:Event):void {
			applyForces();
			checkForWrap();
		}
		
		private function applyForces():void {
			
			rotation += amountToRotate;
			x += velocity.x;
			y += velocity.y;
			velocity.x = velocity.x * drag;
			velocity.y = velocity.y * drag;
			amountToRotate = amountToRotate * drag;
		}
		
		private function checkForWrap():void {
			var itemPosition:Point = new Point(x, y);
			var centerPosition:Point = new Point(-activeStage.x, -activeStage.y);
			var dist:Number = Point.distance(centerPosition, itemPosition);
			var distAllowed:Number = radius + this.width + this.height;
			if (dist > (distAllowed)) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				this.parent.removeChild(this);
			}
		}
		
		private function makeChunkletItem():Sprite {
			var item:Sprite = new Sprite;
			var ran:int = Math.floor(Math.random() * 5) + 1;
			var nothingClass:Class = getDefinitionByName("Chunky_" + ran) as Class;
			var nothingBMD:BitmapData = new nothingClass() as BitmapData;
			var nothingBitmap:Bitmap = new Bitmap(nothingBMD, PixelSnapping.NEVER, true);
			item.addChild(nothingBitmap);
			nothingBitmap.x = -(nothingBitmap.width / 2);
			nothingBitmap.y = -(nothingBitmap.height / 2);
			return item;
		}
		
		private function makeChunky():MovieClip {
			var ran:int = Math.floor(Math.random() * 48) + 1;
			var nothingClass:Class = getDefinitionByName("Chunky_" + ran) as Class;
			var chunky:MovieClip = new nothingClass() as MovieClip;
			return chunky;
		}
	}
}
