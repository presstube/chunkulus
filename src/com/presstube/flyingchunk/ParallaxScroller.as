package com.presstube.flyingchunk {
	import com.presstube.utils.PTmove;
	import com.presstube.utils.Tinter;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ParallaxScroller extends Sprite {
		
		private var scaleStage:ScaleStage;
		private var activeStage:ActiveStage;
		private var radius:Number;
		private var numItems:int;
		private var items:Array;
		
		public function ParallaxScroller(scaleStage:ScaleStage, activeStage:ActiveStage, radius:Number, numItems:int=80) {
			this.scaleStage = scaleStage;
			this.activeStage = activeStage;
			this.radius = radius;
			this.numItems = numItems;
			
			makeScrollerItems();
			
			this.activeStage.addEventListener(ActiveStage.MOVED, onActiveStageMoved);
		}
		
		private function makeScrollerItems():void {
			items = [];
			for (var i:int = 0; i < numItems; i++) {
				var item:MovieClip = new AssetBG;
//				var item:MovieClip = new AssetParallaxBG;
				item.gotoAndStop(Math.floor(Math.random() * item.totalFrames) + 1);
				var multiplier:Number = (i) / numItems;
				items.push(item);
				item.scaleX = 1 * multiplier;
				item.scaleY = 1 * multiplier;
				item.x = Math.random() * radius - Math.random() * radius;
				item.y = Math.random() * radius - Math.random() * radius;
				Tinter.tintToBG(item, i, numItems /* 5*/, 153, 153, 153);
				addChild(item);
			}
		}
		
		private function onActiveStageMoved(e:Event):void {
			var amountToMove:Point = activeStage.amountToMove;
			for (var i:int = 0; i < numItems; i++) {
				var item:MovieClip = items[i];
				var multiplier:Number = (i) / numItems;
				item.x += (amountToMove.x * multiplier) /* / 2*/;
				item.y += (amountToMove.y * multiplier) /* / 2*/;
			}
			checkForWrap();
		}
		
		private function checkForWrap():void {
			for (var i:int = 0; i < items.length; i++) {
				var item:MovieClip = items[i];
				var itemPosition:Point = new Point(item.x, item.y);
				var centerPosition:Point = new Point(-scaleStage.x, -scaleStage.y);
				var dist:Number = Point.distance(centerPosition, itemPosition);
				var distAllowed:Number = radius + (item.width / 2);
				if (dist > (distAllowed)) {
					var direction:Number = PTmove.degreesFromPointToPoint(centerPosition, itemPosition);
					item.gotoAndStop(Math.floor(Math.random() * item.totalFrames) + 1);
					var respawnPoint:Point = Point.polar(distAllowed, PTmove.degreesToRads(getOppositeSemiCircleDirection(direction)));
					item.x = respawnPoint.x + centerPosition.x;
					item.y = respawnPoint.y + centerPosition.y;
					item.rotation = Math.random() * 360;
				}
			}
		}
		
		private function getOppositeSemiCircleDirection(direction:Number):Number {
			return Math.random() * 180 + (direction + 90);
		}
	}
}
