package galia.populationEvolution
{
	import flexunit.framework.Assert;
	
	import galia.base.Specimen;
	import galia.core.IProcreationOperator;
	import galia.populationEvolution.supportClasses.TrivialChromosome;
	import galia.populationEvolution.supportClasses.TrivialChromosomeProcreationOperator;
	
	public class PopulationEvolutionByProcreationTest
	{
		private var populationEvolutionByProcreation:PopulationEvolutionByProcreation;
		private var chromosomeProcreationOperator:IProcreationOperator;
		private var inputSpecimens:Array;
		private var targetPopulationSize:uint = 0;
		
		[Before]
		public function setUp():void {
			populationEvolutionByProcreation = new PopulationEvolutionByProcreation();
			chromosomeProcreationOperator = new TrivialChromosomeProcreationOperator();
			populationEvolutionByProcreation.chromosomeProcreationOperator = chromosomeProcreationOperator;
			inputSpecimens = [];
			for (var i:int = 0; i < 5; i++) {
				var specimen:Specimen = new Specimen();
				specimen.chromosome = new TrivialChromosome();
				inputSpecimens.push(specimen);
			}
		}
		
		[After]
		public function tearDown():void {
			populationEvolutionByProcreation = null;
			chromosomeProcreationOperator = null;
			inputSpecimens = null;
			targetPopulationSize = 0;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void {
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void {
		}
		
		[Test]
		public function testEvolvePopulationNullSpecimensNoParentsRequired():void {
			inputSpecimens = null;
			targetPopulationSize = 3;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 0;
			var outputPopulation:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null even if the input specimen array is null', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputPopulation.length);
		}
		
		[Test]
		public function testEvolvePopulationEmptySpecimensNoParentsRequired():void {
			inputSpecimens = [];
			targetPopulationSize = 3;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 0;
			var outputPopulation:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null even if the input specimen array is empty', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputPopulation.length);
		}
		
		[Test]
		public function testEvolvePopulationSameTargetSizeAsInputSpecimensNoParentsRequired():void {
			targetPopulationSize = 3;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 0;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length); 
		}
		
		[Test]
		public function testEvolvePopulationHigherTargetSizeThanInputSpecimensNoParentsRequired():void {
			targetPopulationSize = 5;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 0;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length); 
		}
		
		[Test]
		public function testEvolvePopulationLowerTargetSizeThanInputSpecimensNoParentsRequired():void {
			targetPopulationSize = 1;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 0;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length); 
		}
		
		[Test]
		public function testEvolvePopulationNoParentsRequired():void {
			targetPopulationSize = 5;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 0;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length);
			Assert.assertTrue('Procreation operator should be executed', (populationEvolutionByProcreation.chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).procreationExecuted);
		}
		
		[Test]
		public function testEvolvePopulationNullSpecimensOneParentRequired():void {
			inputSpecimens = null;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 1;
			targetPopulationSize = 3;
			var outputPopulation:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null even if the input specimen array is null', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputPopulation.length);
		}
		
		[Test]
		public function testEvolvePopulationEmptySpecimensOneParentRequired():void {
			inputSpecimens = [];
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 1;
			targetPopulationSize = 3;
			var outputPopulation:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null even if the input specimen array is empty', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputPopulation.length);
		}
		
		[Test]
		public function testEvolvePopulationSameTargetSizeAsInputSpecimensOneParentRequired():void {
			targetPopulationSize = 3;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 1;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length); 
		}
		
		[Test]
		public function testEvolvePopulationHigherTargetSizeThanInputSpecimensOneParentRequired():void {
			targetPopulationSize = 5;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 1;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length); 
		}
		
		[Test]
		public function testEvolvePopulationLowerTargetSizeThanInputSpecimensOneParentRequired():void {
			targetPopulationSize = 1;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 1;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length); 
		}
		
		[Test]
		public function testEvolvePopulationOneParentRequired():void {
			targetPopulationSize = 5;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 1;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length);
			Assert.assertTrue('Procreation operator should be executed', (populationEvolutionByProcreation.chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).procreationExecuted);
		}
		
		[Test]
		public function testEvolvePopulationNullSpecimensMultipleParentsRequired():void {
			inputSpecimens = null;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 3;
			targetPopulationSize = 3;
			var outputPopulation:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null even if the input specimen array is null', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputPopulation.length);
		}
		
		[Test]
		public function testEvolvePopulationEmptySpecimensMultipleParentsRequired():void {
			inputSpecimens = [];
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 3;
			targetPopulationSize = 3;
			var outputPopulation:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null even if the input specimen array is empty', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputPopulation.length);
		}
		
		[Test]
		public function testEvolvePopulationSameTargetSizeAsInputSpecimensMultipleParentsRequired():void {
			targetPopulationSize = 3;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 3;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length); 
		}
		
		[Test]
		public function testEvolvePopulationHigherTargetSizeThanInputSpecimensMultipleParentsRequired():void {
			targetPopulationSize = 5;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 3;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length); 
		}
		
		[Test]
		public function testEvolvePopulationLowerTargetSizeThanInputSpecimensMultipleParentsRequired():void {
			targetPopulationSize = 1;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 3;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length); 
		}
		
		[Test]
		public function testEvolvePopulationMultipleParentsRequired():void {
			targetPopulationSize = 5;
			(chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).numberOfParentsRequired = 3;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = populationEvolutionByProcreation.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length);
			Assert.assertTrue('Procreation operator should be executed', (populationEvolutionByProcreation.chromosomeProcreationOperator as TrivialChromosomeProcreationOperator).procreationExecuted);
		}
	}
}