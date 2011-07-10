package galia.seeding
{
	import flexunit.framework.Assert;
	
	import galia.base.ByteArrayChromosome;
	
	public class ByteArrayRandomizedCreationSeedingStrategyTest
	{
		private var byteArrayRandomizedCreationSeedingStrategy:ByteArrayRandomizedCreationSeedingStrategy;
		private var chromosomeSize:uint;
		private var numberOfChromosomes:uint;
		private var outputChromosomes:Array;
		
		[Before]
		public function setUp():void {
			byteArrayRandomizedCreationSeedingStrategy = new ByteArrayRandomizedCreationSeedingStrategy();
			chromosomeSize = 0;
			numberOfChromosomes = 0;
		}
		
		[After]
		public function tearDown():void {
			byteArrayRandomizedCreationSeedingStrategy = null;
			chromosomeSize = 0;
			numberOfChromosomes = 0;
			outputChromosomes = null;
		}
		
		[Test]
		public function testGenerateChromosomes():void {
			numberOfChromosomes = 5;
			chromosomeSize = 10;
			byteArrayRandomizedCreationSeedingStrategy.chromosomeSize = chromosomeSize;
			outputChromosomes = byteArrayRandomizedCreationSeedingStrategy.generateChromosomes(numberOfChromosomes);
			Assert.assertNotNull("Output array of chromosomes is not null", outputChromosomes);
			Assert.assertStrictlyEquals("Output array of chromosomes length matches input numberOfChromosomes parameter", numberOfChromosomes, outputChromosomes.length);
			for each (var possibleChromosome:Object in outputChromosomes) {
				Assert.assertTrue('every output chromosome is a ByteArrayChromosome', possibleChromosome is ByteArrayChromosome);
				Assert.assertStrictlyEquals('every output chromosome length matches the chromosomeSize value', chromosomeSize, (possibleChromosome as ByteArrayChromosome).length);
			}
		}
		
		[Test]
		public function testGenerateChromosomesZeroChromosomes():void {
			numberOfChromosomes = 0;
			chromosomeSize = 10;
			byteArrayRandomizedCreationSeedingStrategy.chromosomeSize = chromosomeSize;
			outputChromosomes = byteArrayRandomizedCreationSeedingStrategy.generateChromosomes(numberOfChromosomes);
			Assert.assertNotNull("Output array of chromosomes is not null even when no chromsomes requested", outputChromosomes);
			Assert.assertStrictlyEquals("Output array of chromosomes length matches input numberOfChromosomes parameter", numberOfChromosomes, outputChromosomes.length);
		}
	}
}