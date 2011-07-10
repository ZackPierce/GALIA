package galia.seeding
{
	import flexunit.framework.Assert;
	
	import galia.core.IChromosome;
	import galia.populationEvolution.supportClasses.TrivialChromosome;
	
	public class ExternalSourceSeedingStrategyTest
	{
		private var externalSourceSeedingStrategy:ExternalSourceSeedingStrategy;
		private var numChromosomes:uint;
		private var source:Array;
		
		[Before]
		public function setUp():void {
			externalSourceSeedingStrategy = new ExternalSourceSeedingStrategy();
			numChromosomes = 0;
			source = [];
		}
		
		[After]
		public function tearDown():void {
			externalSourceSeedingStrategy = null;
			numChromosomes = 0;
			source = null;
		}
		
		[Test]
		public function testGenerateChromosomes():void {
			source = [new TrivialChromosome(), new TrivialChromosome(), new TrivialChromosome()];
			externalSourceSeedingStrategy.chromosomeSource = source;
			numChromosomes = 3;
			var outputChromosomes:Array = externalSourceSeedingStrategy.generateChromosomes(numChromosomes);
			Assert.assertNotNull('output chromosomes array is non-null', outputChromosomes);
			Assert.assertStrictlyEquals('output chromosomes array has same number of members as input number of chromosomes parameter', numChromosomes, outputChromosomes.length);
			for each (var possibleChromosome:Object in outputChromosomes) {
				Assert.assertTrue('every member of output chromosomes can be found in the source array', source.indexOf(possibleChromosome) >= 0);
				Assert.assertTrue('every member of output chromosomes is an IChromosome', possibleChromosome is IChromosome);
			}
		}
		
		[Test]
		public function testGenerateChromosomesMoreThanAvailable():void {
			source = [new TrivialChromosome(), new TrivialChromosome(), new TrivialChromosome()];
			externalSourceSeedingStrategy.chromosomeSource = source;
			numChromosomes = 6;
			var outputChromosomes:Array = externalSourceSeedingStrategy.generateChromosomes(numChromosomes);
			Assert.assertNotNull('output chromosomes array is non-null', outputChromosomes);
			Assert.assertStrictlyEquals('output chromosomes array has same number of members as input number of chromosomes parameter', numChromosomes, outputChromosomes.length);
			for each (var possibleChromosome:Object in outputChromosomes) {
				Assert.assertTrue('every member of output chromosomes can be found in the source array', source.indexOf(possibleChromosome) >= 0);
				Assert.assertTrue('every member of output chromosomes is an IChromosome', possibleChromosome is IChromosome);
			}
		}
		
		[Test]
		public function testGenerateChromosomesNullSource():void {
			source = null;
			externalSourceSeedingStrategy.chromosomeSource = source;
			numChromosomes = 3;
			var outputChromosomes:Array = externalSourceSeedingStrategy.generateChromosomes(numChromosomes);
			Assert.assertNotNull('output chromosomes array is non-null even when source is null', outputChromosomes);
			Assert.assertStrictlyEquals('output chromosomes array has 0 members when the source property is null', 0, outputChromosomes.length);
		}
		
		[Test]
		public function testGenerateChromosomesEmptySource():void {
			source = [];
			externalSourceSeedingStrategy.chromosomeSource = source;
			numChromosomes = 3;
			var outputChromosomes:Array = externalSourceSeedingStrategy.generateChromosomes(numChromosomes);
			Assert.assertNotNull('output chromosomes array is non-null even when source is empty', outputChromosomes);
			Assert.assertStrictlyEquals('output chromosomes array has 0 members when the source property is empty', 0, outputChromosomes.length);
		}
	}
}