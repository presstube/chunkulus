package com.presstube.utils {
//	import com.presstube.shipShop.ships.AShip;
	
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class PTmove {
		private var subject:DisplayObject;
		private var sPoint:Point; // used in moveAdjacent as init point for pole
		private var adjacentAngle:Number;
		private var aOffsetX:Number
		private var aOffsetY:Number
		private var vX:Number; //used in springTo
		private var vY:Number; //""
		private var vR:Number; //""
		private var friction:Number = 0.8; //""
		
		public function PTmove(mySubject:DisplayObject) {
			setSubject(mySubject);
			vX = 0
			vY = 0;
			vR = 0;
		}
		
		public function setSubject(subject:DisplayObject):void {
			this.subject = subject;
		}
		
		public function moveToPos(tX:Number, tY:Number, speed:Number=1):Point {
			var amountToMove:Point = new Point((tX - subject.x) / speed, (tY - subject.y) / speed);
			subject.x += amountToMove.x;
			subject.y += amountToMove.y;
			/*
			subject.x += (tX - subject.x) / speed
			subject.y += (tY - subject.y) / speed
			*/
			return amountToMove;
		}
		
		public function moveToObject(target:Object, speed:Number=2, offsetX:Number=0, offsetY:Number=0):Point {
			
			return moveToPos(target.x + offsetX, target.y + offsetY, speed);
		}
		
		public function smartMoveToObject(target:Object, speed:Number=2, offsetX:Number=0, offsetY:Number=0, inverse:Boolean=false):Point {
			
			var targetPoint:Point = getLocalPos(target, subject);
			if (inverse)
				targetPoint = new Point(targetPoint.x * -1, targetPoint.y * -1);
			
			return moveToPos(targetPoint.x + offsetX, targetPoint.y + offsetY, speed);
		}
		
		public function rotateToDegree(degree:Number, speed:Number, offset:Number):Number {
			var subDeg:Number = subject.rotation + offset;
			var totalDist:Number = degree - subDeg;
			if (totalDist < -180) {
				degree += 360;
			} else if (totalDist > 180) {
				subDeg += 360;
			}
			totalDist = degree - subDeg;
			subject.rotation += totalDist / speed;
			return totalDist / speed;
		}
		
		public function rotateTo(target:DisplayObject, speed:Number=2, offset:Number=0):Number {
			
			var targetRotation:Number = getConcatenatedRotation(target) - getConcatenatedRotation(subject.parent);
			
			if (target.parent.scaleX < 0 || target.parent.parent.scaleX < 0) {
				targetRotation += 180
			}
			
			return rotateToDegree(targetRotation, speed, offset);
		}
		
		public function rotateAround(target:Object, speed:Number=2, newSubject:Object=null, offset:Number=0):Number {
			
			
			var targetPoint:Point = getLocalPos(target, subject);
			
			
			var subjectPoint:Point = new Point(subject.x, subject.y);
			
			if (newSubject) {
				subjectPoint = getLocalPos(newSubject, subject);
			}
			var degreesToTarget:Number = degreesFromPointToPoint(subjectPoint, targetPoint);
			return rotateToDegree(degreesToTarget, speed, offset);
		}
		
		public function springMoveTo(target:Object, spring:Number=0.1, friction:Number=0.8):void {
			
			var targetPoint:Point = getLocalPos(target, subject);
			vX += (targetPoint.x - subject.x) * spring
			vY += (targetPoint.y - subject.y) * spring
			vX *= friction
			vY *= friction
			subject.x += vX
			subject.y += vY
		}
		
		public function springRotateToDeg(degreesToTarget:Number, spring:Number=0.1, friction:Number=0.8, offset:Number=0):Number {
			
			var subDeg:Number = subject.rotation + offset;
			var totalDist:Number = degreesToTarget - subDeg;
			
			if (totalDist < -180) {
				degreesToTarget += 360;
			} else if (totalDist > 180) {
				subDeg += 360;
			}
			totalDist = degreesToTarget - subDeg;
			vR += totalDist * spring;
			vR *= friction
			subject.rotation += vR;
			return vR;
		}
		
		public function springRotateTo(target:DisplayObject, spring:Number=0.1, friction:Number=0.8, offset:Number=0):Number {
			var subjectParentConcatRot:Number = getConcatenatedRotation(subject.parent);
			var targetConcatRot:Number = getConcatenatedRotation(target);
			
			var degsToTargetRotation:Number = targetConcatRot - subjectParentConcatRot;
			
			return springRotateToDeg(degsToTargetRotation, spring, friction, offset);
		}
		
		public function springRotateAround(target:Object, spring:Number=0.1, friction:Number=0.8, newSubject:Object=null, offset:Number=0):Number {
			
			var targetPoint:Point = getLocalPos(target, subject);
			
			var subjectPoint:Point;
			if (newSubject) {
				subjectPoint = getLocalPos(newSubject, subject);
			} else {
				subjectPoint = new Point(subject.x, subject.y);
			}
			
			var degreesToTarget:Number = degreesFromPointToPoint(subjectPoint, targetPoint);
			var subDeg:Number = subject.rotation + offset;
			var totalDist:Number = degreesToTarget - subDeg;
			if (totalDist < -180) {
				degreesToTarget += 360;
			} else if (totalDist > 180) {
				subDeg += 360;
			}
			totalDist = degreesToTarget - subDeg;
			vR += totalDist * spring;
			vR *= friction
			
			subject.rotation += vR;
			
			return vR;
		}
		
		public function moveAdjacentInit(targetForAngle:MovieClip, target:Object, mouser:Object):void {
			
			
			adjacentAngle = getConcatenatedRotation(targetForAngle);
			var targetPoint:Point = getLocalPos(target, subject);
			var mouserPoint:Point = getLocalPos(mouser, subject);
			
			aOffsetX = targetPoint.x - mouserPoint.x
			aOffsetY = targetPoint.y - mouserPoint.y
			//trace(aOffsetX + "   " + aOffsetY);
		}
		
		public function moveAdjacentTo(target:Object, mouser:Object, speed:Number, offsetX:Number=0, offsetY:Number=0):Number {
			
			var targetPoint:Point = getLocalPos(target, subject);
			var mouserPoint:Point = getLocalPos(mouser, subject);
			
			var mPoint:Point = new Point(mouserPoint.x + aOffsetX, mouserPoint.y + aOffsetY);
			var angleFromTtoS:Number = adjacentAngle;
			var angleFromTtoM:Number = degreesFromPointToPoint(targetPoint, mPoint);
			var pole:Point = Point.polar(600, degreesToRadsAdjusted(angleFromTtoS));
			var angleOfThing:Number = angleFromTtoM - angleFromTtoS;
			if (angleOfThing < -180) {
				angleFromTtoM += 360;
			} else if (angleOfThing > 180) {
				angleFromTtoS += 360;
			}
			angleOfThing = Math.abs(angleFromTtoM - angleFromTtoS);
			var hypoteneuseDist:Number = Point.distance(targetPoint, mPoint);
			var rads:Number = degreesToRadsAdjusted(angleOfThing);
			var adjacentLength:Number = hypoteneuseDist * (Math.sin(rads)) * -1
			var newPos:Point = new Point();
			newPos = Point.polar(adjacentLength, degreesToRadsAdjusted(angleFromTtoS));
			if (adjacentLength > 0) {
				moveToPos(targetPoint.x + newPos.x, targetPoint.y + newPos.y, speed);
			} else {
				moveToPos(targetPoint.x, targetPoint.y, speed);
			}
			/* VISUALIZATION
			var subjecto:Sprite = Sprite( this.subject.parent );
			subjecto.graphics.clear();
			subjecto.graphics.lineStyle(1, 0xFF0000);
			subjecto.graphics.moveTo(targetPoint.x, targetPoint.y)
			subjecto.graphics.lineTo(targetPoint.x+pole.x,targetPoint.y+pole.y);
			subjecto.graphics.lineStyle(1, 0x00FF00);
			subjecto.graphics.moveTo(targetPoint.x, targetPoint.y)
			subjecto.graphics.lineTo(mPoint.x,mPoint.y);
			*/
			
			return adjacentLength;
		}
		
		private static function radsToDegrees(myRads:Number):Number {
			var radsToDegrees:Number = (myRads / (Math.PI * 2) * 360) + 90;
			return radsToDegrees;
		}
		
		public static function degreesToRads(myDegrees:Number):Number {
			var degsToRads:Number = (myDegrees * (Math.PI / 180))
			return degsToRads;
		}
		
		public static function degreesToRadsAdjusted(myDegrees:Number):Number {
			var degsToRads:Number = (myDegrees * (Math.PI / 180)) - Math.PI / 2
			return degsToRads;
		}
		
		public static function degreesFromPointToPoint(fromPoint:Point, toPoint:Point):Number {
//			trace(fromPoint, toPoint);
			var r:Number = radiansFromTo(fromPoint, toPoint);
			var degs:Number = radsToDegrees(r)
			
			return degs;
		}
		
		public static function radiansFromTo(fromPoint:Point, toPoint:Point):Number {
			
			var radiansTo:Number = (Math.atan2((fromPoint.x - toPoint.x), (fromPoint.y - toPoint.y)) + Math.PI / 2) * -1;
			return radiansTo;
		}
		
		public function getDist(target:Object):Number {
			
			var subjectPoint:Point = new Point(subject.x, subject.y);
			var targetPoint:Point = getLocalPos(target, subject);
			var dist:Number = Point.distance(subjectPoint, targetPoint);
			
			return dist;
		}
		
		public static function reparentClip(clip:DisplayObject, newParent:DisplayObjectContainer, forces:Boolean=false, targetIndex:Object=null):void {
//			trace("ship1.parent: " + clip.parent);
//			trace("REPARENTING!!! REPARENTING!!!");
			
			var newParentRotation:Number = getConcatenatedRotation(newParent);
			var clipParentRotation:Number = getConcatenatedRotation(clip.parent);
			
			
			var newParentPoint:Point = new Point();
			newParentPoint = clip.localToGlobal(newParentPoint);
			newParentPoint = newParent.globalToLocal(newParentPoint);
			var rotationDifference:Number = (newParentRotation * -1) + clipParentRotation;
			
			if (targetIndex) {
				newParent.addChildAt(clip, newParent.getChildIndex(targetIndex as DisplayObject));
			} else {
				newParent.addChild(clip);
			}
			clip.x = newParentPoint.x
			clip.y = newParentPoint.y
			clip.rotation += rotationDifference;
//			if (forces) {
//				var forcePoint:Point = AShip(clip).getForcesPoint();
//				var testMatrix:Matrix = new Matrix(1, 0, 0, 1, forcePoint.x, forcePoint.y);
//				testMatrix.rotate(degreesToRads(rotationDifference));
//				AShip(clip).setForcesPoint(new Point(testMatrix.tx, testMatrix.ty));
//			}
//			trace("ship1.parent: " + clip.parent);
		}
		
		public static function getConcatenatedRotation(displayObject:DisplayObject):Number {
			var dummyMatrix:Matrix;
			var dummyClip:Sprite;
			
			dummyMatrix = displayObject.transform.concatenatedMatrix;
			dummyClip = new Sprite();
			dummyClip.transform.matrix = dummyMatrix;
			var concatenatedRotation:Number = dummyClip.rotation;
			
			dummyMatrix = null;
			dummyClip = null;
			
			return concatenatedRotation;
		}
		
		public static function getConcatenatedXScale(displayObject:DisplayObject):Number {
			var dummyMatrix:Matrix;
			var dummyClip:Sprite;
			
			dummyMatrix = displayObject.transform.concatenatedMatrix;
			dummyClip = new Sprite();
			dummyClip.transform.matrix = dummyMatrix;
			var concatenatedXscale:Number = dummyClip.scaleX;
			
			dummyMatrix = null;
			dummyClip = null;
			
			return concatenatedXscale;
		}
		
		public static function getLocalPos(myTarget:Object, mySubject:Object):Point {
			var pt1:Point = new Point();
			pt1 = myTarget.localToGlobal(pt1);
			pt1 = mySubject.parent.globalToLocal(pt1);
			return pt1;
		}
		
		public static function getGlobalPos(mySubject:Object):Point {
			var pt1:Point = new Point();
			pt1 = mySubject.localToGlobal(pt1);
			return pt1;
		}
		
		public static function startingPos(mySubject:DisplayObject, myTarget:DisplayObject, rotate:Boolean=true):void {
			var startingPoint:Point = getLocalPos(myTarget, mySubject);
			mySubject.x = startingPoint.x
			mySubject.y = startingPoint.y
			//trace("concat XSCALE: " + getConcatenatedXScale( myTarget ) );
			if (rotate) {
				var targetRotation:Number = getConcatenatedRotation(myTarget);
				var subjectParentRotation:Number = getConcatenatedRotation(mySubject);
				mySubject.rotation = targetRotation - subjectParentRotation;
				if (myTarget.parent.scaleX < 0 || myTarget.parent.parent.scaleX < 0) {
					mySubject.rotation += 180;
				}
			}
		}
		
		public static function getDistFromTo(fromObject:Object, toObject:Object):Number {
			var fromPoint:Point = new Point(fromObject.x, fromObject.y);
			var toPoint:Point = new Point();
			toPoint = toObject.localToGlobal(toPoint);
			toPoint = fromObject.parent.globalToLocal(toPoint);
			var dist:Number = Point.distance(fromPoint, toPoint);
			return dist;
		}
		
		public function scaleTo(percentage:Number, speed:Number=2):void {
			var targetScale:Number = (percentage - subject.scaleX) / speed
			subject.scaleX += targetScale
			subject.scaleY += targetScale;
		}
		
		public function springScaleTo(percentage:Number, spring:Number=0.1, friction:Number=0.8):void {
			
			vX += (percentage - subject.scaleX) * spring
			vY += (percentage - subject.scaleY) * spring
			vX *= friction
			vY *= friction
			
			subject.scaleX += vX
			subject.scaleY += vY;
		}
		
		public function scaleByDist(dist:Number, perimeter:Number=200, minSize:Number=0.5, speed:Number=10, factor:Number=800):Number {
			var overPerimeter:Number;
			if (dist > perimeter) {
				overPerimeter = dist - perimeter;
			} else {
				overPerimeter = 0;
			}
			var sDest:Number = 1 - (overPerimeter / factor);
			if (sDest < minSize) {
				sDest = minSize;
			}
			subject.scaleX += (sDest - subject.scaleX) / 10;
			subject.scaleY += (sDest - subject.scaleY) / 10;
			if (subject.scaleX > .99) {
				subject.scaleX = 1
				subject.scaleY = 1
			}
			return subject.scaleX;
		}
		
		public function springScaleByDist(dist:Number, innerPerimeter:Number=200, outerPerimeter:Number=1600, minSize:Number=0.5, maxSize:Number=1, spring:Number=0.05, friction:Number=0.8):Number {
			var overPerimeter:Number;
			if (dist > innerPerimeter) {
				overPerimeter = dist - innerPerimeter;
			} else {
				overPerimeter = 0;
			}
			var sDest:Number = maxSize - (overPerimeter / outerPerimeter);
			if (sDest < minSize) {
				sDest = minSize;
			}
			vX += (sDest - subject.scaleX) * spring
			vY += (sDest - subject.scaleY) * spring
			vX *= friction
			vY *= friction
			
			subject.scaleX += vX;
			subject.scaleY += vY;
			
			if (subject.scaleX > maxSize) {
				subject.scaleX = maxSize
				subject.scaleY = maxSize
			}
			return subject.scaleX;
		}
		
		public static function randomizePosition(target:DisplayObject, xSpread:int=1000, ySpread:int=1000, rotate:Boolean=true):void {
			target.x = Math.floor(Math.random() * xSpread) - (xSpread / 2);
			target.y = Math.floor(Math.random() * ySpread) - (ySpread / 2);
			if (rotate)
				target.rotation = Math.floor(Math.random() * 360);
		}
		
		public static function repelAwayFrom(toRepel:DisplayObject, toRepelAwayFrom:DisplayObject, distanceToMove:Number=1):void {
			var degs:Number = PTmove.degreesFromPointToPoint(new Point(toRepel.x, toRepel.y), getLocalPos(toRepelAwayFrom, toRepel));
			var repelPoint:Point = Point.polar(distanceToMove, degreesToRadsAdjusted(degs + 180));
			toRepel.x += repelPoint.x;
			toRepel.y += repelPoint.y;
		}
		
		public function cleanup():void {
			setSubject(null);
		}
	}
}
