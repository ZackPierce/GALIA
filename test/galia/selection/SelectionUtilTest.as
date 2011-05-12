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
		public function sortSpecimensByFitnessDescending():void {
			specimenA.fitness = 0;
			specimenB.fitness = 1;
			specimenC.fitness = 2;
			specimenD.fitness = 3;
			
			specimens = [specimenA, specimenB, specimenC, specimenD];
			
			SelectionUtil.sortSpecimensByFitness(specimens, Array.DESCENDING);
			
			Assert.assertTrue('Specimen A is in the right position', specimens.indexOf(specimenA) == 3);
			Assert.assertTrue('Specimen B is in the right position', specimens.indexOf(specimenB) == 2);
			Assert.assertTrue('Specimen C is in the right position', specimens.indexOf(specimenC) == 1);
			Assert.assertTrue('Specimen D is in the right position', specimens.indexOf(specimenD) == 0);
			Assert.assertTrue('Array length has not been altered', specimens.length == 4);
		}
		
		[Test]
		public function sortSpecimensByFitnessDescendingNonIntegerMix():void {
			specimenA.fitness = 1;
			specimenB.fitness = 2;
			specimenC.fitness = 2.5;
			specimens = [specimenA, specimenB, specimenC];
			SelectionUtil.sortSpecimensByFitness(specimens, Array.DESCENDING);
			Assert.assertTrue('Specimen A is in the right position', specimens.indexOf(specimenA) == 2);
			Assert.assertTrue('Specimen B is in the right position', specimens.indexOf(specimenB) == 1);
			Assert.assertTrue('Specimen C is in the right position', specimens.indexOf(specimenC) == 0);
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
		public function calculateAllDerivedFitnessValues():void {
			specimenA.fitness = 0;
			specimenB.fitness = 1;
			specimenC.fitness = 2;
			specimenD.fitness = 3;
			
			specimens = [specimenA, specimenB, specimenC, specimenD];
			
			SelectionUtil.calculateNormalizedAndAccumulatedNormalizedFitnessesValues(specimens);
			
			Assert.assertTrue('Specimen A normalized fitness calculated properly', specimenA.normalizedFitness == 0.0);
			Assert.assertTrue('Specimen B normalized fitness calculated properly', specimenB.normalizedFitness == 1.0/6.0);
			Assert.assertTrue('Specimen C normalized fitness calculated properly', specimenC.normalizedFitness == 2.0/6.0);
			Assert.assertTrue('Specimen D normalized fitness calculated properly', specimenD.normalizedFitness == 3.0/6.0);
			
			Assert.assertTrue('Specimen A accumulated normalized fitness calculated properly', specimenA.accumulatedNormalizedFitness == 0.0);
			Assert.assertTrue('Specimen B accumulated normalized fitness calculated properly', specimenB.accumulatedNormalizedFitness == 1.0/6.0);
			Assert.assertTrue('Specimen C accumulated normalized fitness calculated properly', specimenC.accumulatedNormalizedFitness == 3.0/6.0);
			Assert.assertTrue('Specimen D accumulated normalized fitness calculated properly', specimenD.accumulatedNormalizedFitness == 1.0);
			
			var normalizedFitnessSum:Number = 0;
			for each (var specimen:ISpecimen in specimens) {
				normalizedFitnessSum += specimen.normalizedFitness;
			}
			Assert.assertTrue('Sum of normalized fitnesses is 1.0', 1.0 == normalizedFitnessSum);
		}
		
	}
}