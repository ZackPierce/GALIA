package galia.populationEvolution
{
	import flexunit.framework.Assert;
	
	import galia.base.Specimen;
	import galia.core.ISpecimen;
	import galia.populationEvolution.supportClasses.InspectablePopulationEvolutionOperator;
	
	public class SplitPopulationEvolutionTest
	{
		private var splitPopulationEvolution:SplitPopulationEvolution;
		private var inputSpecimens:Array;
		private var targetPopulationSize:uint = 0;
		
		private const EVOLVER_A:String = 'A';
		private const EVOLVER_B:String = 'B';
		private const EVOLVER_C:String = 'C';
		
		private var populationEvolutionOperatorA:InspectablePopulationEvolutionOperator;
		private var populationEvolutionOperatorB:InspectablePopulationEvolutionOperator;
		private var populationEvolutionOperatorC:InspectablePopulationEvolutionOperator;
		
		[Before]
		public function setUp():void {
			populationEvolutionOperatorA = new InspectablePopulationEvolutionOperator(EVOLVER_A);
			populationEvolutionOperatorB = new InspectablePopulationEvolutionOperator(EVOLVER_B);
			populationEvolutionOperatorC = new InspectablePopulationEvolutionOperator(EVOLVER_C);
			targetPopulationSize = 0;
			splitPopulationEvolution = new SplitPopulationEvolution();
		}
		
		[After]
		public function tearDown():void {
			populationEvolutionOperatorA = null;
			populationEvolutionOperatorB = null;
			populationEvolutionOperatorC = null;
			targetPopulationSize = 0;
			splitPopulationEvolution = null;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void {
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void {
		}
		
		private function generateTrivialSpecimens(numSpecimens:uint):Array {
			var specimens:Array = [];
			for (var i:int = 0; i < numSpecimens; i++) {
				specimens.push(new Specimen());
			}
			return specimens;
		}
		
		private function countNumberOfSpecimensCountainingPrefixInId(specimens:Array, targetPrefix:String):uint {
			if (!specimens || specimens.length == 0) {
				return 0;
			}
			var count:uint = 0;
			for each (var specimen:ISpecimen in specimens) {
				if (specimen.id && specimen.id.indexOf(targetPrefix) == 0) {
					count++;
				}
			}
			return count;
		}
		
		[Test]
		public function testEvolvePopulationNullSpecimens():void {
			splitPopulationEvolution.setPopulationEvolutionOperatorsAndWeights([populationEvolutionOperatorA, populationEvolutionOperatorB, populationEvolutionOperatorC]);
			inputSpecimens = null;
			targetPopulationSize = 3;
			var outputPopulation:Array = splitPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null even if the input specimen array is null', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should be zero if the input specimen array is null', 0, outputPopulation.length);
		}
		
		[Test]
		public function testEvolvePopulationEmptySpecimens():void {
			splitPopulationEvolution.setPopulationEvolutionOperatorsAndWeights([populationEvolutionOperatorA, populationEvolutionOperatorB, populationEvolutionOperatorC]);
			inputSpecimens = [];
			targetPopulationSize = 3;
			var outputPopulation:Array = splitPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null even if the input specimen array is empty', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should be zero if the input specimen array is empty', 0, outputPopulation.length);
		}
		
		[Test]
		public function testEvolvePopulationNullOperators():void {
			splitPopulationEvolution.setPopulationEvolutionOperatorsAndWeights(null);
			targetPopulationSize = 3;
			inputSpecimens = generateTrivialSpecimens(targetPopulationSize);
			
			var outputPopulation:Array = splitPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null even if the input operator array is null', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputPopulation.length);
		}
		
		[Test]
		public function testEvolvePopulationEmptyOperators():void {
			splitPopulationEvolution.setPopulationEvolutionOperatorsAndWeights([]);
			targetPopulationSize = 3;
			inputSpecimens = generateTrivialSpecimens(targetPopulationSize);
			
			var outputPopulation:Array = splitPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null even if the input operator array is empty', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputPopulation.length);
		}
		
		[Test]
		public function testEvolvePopulationEvenlySplit():void {
			splitPopulationEvolution.setPopulationEvolutionOperatorsAndWeights([populationEvolutionOperatorA, populationEvolutionOperatorB, populationEvolutionOperatorC],
				[2, 2, 2]);
			targetPopulationSize = 6;
			inputSpecimens = generateTrivialSpecimens(targetPopulationSize);
			
			var outputPopulation:Array = splitPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputPopulation.length);
			var specimensProducedByA:uint = countNumberOfSpecimensCountainingPrefixInId(outputPopulation, EVOLVER_A);
			var specimensProducedByB:uint = countNumberOfSpecimensCountainingPrefixInId(outputPopulation, EVOLVER_B);
			var specimensProducedByC:uint = countNumberOfSpecimensCountainingPrefixInId(outputPopulation, EVOLVER_C);
			Assert.assertStrictlyEquals('If the weights are all equal and the number of specimens is evenly divisible, the number of specimens produced by operator A should equal those produced by operator B', specimensProducedByA, specimensProducedByB);
			Assert.assertStrictlyEquals('If the weights are all equal and the number of specimens is evenly divisible, the number of specimens produced by operator B should equal those produced by operator C', specimensProducedByB, specimensProducedByC);
		}
		
		[Test]
		public function testEvolvePopulationUnevenlySplit():void {
			splitPopulationEvolution.setPopulationEvolutionOperatorsAndWeights([populationEvolutionOperatorA, populationEvolutionOperatorB, populationEvolutionOperatorC],
				[3, 2, 1]);
			targetPopulationSize = 6;
			inputSpecimens = generateTrivialSpecimens(targetPopulationSize);
			
			var outputPopulation:Array = splitPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputPopulation.length);
			var specimensProducedByA:uint = countNumberOfSpecimensCountainingPrefixInId(outputPopulation, EVOLVER_A);
			var specimensProducedByB:uint = countNumberOfSpecimensCountainingPrefixInId(outputPopulation, EVOLVER_B);
			var specimensProducedByC:uint = countNumberOfSpecimensCountainingPrefixInId(outputPopulation, EVOLVER_C);
			Assert.assertStrictlyEquals('If number of input specimens is evenly divisible by all weights, the number of specimens produced by operator A should be a multiple of its weight', 3, specimensProducedByA);
			Assert.assertStrictlyEquals('If number of input specimens is evenly divisible by all weights, the number of specimens produced by operator A should be a multiple of its weight', 2, specimensProducedByB);
			Assert.assertStrictlyEquals('If number of input specimens is evenly divisible by all weights, the number of specimens produced by operator A should be a multiple of its weight', 1, specimensProducedByC);
		}
		
		[Test]
		public function testEvolvePopulationNoWeights():void {
			splitPopulationEvolution.setPopulationEvolutionOperatorsAndWeights([populationEvolutionOperatorA, populationEvolutionOperatorB, populationEvolutionOperatorC],
				null);
			targetPopulationSize = 6;
			inputSpecimens = generateTrivialSpecimens(targetPopulationSize);
			
			var outputPopulation:Array = splitPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputPopulation.length);
			var specimensProducedByA:uint = countNumberOfSpecimensCountainingPrefixInId(outputPopulation, EVOLVER_A);
			var specimensProducedByB:uint = countNumberOfSpecimensCountainingPrefixInId(outputPopulation, EVOLVER_B);
			var specimensProducedByC:uint = countNumberOfSpecimensCountainingPrefixInId(outputPopulation, EVOLVER_C);
			Assert.assertStrictlyEquals('If the weights are not provided and the number of specimens is evenly divisible, the number of specimens produced by operator A should equal those produced by operator B', specimensProducedByA, specimensProducedByB);
			Assert.assertStrictlyEquals('If the weights are not provided and the number of specimens is evenly divisible, the number of specimens produced by operator B should equal those produced by operator C', specimensProducedByB, specimensProducedByC);
		}
		
		[Test]
		public function testEvolvePopulationPartialWeights():void {
			splitPopulationEvolution.setPopulationEvolutionOperatorsAndWeights([populationEvolutionOperatorA, populationEvolutionOperatorB, populationEvolutionOperatorC],
				[(1.0/3.0), (1.0/3.0)]);
			targetPopulationSize = 6;
			inputSpecimens = generateTrivialSpecimens(targetPopulationSize);
			
			var outputPopulation:Array = splitPopulationEvolution.evolvePopulation(inputSpecimens, targetPopulationSize);
			Assert.assertNotNull('Output population should not be null', outputPopulation);
			Assert.assertStrictlyEquals('Number of output specimens should match the target population size', targetPopulationSize, outputPopulation.length);
			var specimensProducedByA:uint = countNumberOfSpecimensCountainingPrefixInId(outputPopulation, EVOLVER_A);
			var specimensProducedByB:uint = countNumberOfSpecimensCountainingPrefixInId(outputPopulation, EVOLVER_B);
			var specimensProducedByC:uint = countNumberOfSpecimensCountainingPrefixInId(outputPopulation, EVOLVER_C);
			Assert.assertStrictlyEquals('AB The raw weight of operators with no provided weight should be treated as 1.0/numberOfOperators', specimensProducedByA, specimensProducedByB);
			Assert.assertStrictlyEquals('BC The raw weight of operators with no provided weight should be treated as 1.0/numberOfOperators', specimensProducedByB, specimensProducedByC);
		}
	}
}