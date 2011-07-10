/**
 * This class is strongly based upon Rndm by Grant Skinner;
 * largely nominal changes to style and documentation were made.
 * 
 * Rndm by Grant Skinner. Jan 15, 2008
 * Visit www.gskinner.com/blog for documentation, updates and more free code.
 *
 * Incorporates implementation of the Park Miller (1988) "minimal standard" linear 
 * congruential pseudo-random number generator by Michael Baczynski, www.polygonal.de.
 * (seed * 16807) % 2147483647
 *
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
	import galia.core.IRandomNumberGenerator;
	
	public class ParkMillerRandomNumberGenerator extends MathRandomNumberGenerator implements IRandomNumberGenerator
	{
		private var _seed:uint;
		private var _currentSeed:uint;
		
		public function ParkMillerRandomNumberGenerator(seed:uint = 1) {
			this.seed = seed;
		}
		
		/** @inheritDoc */
		override public function random():Number {
			return (_currentSeed = (_currentSeed * 16807) % 2147483647)/0x7FFFFFFF+0.000000000233;
		}
		
		public function get seed():uint {
			return _seed;
		}
		
		public function set seed(value:uint):void {
			_seed = value;
			_currentSeed = value;
		}
	}
}