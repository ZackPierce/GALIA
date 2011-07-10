package galia.core
{
	public interface IRandomNumberGenerator
	{
		/**
		 * Returns 0 or 1 psuedo-randomly.
		 * @param chanceOfOne The chance that the value returned will be 1 rather than 0, as expressed as a probability Number between 0 and 1.0.  The higher the input chanceOfOne, the greater the probability that the return value will be 1.
		 * @return A psuedo-randomly chosen int value of 0 or 1.
		 */
		function bit(chanceOfOne:Number = 0.5):int;
		
		/**
		 * @param chanceOfTrue The chance that the Boolean returned will be true, as expressed as a probability Number between 0 and 1.0.  The higher the input chanceOfTrue, the greater the probability that the return value will be true. 
		 * @return A psuedo-randomly chosen Boolean value.
		 */
		function boolean(chanceOfTrue:Number = 0.5):Boolean;
		
		/**
		 * @param min The minimum possible random value.
		 * @param max. The maximum boundary above possible random values.  If max is not provided, the number returned will be between 0 and min.  [0, min)
		 * @return A psuedo-random Number between min and max exclusive.  Formally, [min, max)
		 */
		function float(min:Number,max:Number=NaN):Number;
		
		/**
		 * @param min The minimum possible random value.
		 * @param max. The maximum boundary above possible random values.  If max is not provided, the number returned will be between 0 and min.  [0, min)
		 * @return A psuedo-random int between min and max exclusive.  Formally, [min, max)
		 */
		function integer(min:Number,max:Number=NaN):int;
		
		/**
		 * @return A psuedo-random Number between 0 and 1.0 exclusive.  Formally, [0, 1) 
		 */
		function random():Number;
		
		/**
		 * Returns -1 or 1 psuedo-randomly.
		 * @param chanceOfPositive The chance that the value returned will be 1 rather than -1, as expressed as a probability Number between 0 and 1.0.   The higher the input chanceOfPositive, the greater the probability that the return value will be 1.
		 * @return A psuedo-randomly chosen int value of -1 or 1.
		 */
		function sign(chanceOfPositive:Number = 0.5):int;
	}
}