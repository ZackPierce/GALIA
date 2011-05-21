package galia.procreation
{
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	
	import galia.base.ByteArrayChromosome;

	public class ByteArrayPointMutationTest
	{
		private var byteArrayPointMutation:ByteArrayPointMutation;
		private var chromosome:ByteArrayChromosome;
		private var seed:uint;
		
		private var parents:Array;
		private var kids:Array;
		
		[Before]
		public function setUp():void
		{
			byteArrayPointMutation = new ByteArrayPointMutation();
			chromosome = new ByteArrayChromosome();
			seed = 2;
			parents = [];
		}
		
		[After]
		public function tearDown():void
		{
			byteArrayPointMutation = null;
			chromosome = null;
			seed = 0;
			parents = null;
			kids = null;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testProcreateNullParents():void {
			kids = byteArrayPointMutation.procreate(null);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids); 
		}
		
		[Test]
		public function testProcreateEmptyParents():void {
			kids = byteArrayPointMutation.procreate([]);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('Empty parents array leads to an empty output kids array', kids.length == 0);
		}
		
		[Test]
		public function testProcreateNoMutationSingleParent():void {
			var sourceByte:int = 36;
			chromosome.writeByte(sourceByte);
			parents = [chromosome];
			byteArrayPointMutation.mutationRate = 0;
			kids = byteArrayPointMutation.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('Number of parents matches number of output kids', kids.length == 1);
			for each (var kid:Object in kids) {
				Assert.assertTrue('All children should be unique Objects from their parents', parents.indexOf(kid) < 0);
			}
			var outputKid:ByteArray = kids[0];
			var kidValue:int = outputKid.readByte();
			Assert.assertTrue('Kid chromosome values should be the same as parent when mutation is 0', kidValue == sourceByte); 
		}
		
		[Test]
		public function testProcreateFullMutationSingleParent():void {
			var sourceByte:int = 36;
			chromosome.writeByte(sourceByte);
			parents = [chromosome];
			byteArrayPointMutation.mutationRate = 1.0;
			byteArrayPointMutation.seed = seed; // Assuming 2
			kids = byteArrayPointMutation.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('Number of parents matches number of output kids', kids.length == 1);
			for each (var kid:Object in kids) {
				Assert.assertTrue('All children should be unique Objects from their parents', parents.indexOf(kid) < 0);
			}
			var outputKid:ByteArray = kids[0];
			outputKid.position = 0;
			var kidValue:int = outputKid.readByte();
			Assert.assertTrue('Kid chromosome values should almost definitely not be the same as parent when mutation is 1.0', kidValue != sourceByte); 
		}
		
		
		[Test]
		public function testProcreateFullMutationSingleParentLongerContents():void {
			var sourceByteA:int = 2;
			var sourceByteB:int = 4;
			var sourceByteC:int = 6;
			var sourceByteD:int = 8;
			var sourceByteE:int = 10;
			var sourceByteF:int = 12;
			var sourceBytes:Array = [sourceByteA, sourceByteB, sourceByteC, sourceByteD, sourceByteE, sourceByteF];
			for each (var sourceByte:int in sourceBytes) {
				chromosome.writeByte(sourceByte);
			}
			parents = [chromosome];
			byteArrayPointMutation.mutationRate = 1.0;
			byteArrayPointMutation.seed = seed; // Assuming 2
			kids = byteArrayPointMutation.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('Number of parents matches number of output kids', kids.length == 1);
			for each (var kid:Object in kids) {
				Assert.assertTrue('All children should be unique Objects from their parents', parents.indexOf(kid) < 0);
			}
			var outputKid:ByteArray = kids[0];
			outputKid.position = 0;
			Assert.assertTrue('Kid should have the same number of bytes as the parent', outputKid.length == chromosome.length);
			for (var i:int = 0; i < sourceBytes.length; i++) {
				outputKid.position = i;
				chromosome.position = i;
				Assert.assertTrue('Kid chromosome values should almost definitely not be the same as parent when mutation is 1.0', outputKid.readByte() != chromosome.readByte());
			}
		}
		
		[Test]
		public function testProcreateHalfMutationSingleParentLongerContents():void {
			var sourceBytes:Array = [];
			for (var s:int = 0; s < 100; s++) {
				sourceBytes.push(s);
			}
			for each (var sourceByte:int in sourceBytes) {
				chromosome.writeByte(sourceByte);
			}
			parents = [chromosome];
			var mutationRate:Number = 0.5;
			byteArrayPointMutation.mutationRate = mutationRate;
			byteArrayPointMutation.seed = seed; // Assuming 2
			kids = byteArrayPointMutation.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('Number of parents matches number of output kids', kids.length == 1);
			for each (var kid:Object in kids) {
				Assert.assertTrue('All children should be unique Objects from their parents', parents.indexOf(kid) < 0);
			}
			var outputKid:ByteArray = kids[0];
			outputKid.position = 0;
			Assert.assertTrue('Kid should have the same number of bytes as the parent', outputKid.length == chromosome.length);
			var matchCount:int = 0;
			for (var i:int = 0; i < sourceBytes.length; i++) {
				outputKid.position = i;
				chromosome.position = i;
				if (outputKid.readByte() == chromosome.readByte()) {
					matchCount++;
				}
			}
			
			var foundMutationRate:Number = 1.0 - Number(matchCount) / sourceBytes.length;
			var tolerance:Number = 0.01;
			Assert.assertTrue('Kid chromosome values should be different about half the time when the mutation rate is 0.5', mutationRate - tolerance <= foundMutationRate && foundMutationRate <= mutationRate + tolerance);
		}
		
		[Test]
		public function testProcreateFractionalMutationSingleParentLongerContents():void {
			var sourceBytes:Array = [];
			for (var s:int = 0; s < 1000; s++) {
				sourceBytes.push(s);
			}
			for each (var sourceByte:int in sourceBytes) {
				chromosome.writeByte(sourceByte);
			}
			parents = [chromosome];
			var mutationRate:Number = 0.1;
			byteArrayPointMutation.mutationRate = mutationRate;
			byteArrayPointMutation.seed = seed; // Assuming 2
			kids = byteArrayPointMutation.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('Number of parents matches number of output kids', kids.length == 1);
			for each (var kid:Object in kids) {
				Assert.assertTrue('All children should be unique Objects from their parents', parents.indexOf(kid) < 0);
			}
			var outputKid:ByteArray = kids[0];
			outputKid.position = 0;
			Assert.assertTrue('Kid should have the same number of bytes as the parent', outputKid.length == chromosome.length);
			var matchCount:int = 0;
			for (var i:int = 0; i < sourceBytes.length; i++) {
				outputKid.position = i;
				chromosome.position = i;
				if (outputKid.readByte() == chromosome.readByte()) {
					matchCount++;
				}
			}
			
			var foundMutationRate:Number = 1.0 - Number(matchCount) / sourceBytes.length;
			var tolerance:Number = 0.01;
			Assert.assertTrue('Kid chromosome values should be different about ten percent of the time when the mutation rate is 0.1', mutationRate - tolerance <= foundMutationRate && foundMutationRate <= mutationRate + tolerance);
		}
	}
}