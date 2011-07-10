/**
 * This class is strongly based upon the original Rndm implementation
 * by Grant Skinner which made use of the BitmapData.noise function;
 * Largely nominal changes to style and documentation were made.
 * 
 * Rndm by Grant Skinner. Jan 15, 2008
 * Visit www.gskinner.com/blog for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2008 Grant Skinner
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

package galia.math
{
	import flash.display.BitmapData;
	
	import galia.core.IRandomNumberGenerator;
	
	public class BitmapDataNoiseRandomNumberGenerator extends MathRandomNumberGenerator implements IRandomNumberGenerator
	{
		protected var _seed:uint=0;
		protected var _pointer:uint=0;
		protected var bmpd:BitmapData;
		protected var seedInvalid:Boolean = true;
		
		public function BitmapDataNoiseRandomNumberGenerator(seed:uint = 0) {
			_seed = seed;
			bmpd = new BitmapData(1000,200);
		}
		
		public function get seed():uint {
			return _seed;
		}
		
		public function set seed(value:uint):void {
			if (value != _seed) {
				seedInvalid = true;
				_pointer = 0;
			}
			_seed = value;
		}
		
		public function get pointer():uint {
			return _pointer;
		}
		public function set pointer(value:uint):void {
			_pointer = value;
		}
		
		/** @inheritDoc */
		override public function random():Number {
			if (seedInvalid) {
				bmpd.noise(_seed,0,255,1|2|4|8);
				seedInvalid = false;
			}
			_pointer = (_pointer+1)%200000;
			// Flash's numeric precision appears to run to 0.9999999999999999, but we'll drop one digit to be safe:
			return (bmpd.getPixel32(_pointer%1000,_pointer/1000>>0)*0.999999999999998+0.000000000000001)/0xFFFFFFFF;
		}
	}
}