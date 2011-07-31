package galia.math
{
	import flexunit.framework.Assert;
	
	import galia.core.IRandomNumberGenerator;
	
	public class MathRandomNumberGeneratorTest
	{
		protected var randomNumberGenerator:IRandomNumberGenerator;
		protected var numValues:uint;
		protected var values:Array;
		protected var acceptablePercentageTolerance:Number;
		// TODO - replace percentage tolerance testing with proper statistical rigor
		
		[Before]
		public function setUp():void {
			randomNumberGenerator = new MathRandomNumberGenerator();
			numValues = 5000;
			values = [];
			acceptablePercentageTolerance = 0.05;
		}
		
		[After]
		public function tearDown():void {
			randomNumberGenerator = null;
			numValues = 0;
			values = null;
			acceptablePercentageTolerance = 0;
		}
		
		public static function assertWithinAbsoluteTolerance(targetValue:Number, tolerance:Number, value:Number, extraMessage:String = ''):void {
			if (value > targetValue + tolerance) {
				Assert.fail(extraMessage + ' :: exceeded max tolerable boundary of <' + (targetValue + tolerance).toString() + '> with a value of ' + value.toString());
				return;
			}
			if (value < targetValue - tolerance) {
				Assert.fail(extraMessage + ' :: under min tolerable boundary of <' + (targetValue - tolerance).toString() + '> with a value of ' + value.toString());
				return;
			}
			Assert.assertTrue(extraMessage + ':: successfully tested value of <' + value + '> within += <' + tolerance + '> of target value <' + targetValue + '>', true);   
		}
		
		public static function assertWithinTolerancePercentageOfTargetValue(targetValue:Number, tolerancePercentage:Number, value:Number, extraMessage:String = ''):void {
			var boundedPercentage:Number = Math.max(0.0, Math.min(1.0, tolerancePercentage));
			assertWithinAbsoluteTolerance(targetValue, Math.abs(targetValue)*boundedPercentage, value, extraMessage);
		}
		
		[Test]
		public function testBit():void {
			var chanceOfOne:Number = 0.5;
			var sum:Number = 0;
			for (var i:uint = 0; i < numValues; i++) {
				var bit:int = randomNumberGenerator.bit(chanceOfOne);
				sum += bit;
				Assert.assertTrue('bit is 1 or 0', bit == 0 || bit == 1);
			}
			assertWithinTolerancePercentageOfTargetValue(numValues*chanceOfOne, acceptablePercentageTolerance, sum, 'test bits produced');
		}
		
		[Test]
		public function testBoolean():void {
			var chanceOfTrue:Number = 0.5;
			var sum:Number = 0;
			for (var i:uint = 0; i < numValues; i++) {
				var bit:int = randomNumberGenerator.boolean(chanceOfTrue) ? 1 : 0;
				sum += bit;
			}
			assertWithinTolerancePercentageOfTargetValue(numValues*chanceOfTrue, acceptablePercentageTolerance, sum, 'test booleans produced');
		}
		
		[Test]
		public function testFloat():void {
			var max:Number = 1000;
			var sum:Number = 0;
			for (var i:uint = 0; i < numValues; i++) {
				var float:Number = randomNumberGenerator.float(max); 
				sum += float;
				Assert.assertTrue('every value greater than or equal to 0 when only one parameter specified', float >= 0);
				Assert.assertTrue('every value less than input parameter when only one parameter specified', float < max);
			}
			assertWithinTolerancePercentageOfTargetValue(numValues*max*0.5, acceptablePercentageTolerance, sum, 'test floats produced');
		}
		
		[Test]
		public function testFloatTwoParameters():void {
			var min:Number = 500;
			var max:Number = 1000;
			var sum:Number = 0;
			for (var i:uint = 0; i < numValues; i++) {
				var float:Number = randomNumberGenerator.float(min, max); 
				sum += float;
				Assert.assertTrue('every value greater than or equal to min value when both parameters specified', float >= min);
				Assert.assertTrue('every value less than max parameter when specified', float < max);
			}
			assertWithinTolerancePercentageOfTargetValue(numValues*(min + (max - min)*0.5), acceptablePercentageTolerance, sum, 'test floats produced');
		}
		
		[Test]
		public function testInteger():void {
			var max:Number = 1000;
			var sum:Number = 0;
			for (var i:uint = 0; i < numValues; i++) {
				var integer:int = randomNumberGenerator.integer(max); 
				sum += integer;
				Assert.assertTrue('every value greater than or equal to 0 when only one parameter specified', integer >= 0);
				Assert.assertTrue('every value less than input parameter when only one parameter specified', integer < max);
			}
			assertWithinTolerancePercentageOfTargetValue(numValues*max*0.5, acceptablePercentageTolerance, sum, 'test ints produced');
		}
		
		[Test]
		public function testIntegerTwoParameters():void {
			var min:Number = 500;
			var max:Number = 1000;
			var sum:Number = 0;
			for (var i:uint = 0; i < numValues; i++) {
				var integer:int = randomNumberGenerator.float(min, max); 
				sum += integer;
				Assert.assertTrue('every value greater than or equal to min value when both parameters specified', integer >= min);
				Assert.assertTrue('every value less than max parameter when specified', integer < max);
			}
			assertWithinTolerancePercentageOfTargetValue(numValues*(min + (max - min)*0.5), acceptablePercentageTolerance, sum, 'test ints produced');
		}
		
		[Test]
		public function testRandom():void {
			var sum:Number = 0;
			for (var i:uint = 0; i < numValues; i++) {
				var float:Number = randomNumberGenerator.random(); 
				sum += float;
				Assert.assertTrue('every value greater than or equal to 0', float >= 0);
				Assert.assertTrue('every value less than 1.0', float < 1.0);
			}
			assertWithinTolerancePercentageOfTargetValue(numValues*0.5, acceptablePercentageTolerance, sum, 'test random floats [0, 1) produced');
		}
		
		[Test]
		public function testSign():void {
			var bitSum:Number = 0;
			var chanceOfPositive:Number = 0.5;
			for (var i:uint = 0; i < numValues; i++) {
				var sign:Number = randomNumberGenerator.sign(chanceOfPositive); 
				bitSum += sign > 0 ? 1 : 0;
				Assert.assertTrue('every value equal to 1 or -1', sign == -1 || sign == 1);
			}
			assertWithinTolerancePercentageOfTargetValue(numValues*chanceOfPositive, acceptablePercentageTolerance, bitSum, 'test sign function');
		}
	}
}