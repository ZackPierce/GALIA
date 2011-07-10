package galia.selection
{
	import flexunit.framework.Assert;
	
	import galia.base.Specimen;
	import galia.core.ISpecimen;
	import galia.math.ParkMillerRandomNumberGenerator;
	
	public class StochasticUniversalSamplingSelectorTest extends SelectorTest
	{
		
		[Before]
		override public function setUp():void {
			super.setUp();
			selector = new StochasticUniversalSamplingSelector();
			(selector as StochasticUniversalSamplingSelector).randomNumberGenerator = new ParkMillerRandomNumberGenerator(2);
		}
		
		[After]
		override public function tearDown():void {
			super.tearDown();
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void {
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void {
		}
		
		[Test]
		public function testSelectThreeSurvivorsThreePossibleSpecimens():void {
			specimenA.fitness = 1;
			specimenB.fitness = 1;
			specimenC.fitness = 1;
			specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 3);
			Assert.assertTrue('First selection should match the first available specimen', selections[0] == specimenA);
			Assert.assertTrue('Second selection should be the second available specimen', selections[1] == specimenB);
			Assert.assertTrue('Third selection should be the third available specimen', selections[2] == specimenC);
		}
		
		[Test]
		public function testSelectThreeSurvivorThreePossibleSpecimensDominantSpecimen():void {
			specimenA.fitness = 0;
			specimenB.fitness = 0;
			specimenC.fitness = 1;
			specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 3);
			Assert.assertTrue('First selection should match the dominant specimen', selections[0] == specimenC);
			Assert.assertTrue('Second selection should match the dominant specimen', selections[1] == specimenC);
			Assert.assertTrue('Third selection should match the dominant specimen', selections[2] == specimenC);
		}
		
		[Test]
		public function testSelectTwoSurvivorsThreePossibleSpecimensUnevenFitnesses():void {
			specimenA.fitness = 1;
			specimenB.fitness = 2;
			specimenC.fitness = 2.5;
			specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 2;
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 2);
			// Assuming that the DEFAULT_SEED is 2, the split point comes out to ~7E-6, a very low value, causing the 
			// evenly-placed pointers to entirely miss the third-ranked bin
			Assert.assertTrue('First selection should match the best specimen', selections[0] == specimenC);
			Assert.assertTrue('Second selection should match the second-best specimen', selections[1] == specimenB);
		}
		
		[Test]
		public function testSelectThreeSurvivorsThreePossibleSpecimensZeroFitness():void {
			specimenA.fitness = 0;
			specimenB.fitness = 0;
			specimenC.fitness = 0;
			specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 3);
			Assert.assertTrue('First selection should match the first available specimen', selections[0] == specimenA);
			Assert.assertTrue('Second selection should be the second available specimen', selections[1] == specimenB);
			Assert.assertTrue('Third selection should be the third available specimen', selections[2] == specimenC);
		}
	}
}