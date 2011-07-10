package galia.procreation
{
	import flexunit.framework.Assert;
	
	import galia.base.ByteArrayChromosome;
	
	public class ByteArrayRandomizedCreationTest
	{		
		protected static const DEFAULT_SEED:uint = 2;
		
		private var byteArrayRandomizedCreation:ByteArrayRandomizedCreation;
		private var parents:Array;
		private var kids:Array;
		private var byteArrayChromosome:ByteArrayChromosome;
		
		[Before]
		public function setUp():void {
			byteArrayRandomizedCreation = new ByteArrayRandomizedCreation();
			byteArrayRandomizedCreation.seed = DEFAULT_SEED;
			parents = [];
			kids = null;
			byteArrayChromosome = new ByteArrayChromosome();
		}
		
		[After]
		public function tearDown():void {
			byteArrayRandomizedCreation = null;
			parents = null;
			kids = null;
			byteArrayChromosome = null;
		}
		
		[Test]
		public function testProcreateNullParents():void {
			parents = null;
			kids = byteArrayRandomizedCreation.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertStrictlyEquals('null parents array leads to an output kids array with a single member', 1, kids.length);
			Assert.assertStrictlyEquals('with null parents and no explicit chromosome size set, the kid chromosome output should have a length of 0', 0, kids[0].length);
		}
		
		[Test]
		public function testProcreateNullParentsExplicitSize():void {
			parents = null;
			byteArrayRandomizedCreation.explicitChromosomeSize = 3;
			kids = byteArrayRandomizedCreation.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertStrictlyEquals('null parents array leads to an output kids array with a single member', 1, kids.length);
			Assert.assertStrictlyEquals('with null parents but explicit chromosome size set, the kid chromosome output should have a length equal to the explicit chromosome size', byteArrayRandomizedCreation.explicitChromosomeSize, kids[0].length);
		}
		
		[Test]
		public function testProcreateNullParentsExplicitSizeSeedControl():void {
			parents = null;
			byteArrayRandomizedCreation.explicitChromosomeSize = 1;
			byteArrayRandomizedCreation.seed = DEFAULT_SEED;
			kids = byteArrayRandomizedCreation.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertStrictlyEquals('null parents array leads to an output kids array with a single member', 1, kids.length);
			Assert.assertStrictlyEquals('with null parents but explicit chromosome size set, the kid chromosome output should have a length equal to the explicit chromosome size', byteArrayRandomizedCreation.explicitChromosomeSize, kids[0].length);
			Assert.assertStrictlyEquals('byteArrayRandomizedCreation seed property allows us to control the random values produced', -128, kids[0].readByte());
		}
		
		[Test]
		public function testProcreateEmptyParents():void {
			parents = [];
			kids = byteArrayRandomizedCreation.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertStrictlyEquals('empty parents array leads to an output kids array with a single member', 1, kids.length);
			Assert.assertStrictlyEquals('with empty parents and no explicit chromosome size set, the kid chromosome output should have a length of 0', 0, kids[0].length);
		}
		
		[Test]
		public function testProcreateEmptyParentsExplicitSize():void {
			parents = [];
			byteArrayRandomizedCreation.explicitChromosomeSize = 3;
			kids = byteArrayRandomizedCreation.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertStrictlyEquals('empty parents array leads to an output kids array with a single member', 1, kids.length);
			Assert.assertStrictlyEquals('with empty parents but explicit chromosome size set, the kid chromosome output should have a length equal to the explicit chromosome size', byteArrayRandomizedCreation.explicitChromosomeSize, kids[0].length);
		}
		
		[Test]
		public function testProcreate():void {
			var inputBytes:Array = [[42], [50, 87], [34, 100, 110]];
			parents = [];
			for each (var byteCollection:Array in inputBytes) {
				byteArrayChromosome = new ByteArrayChromosome();
				for each (var byte:int in byteCollection) {
					byteArrayChromosome.writeByte(byte);
				}
				parents.push(byteArrayChromosome);
			}
			kids = byteArrayRandomizedCreation.procreate(parents);
			Assert.assertStrictlyEquals('Kids array produced by procreate should have same length as input parents array', parents.length, kids.length);
			for (var i:uint = 0; i < kids.length; i++) {
				var kidChromosome:Object = kids[i];
				Assert.assertTrue('Output kids are all ByteArrayChromosomes', kidChromosome is ByteArrayChromosome);
				var byteArrayKid:ByteArrayChromosome = kidChromosome as ByteArrayChromosome;
				Assert.assertStrictlyEquals('Output kid at index (' + i + ') length match parent chromosome length', inputBytes[i].length, byteArrayKid.length);
			}
		}
	}
}