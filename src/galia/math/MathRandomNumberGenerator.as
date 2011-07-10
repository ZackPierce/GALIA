package galia.math
{
	import galia.core.IRandomNumberGenerator;
	
	public class MathRandomNumberGenerator implements IRandomNumberGenerator
	{
		public function MathRandomNumberGenerator() {
		}
		
		/** @inheritDoc */
		public function bit(chanceOfOne:Number=0.5):int {
			return (random() < chanceOfOne) ? 1 : 0;
		}
		
		/** @inheritDoc */
		public function boolean(chanceOfTrue:Number=0.5):Boolean {
			return (random() < chanceOfTrue);
		}
		
		/** @inheritDoc */
		public function float(min:Number, max:Number=NaN):Number {
			if (isNaN(max)) {
				max = min;
				min = 0;
			}
			return random()*(max - min) + min;
		}
		
		/** @inheritDoc */
		public function integer(min:Number, max:Number=NaN):int {
			if (isNaN(max)) {
				max = min;
				min = 0;
			}
			// Need to use floor instead of bit shift to work properly with negative values:
			return Math.floor(float(min,max));
		}
		
		/** @inheritDoc */
		public function random():Number {
			return Math.random();
		}
		
		/** @inheritDoc */
		public function sign(chanceOfPositive:Number=0.5):int {
			return (random() < chanceOfPositive) ? 1 : -1;
		}
	}
}