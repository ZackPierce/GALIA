package galia.selection
{
	import flexunit.framework.Assert;
	
	import galia.base.Specimen;
	import galia.core.ISpecimen;

	public class SelectionUtilTest
	{
		private var specimens:Array;
		
		private var specimenA:ISpecimen;
		private var specimenB:ISpecimen;
		private var specimenC:ISpecimen;
		private var specimenD:ISpecimen;
		
		
		[Before]
		public function setUp():void
		{
			specimens = [];
			
			specimenA = new Specimen();
			specimenB = new Specimen();
			specimenC = new Specimen();
			specimenD = new Specimen();
		}
		
		[After]
		public function tearDown():void
		{
			specimens = null;
			
			specimenA = null;
			specimenB = null;
			specimenC = null;
			specimenD = null;
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
		public function sortSpecimensByFitnessPreOrdered():void {
			specimenA.fitness = 0;
			specimenB.fitness = 1;
			specimenC.fitness = 2;
			specimenD.fitness = 3;
			
			specimens = [specimenA, specimenB, specimenC, specimenD];
			
			SelectionUtil.sortSpecimensByFitness(specimens);
			
			Assert.assertTrue('Specimen A is in the right position', specimens.indexOf(specimenA) == 0);
			Assert.assertTrue('Specimen B is in the right position', specimens.indexOf(specimenB) == 1);
			Assert.assertTrue('Specimen C is in the right position', specimens.indexOf(specimenC) == 2);
			Assert.assertTrue('Specimen D is in the right position', specimens.indexOf(specimenD) == 3);
			Assert.assertTrue('Array length has not been altered', specimens.length == 4);
		}
		
		[Test]
		public function sortSpecimensByFitnessReverseOrdered():void {
			specimenA.fitness = 3;
			specimenB.fitness = 2;
			specimenC.fitness = 1;
			specimenD.fitness = 0;
			
			specimens = [specimenA, specimenB, specimenC, specimenD];
			
			SelectionUtil.sortSpecimensByFitness(specimens);
			
			Assert.assertTrue('Specimen A is in the right position', specimens.indexOf(specimenA) == 3);
			Assert.assertTrue('Specimen B is in the right position', specimens.indexOf(specimenB) == 2);
			Assert.assertTrue('Specimen C is in the right position', specimens.indexOf(specimenC) == 1);
			Assert.assertTrue('Specimen D is in the right position', specimens.indexOf(specimenD) == 0);
			Assert.assertTrue('Array length has not been altered', specimens.length == 4);
		}
		
		[Test]
		public function sortSpecimensByFitnessEmptyArray():void {
			
			specimens = [];
			
			SelectionUtil.sortSpecimensByFitness(specimens);
			
			Assert.assertTrue('Array length has not been altered', specimens.length == 0);
		}
		
		[Test]
		public function sortSpecimensByFitnessNullArray():void {
			
			specimens = null;
			
			SelectionUtil.sortSpecimensByFitness(specimens);
			
			Assert.assertNull('Array is still null', specimens);
		}
		
		[Test]
		public function calculateStandardizedAndAdjustedFitnessesFromRawFitnesses():void {
			specimenA.fitness = 0;
			specimenB.fitness = 1;
			specimenC.fitness = 2;
			specimenD.fitness = 30000;
			
			specimens = [specimenA, specimenB, specimenC, specimenD];
			var adjustedFitnessSum:Number = SelectionUtil.calculateStandardizedAndAdjustedFitnessesFromRawFitnesses(specimens);
			
			Assert.assertTrue('Specimen A standardized fitness calculated properly', specimenA.standardizedFitness == Number.MAX_VALUE - 1 - 0);
			Assert.assertTrue('Specimen B standardized fitness calculated properly', specimenB.standardizedFitness == Number.MAX_VALUE - 1 - 1);
			Assert.assertTrue('Specimen C standardized fitness calculated properly', specimenC.standardizedFitness == Number.MAX_VALUE - 1 - 2);
			Assert.assertTrue('Specimen D standardized fitness calculated properly', specimenD.standardizedFitness == Number.MAX_VALUE - 1 - 3);
			
			Assert.assertTrue('Specimen A adjusted fitness calculated properly', specimenA.adjustedFitness == 1.0 / (1 + specimenA.standardizedFitness));
			Assert.assertTrue('Specimen B adjusted fitness calculated properly', specimenB.adjustedFitness == 1.0 / (1 + specimenB.standardizedFitness));
			Assert.assertTrue('Specimen C adjusted fitness calculated properly', specimenC.adjustedFitness == 1.0 / (1 + specimenC.standardizedFitness));
			Assert.assertTrue('Specimen D adjusted fitness calculated properly', specimenD.adjustedFitness == 1.0 / (1 + specimenD.standardizedFitness));
			Assert.assertTrue('Returned adjustedFitnessSum calculated properly', adjustedFitnessSum = specimenA.adjustedFitness + specimenB.adjustedFitness + specimenC.adjustedFitness + specimenD.adjustedFitness);
		}
		
		[Test]
		public function calculateNormalizedAndAccumulatedNormalizedFitnessesFromAdjustedFitnesses():void {
			specimenA.fitness = 0;
			specimenB.fitness = 1;
			specimenC.fitness = 2;
			specimenD.fitness = 3;
			
			specimens = [specimenA, specimenB, specimenC, specimenD];
			var adjustedFitnessSum:Number = SelectionUtil.calculateStandardizedAndAdjustedFitnessesFromRawFitnesses(specimens);
			SelectionUtil.calculateNormalizedAndAccumulatedNormalizedFitnessesFromAdjustedFitnesses(specimens, adjustedFitnessSum);
			
			var normalizedFitnessSum:Number = 0;
			for each (var specimen:ISpecimen in specimens) {
				normalizedFitnessSum += specimen.normalizedFitness;
			}
			Assert.assertTrue('Sum of normalized fitnesses is 1.0', 1.0 == normalizedFitnessSum);
			var lastAccumulatedFitness:Number = (specimens[specimens.length - 1] as ISpecimen).accumulatedNormalizedFitness
			Assert.assertTrue('Final accumulatedNormalizedFitness is 1.0', lastAccumulatedFitness == 1.0);
		}
		
		[Test]
		public function calculateAllDerivedFitnessValues():void {
			specimenA.fitness = 0;
			specimenB.fitness = 1;
			specimenC.fitness = 2;
			specimenD.fitness = 3;
			
			specimens = [specimenA, specimenB, specimenC, specimenD];
			
			SelectionUtil.calculateAllDerivedFitnessValues(specimens);
			
			Assert.assertTrue('Specimen A standardized fitness calculated properly', specimenA.standardizedFitness == Number.MAX_VALUE - 1 - 0);
			Assert.assertTrue('Specimen B standardized fitness calculated properly', specimenB.standardizedFitness == Number.MAX_VALUE - 1 - 1);
			Assert.assertTrue('Specimen C standardized fitness calculated properly', specimenC.standardizedFitness == Number.MAX_VALUE - 1 - 2);
			Assert.assertTrue('Specimen D standardized fitness calculated properly', specimenD.standardizedFitness == Number.MAX_VALUE - 1 - 3);
			
			Assert.assertTrue('Specimen A adjusted fitness calculated properly', specimenA.adjustedFitness == 1.0 / (1 + specimenA.standardizedFitness));
			Assert.assertTrue('Specimen B adjusted fitness calculated properly', specimenB.adjustedFitness == 1.0 / (1 + specimenB.standardizedFitness));
			Assert.assertTrue('Specimen C adjusted fitness calculated properly', specimenC.adjustedFitness == 1.0 / (1 + specimenC.standardizedFitness));
			Assert.assertTrue('Specimen D adjusted fitness calculated properly', specimenD.adjustedFitness == 1.0 / (1 + specimenD.standardizedFitness));
			
			var normalizedFitnessSum:Number = 0;
			for each (var specimen:ISpecimen in specimens) {
				normalizedFitnessSum += specimen.normalizedFitness;
			}
			Assert.assertTrue('Sum of normalized fitnesses is 1.0', 1.0 == normalizedFitnessSum);
			var lastAccumulatedFitness:Number = (specimens[specimens.length - 1] as ISpecimen).accumulatedNormalizedFitness
			Assert.assertTrue('Final accumulatedNormalizedFitness is 1.0', lastAccumulatedFitness == 1.0);
		}
		
	}
}