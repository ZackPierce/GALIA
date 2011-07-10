package galia.procreation
{
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	
	import galia.base.ByteArrayChromosome;
	import galia.math.ParkMillerRandomNumberGenerator;
	
	public class ByteArrayMultiPointCrossoverTest
	{
		private var byteArrayMultiPointCrossover:ByteArrayMultiPointCrossover;
		private var chromosomeA:ByteArrayChromosome;
		private var chromosomeB:ByteArrayChromosome;
		private var seed:uint;
		
		private var parents:Array;
		private var kids:Array;
		
		[Before]
		public function setUp():void {
			byteArrayMultiPointCrossover = new ByteArrayMultiPointCrossover();
			seed = 5000;
			byteArrayMultiPointCrossover.randomNumberGenerator = new ParkMillerRandomNumberGenerator(seed);
			
			// Set up contents such that all of chromosomeA's values are negative integers
			chromosomeA = new ByteArrayChromosome();
			for (var i:int = -127; i < 0; i++) {
				chromosomeA.writeByte(i);
			}
			chromosomeA.position = 0;
			
			// Set up contents such that all of chromosomeB's values are positive integers
			chromosomeB = new ByteArrayChromosome();
			for (var j:int = 1; j < 128; j++) {
				chromosomeB.writeByte(j);
			}
			chromosomeB.position = 0;
			
			parents = [];
		}
		
		[After]
		public function tearDown():void {
			byteArrayMultiPointCrossover = null;
			chromosomeA = null;
			chromosomeB = null;
			seed = 0;
			parents = null;
			kids = null;
		}
		
		[Test]
		public function testProcreateNullParents():void {
			kids = byteArrayMultiPointCrossover.procreate(null);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('null parents array leads to an empty output kids array', kids.length == 0);
		}
		
		[Test]
		public function testProcreateEmptyParents():void {
			kids = byteArrayMultiPointCrossover.procreate([]);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('Empty parents array leads to an empty output kids array', kids.length == 0);
		}
		
		[Test]
		public function testProcreateInsufficientParents():void {
			parents = [chromosomeA];
			kids = byteArrayMultiPointCrossover.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('Insufficient parents array leads to an empty output kids array', kids.length == 0);
		}
		
		[Test]
		public function testProcreateNoCrossoverPoints():void {
			
			parents = [chromosomeA, chromosomeB];
			byteArrayMultiPointCrossover.numberOfCrossoverPoints = 0;
			kids = byteArrayMultiPointCrossover.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('Two chromosome parents array leads to an output kids array of the same length', kids.length == parents.length);
			for (var i:int = 0; i < kids.length; i++) {
				var kid:ByteArray = kids[i];
				var parent:ByteArray = parents[i];
				Assert.assertStrictlyEquals('With no crossover points, each kid should have the same length as the parent', parent.length, kid.length);
				for (var j:int = 0; j < kid.length; j++) {
					kid.position = j;
					parent.position = j;
					Assert.assertStrictlyEquals('With no crossover points, each kid should have identical contents to its corresponding parent for each byte', parent.readByte(), kid.readByte());
				}
			}
		}
		
		[Test]
		public function testProcreateOneCrossoverPoint():void {
			
			parents = [chromosomeA, chromosomeB];
			byteArrayMultiPointCrossover.numberOfCrossoverPoints = 1;
			kids = byteArrayMultiPointCrossover.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('Two chromosome parents array leads to an output kids array of the same length', kids.length == parents.length);
			
			var kidA:ByteArray = kids[0];
			var kidB:ByteArray = kids[1];
			Assert.assertNotNull('First kid of non-null parents must be non-null', kidA);
			Assert.assertNotNull('Second kid of non-null parents must be non-null', kidB);
			Assert.assertStrictlyEquals('First kid data length must match first parent length', chromosomeA.length, kidA.length);
			Assert.assertStrictlyEquals('Second kid data length must match second parent length', chromosomeB.length, kidB.length);
			
			var kidAInts:Array = [];
			var kidBInts:Array = []
			for (var j:int = 0; j < kidA.length; j++) {
				kidA.position = j;
				kidAInts.push(kidA.readByte());
				kidB.position = j;
				kidBInts.push(kidB.readByte());
			}
			
			var expectedCrossoverIndex:int = 4; // Assuming a seed value of 5000, we expect the crossover point to be at index 4
			for (var i:int = 0; i < chromosomeA.length; i++) {
				chromosomeA.position = i;
				chromosomeB.position = i;
				kidA.position = i;
				kidB.position = i;
				
				var parentAValue:int = chromosomeA.readByte();
				var parentBValue:int = chromosomeB.readByte();
				if (i < expectedCrossoverIndex) {
					Assert.assertStrictlyEquals("Prior to the crossover index, the first kid's values should match that of the first parent", parentAValue, kidA.readByte());
					Assert.assertStrictlyEquals("Prior to the crossover index, the second kid's values should match that of the second parent", parentBValue, kidB.readByte());
				} else {
					Assert.assertStrictlyEquals("After the crossover index, the first kid's values should match that of the second parent", parentBValue, kidA.readByte());
					Assert.assertStrictlyEquals("After the crossover index, the second kid's values should match that of the first parent", parentAValue, kidB.readByte());
				}
			}
		}
		
		[Test]
		public function testProcreateTwoCrossoverPoints():void {
			
			parents = [chromosomeA, chromosomeB];
			byteArrayMultiPointCrossover.numberOfCrossoverPoints = 2;
			kids = byteArrayMultiPointCrossover.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('Two chromosome parents array leads to an output kids array of the same length', kids.length == parents.length);
			
			var kidA:ByteArray = kids[0];
			var kidB:ByteArray = kids[1];
			Assert.assertNotNull('First kid of non-null parents must be non-null', kidA);
			Assert.assertNotNull('Second kid of non-null parents must be non-null', kidB);
			Assert.assertStrictlyEquals('First kid data length must match first parent length', chromosomeA.length, kidA.length);
			Assert.assertStrictlyEquals('Second kid data length must match second parent length', chromosomeB.length, kidB.length);
			
			var kidAInts:Array = [];
			var kidBInts:Array = []
			for (var j:int = 0; j < kidA.length; j++) {
				kidA.position = j;
				kidAInts.push(kidA.readByte());
				kidB.position = j;
				kidBInts.push(kidB.readByte());
			}
			
			var expectedCrossoverStart:int = 4; // Assuming a seed value of 5000, we expect the crossover point to be at index 4
			var expectedCrossoverEnd:int = 87; // Assuming a seed value of 5000, we expect the next crossover point to be at index 87
			for (var i:int = 0; i < chromosomeA.length; i++) {
				chromosomeA.position = i;
				chromosomeB.position = i;
				kidA.position = i;
				kidB.position = i;
				
				var parentAValue:int = chromosomeA.readByte();
				var parentBValue:int = chromosomeB.readByte();
				if (i < expectedCrossoverStart || i > expectedCrossoverEnd) {
					Assert.assertStrictlyEquals("Outside of the crossover region, the first kid's values should match that of the first parent", parentAValue, kidA.readByte());
					Assert.assertStrictlyEquals("Outside of the crossover region, the second kid's values should match that of the second parent", parentBValue, kidB.readByte());
				} else {
					Assert.assertStrictlyEquals("Inside the crossover region, the first kid's values should match that of the second parent", parentBValue, kidA.readByte());
					Assert.assertStrictlyEquals("Inside the crossover region, the second kid's values should match that of the first parent", parentAValue, kidB.readByte());
				}
			}
		}
	}
}