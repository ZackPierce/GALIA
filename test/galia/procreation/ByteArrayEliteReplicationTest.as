package galia.procreation
{
	import flexunit.framework.Assert;
	
	import galia.base.ByteArrayChromosome;
	
	public class ByteArrayEliteReplicationTest
	{
		private var byteArrayEliteReplication:ByteArrayEliteReplication;
		private var parents:Array;
		private var kids:Array;
		private var byteArrayChromosome:ByteArrayChromosome;
		
		[Before]
		public function setUp():void {
			byteArrayEliteReplication = new ByteArrayEliteReplication();
			parents = [];
			kids = null;
			byteArrayChromosome = new ByteArrayChromosome();
		}
		
		[After]
		public function tearDown():void {
			byteArrayEliteReplication = null;
			parents = null;
			kids = null;
			byteArrayChromosome = null;
		}
		
		[Test]
		public function testProcreateNullParents():void {
			parents = null;
			kids = byteArrayEliteReplication.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('null parents array leads to an empty output kids array', kids.length == 0);
		}
		
		[Test]
		public function testProcreateEmptyParents():void {
			parents = [];
			kids = byteArrayEliteReplication.procreate(parents);
			Assert.assertNotNull('Kids array produced by procreate should never be null', kids);
			Assert.assertTrue('Empty parents array leads to an empty output kids array', kids.length == 0);
		}
		
		[Test]
		public function testProcreate():void {
			var inputBytes:Array = [42, 50, 87];
			parents = [];
			for each (var byte:int in inputBytes) {
				byteArrayChromosome = new ByteArrayChromosome();
				byteArrayChromosome.writeByte(byte);
				parents.push(byteArrayChromosome);
			}
			kids = byteArrayEliteReplication.procreate(parents);
			Assert.assertStrictlyEquals('Kids array produced by procreate should have same length as input parents array', parents.length, kids.length);
			for (var i:uint = 0; i < kids.length; i++) {
				var kidChromosome:Object = kids[i];
				Assert.assertTrue('Output kids are all ByteArrayChromosomes', kidChromosome is ByteArrayChromosome);
				var byteArrayKid:ByteArrayChromosome = kidChromosome as ByteArrayChromosome;
				Assert.assertStrictlyEquals('Output kid values match parent chromosome values', inputBytes[i], byteArrayKid.readByte());
			}
		}
	}
}