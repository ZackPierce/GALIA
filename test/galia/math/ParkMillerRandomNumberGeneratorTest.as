package galia.math
{
	import flexunit.framework.Assert;
	
	import galia.core.IRandomNumberGenerator;
	
	public class ParkMillerRandomNumberGeneratorTest extends MathRandomNumberGeneratorTest
	{
		[Before]
		override public function setUp():void {
			randomNumberGenerator = new ParkMillerRandomNumberGenerator();
			numValues = 1000;
			values = [];
			acceptablePercentageTolerance = 0.05;
		}
		
		[Test]
		public function testSeed():void {
			var seedInput:uint = 5;
			(randomNumberGenerator as ParkMillerRandomNumberGenerator).seed = seedInput;
			Assert.assertStrictlyEquals('seed property should match input seed', seedInput, (randomNumberGenerator as ParkMillerRandomNumberGenerator).seed);
		}
	}
}