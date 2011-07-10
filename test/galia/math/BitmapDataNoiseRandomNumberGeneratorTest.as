package galia.math
{
	import flexunit.framework.Assert;
	
	public class BitmapDataNoiseRandomNumberGeneratorTest extends MathRandomNumberGeneratorTest
	{		
		[Before]
		override public function setUp():void {
			randomNumberGenerator = new BitmapDataNoiseRandomNumberGenerator();
			numValues = 1000;
			values = [];
			acceptablePercentageTolerance = 0.05;
		}
		
		[Test]
		public function testSeed():void {
			var seedInput:uint = 5;
			(randomNumberGenerator as BitmapDataNoiseRandomNumberGenerator).seed = seedInput;
			Assert.assertStrictlyEquals('seed property should match input seed', seedInput, (randomNumberGenerator as BitmapDataNoiseRandomNumberGenerator).seed);
		}
		
		[Test]
		public function testPointer():void {
			var pointerInput:uint = 5;
			(randomNumberGenerator as BitmapDataNoiseRandomNumberGenerator).pointer = pointerInput;
			Assert.assertStrictlyEquals('pointer property should match input pointer', pointerInput, (randomNumberGenerator as BitmapDataNoiseRandomNumberGenerator).pointer);
		}
	}
}