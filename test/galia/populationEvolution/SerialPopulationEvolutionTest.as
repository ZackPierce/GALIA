package galia.populationEvolution
{
	import flexunit.framework.Assert;
	
	import galia.base.Specimen;
	import galia.populationEvolution.supportClasses.InspectablePopulationEvolutionOperator;
	
	public class SerialPopulationEvolutionTest
	{
		private var serialPopulationEvolution:SerialPopulationEvolution;
		private var inputSpecimens:Array;
		private var targetPopulationSize:uint = 0;
		
		private var populationEvolutionOperatorA:InspectablePopulationEvolutionOperator;
		private var populationEvolutionOperatorB:InspectablePopulationEvolutionOperator;
		
		[Before]
		public function setUp():void
		{
			populationEvolutionOperatorA = new InspectablePopulationEvolutionOperator();
			populationEvolutionOperatorB = new InspectablePopulationEvolutionOperator();
			serialPopulationEvolution = new SerialPopulationEvolution([populationEvolutionOperatorA, populationEvolutionOperatorB]);
			targetPopulationSize = 0;
		}
		
		[After]
		public function tearDown():void
		{
			serialPopulationEvolution = null;
			inputSpecimens = null;
			populationEvolutionOperatorA = null;
			populationEvolutionOperatorB = null
			targetPopulationSize = 0;
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
		public function testEvolvePopulationNullSpecimens():void {
			inputSpecimens = null;
			targetPopulationSize = 3;
			var outputPopulation:Array = serialPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null even if the input specimen array is null', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should be zero if the input specimen array is null', 0, outputPopulation.length);
		}
		
		[Test]
		public function testEvolvePopulationEmptySpecimens():void {
			inputSpecimens = [];
			targetPopulationSize = 3;
			var outputPopulation:Array = serialPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null even if the input specimen array is empty', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should be zero if the input specimen array is null', 0, outputPopulation.length);
		}
		
		[Test]
		public function testEvolvePopulationSameTargetSizeAsInputSpecimens():void
		{
			targetPopulationSize = 3;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = serialPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length); 
		}
		
		[Test]
		public function testEvolvePopulationHigherTargetSizeThanInputSpecimens():void
		{
			targetPopulationSize = 5;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = serialPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length); 
		}
		
		[Test]
		public function testEvolvePopulationLowerTargetSizeThanInputSpecimens():void
		{
			targetPopulationSize = 1;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var outputSpecimens:Array = serialPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length); 
		}
		
		[Test]
		public function testEvolvePopulationOrder():void
		{
			targetPopulationSize = 1;
			inputSpecimens = [new Specimen(), new Specimen(), new Specimen()];
			var operators:Array = [populationEvolutionOperatorA, populationEvolutionOperatorB];
			serialPopulationEvolution.populationEvolutionOperators = operators;
			var outputSpecimens:Array = serialPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output specimens array should not be null', outputSpecimens);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputSpecimens.length);
			for (var i:int = 0; i < operators.length; i++) {
				var currentOperator:InspectablePopulationEvolutionOperator = operators[i];
				Assert.assertTrue('Every IPopulationEvolutionOperator had its evolvePopulation function called', currentOperator.evolvePopulationRun);
				if (i < operators.length - 1) {
					var nextOperator:InspectablePopulationEvolutionOperator = operators[i + 1];
					var currRunTime:uint = currentOperator.lastEvolvePopulationExecution;
					var nextRunTime:uint = nextOperator.lastEvolvePopulationExecution;
					Assert.assertTrue("The operators' evolvePopulation methods were called in the order of their position in the populationEvolutionOperators array", currentOperator.lastEvolvePopulationExecution <= nextOperator.lastEvolvePopulationExecution);
				}
			}
		}
		
		[Test]
		public function testSet_populationEvolutionOperatorsNull():void
		{
			serialPopulationEvolution.populationEvolutionOperators = null;
			Assert.assertNotNull("Attempting to set the populationEvolutionOperators to null results in a NON-null property", serialPopulationEvolution.populationEvolutionOperators);
			Assert.assertStrictlyEquals("Attempting to set the populationEvolutionOperators to null results in an empty populationEvolutionOperators array", 0, serialPopulationEvolution.populationEvolutionOperators.length);
		}
	}
}