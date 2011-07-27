package com.presstube.utils {
	import flash.geom.ColorTransform;
	
	public class Tinter {
		
		public static function RGBtoHEX(r:Number, g:Number, b:Number):Number {
			return r << 16 | g << 8 | b;
		}
		
		public static function tintToBG(targetObject:Object, objectID:int, numOfObjects:int, baseColorRR:int, baseColorGG:int, baseColorBB:int, aM:Number=1, offset:int=0):void {
			var targetObject:Object; // object whose color will be changed
			var objectID:int; // index of object (likely it is in a set of objs)
			var numOfObjects:int; // total number of objects in the series
			var baseColorRR:int; // BG's "red" value in RGB
			var baseColorGG:int; // BG's "green" value in RGB
			var baseColorBB:int; // BG's "blue" value in RGB
			var RRIncrement:Number; // amount to tint object
			var GGIncrement:Number; // ""
			var BBIncrement:Number; // ""
			var rM:Number; // the 'redMultiplier' for the ColorTransform object
			var gM:Number; // the 'greenMultiplier' ""
			var bM:Number; // the 'blueMultiplier' ""
			var aM:Number; // the 'alphaMultiplier' ""
			var rO:Number // the 'redOffset' ""
			var gO:Number // the 'greenOffset' ""
			var bO:Number // the 'blueOffset' ""
			var aO:Number // the 'alphaOffset' ""
			
			numOfObjects += offset
			
			RRIncrement = baseColorRR / numOfObjects
			GGIncrement = baseColorGG / numOfObjects
			BBIncrement = baseColorBB / numOfObjects
			rM = objectID / numOfObjects
			gM = objectID / numOfObjects
			bM = objectID / numOfObjects
			//aM = 1 
			rO = int(baseColorRR - ((objectID) * RRIncrement));
			gO = int(baseColorGG - ((objectID) * GGIncrement));
			bO = int(baseColorBB - ((objectID) * BBIncrement));
			aO = 0;
			targetObject.transform.colorTransform = new ColorTransform(rM, gM, bM, aM, rO, gO, bO, aO);
		}
	}
}
