package com.presstube.chunkulus {
	import com.presstube.utils.PTmove;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	public class ConfettiChunklet extends Sprite {
		
		private var activeStage:ActiveStage;
		private var radius:Number;
		
		private var velocity:Point = new Point;
		private var drag:Number = .98;
		private var directionInDegrees:Number = 0;
		private var amountToRotate:Number;
		
		public function ConfettiChunklet(activeStage:ActiveStage, radius:Number, force:Number=10, direction:Number=0, initVelocity:Point=null) {
			this.activeStage = activeStage;
			this.radius = radius;
			this.amountToRotate = ((direction - 45) * force) / 5;
			if (initVelocity)
				velocity = initVelocity;
			
			rotation = direction;
			var forceToAdd:Point = Point.polar(force, PTmove.degreesToRadsAdjusted(rotation));
			velocity.x = forceToAdd.x;
			velocity.y = forceToAdd.y;
			var chunkyAsset:MovieClip = makeChunky();
			scaleX = scaleY = 0;
			addChild(chunkyAsset);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			scaleX += (.5 - scaleX) / 2;
			scaleY += (.5 - scaleY) / 2;
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
		
		private function makeChunky():MovieClip {
			var ran:int = Math.floor(Math.random() * 48) + 1;
			var nothingClass:Class = getDefinitionByName("Chunky_" + ran) as Class;
			var chunky:MovieClip = new nothingClass() as MovieClip;
			return chunky;
		}
	}
}
