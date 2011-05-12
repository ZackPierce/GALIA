package galia.selection
{
	import flexunit.framework.Assert;
	
	import galia.base.Population;
	import galia.base.Specimen;
	import galia.core.IPopulation;
	import galia.core.ISpecimen;
	
	public class StochasticUniversalSamplingSelectorTest
	{		
		public static const DEFAULT_SEED:uint = 2;
		
		private var selector:StochasticUniversalSamplingSelector;
		
		private var seed:uint = DEFAULT_SEED;
		private var population:IPopulation;
		
		private var specimenA:ISpecimen;
		private var specimenB:ISpecimen;
		private var specimenC:ISpecimen;
		private var specimenD:ISpecimen;
		private var specimenE:ISpecimen;
		private var specimenF:ISpecimen;
		private var specimenG:ISpecimen;
		
		[Before]
		public function setUp():void
		{
			
			selector = new StochasticUniversalSamplingSelector();
			seed = DEFAULT_SEED;
			selector.seed = seed;
			population = new Population();
			specimenA = new Specimen();
			specimenB = new Specimen();
			specimenC = new Specimen();
			specimenD = new Specimen();
			specimenE = new Specimen();
			specimenF = new Specimen();
			specimenG = new Specimen();
		}
		
		[After]
		public function tearDown():void
		{
			selector = null;
			seed = DEFAULT_SEED;
			population = null;
			specimenA = null;
			specimenB = null;
			specimenC = null;
			specimenD = null;
			specimenE = null;
			specimenF = null;
			specimenG = null;
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
		public function testSelectSurvivorsNullPopulation():void {
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(null);
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length of 0', selections.length == 0);
		}
		
		[Test]
		public function testSelectSurvivorsNullSpecimens():void {
			population.specimens = null;
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length of 0', selections.length == 0);
		}
		
		[Test]
		public function testSelectSurvivorsEmptySpecimens():void {
			population.specimens = [];
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length of 0', selections.length == 0);
		}
		
		[Test]
		public function testSelectZeroSurvivors():void
		{
			population.specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 0;
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length of 0', selections.length == 0);
		}
		
		[Test]
		public function testSelectOneSurvivorOneSpecimen():void
		{
			specimenA.fitness = 1;
			population.specimens = [specimenA];
			selector.numberOfSelections = 1;
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 1);
			Assert.assertTrue('Selections should contain the only available specimen', selections[0] == specimenA);
		}
		
		[Test]
		public function testSelectThreeSurvivorsOnePossibleSpecimen():void
		{
			specimenA.fitness = 1;
			population.specimens = [specimenA];
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 3);
			Assert.assertTrue('First selection should be the only available specimen', selections[0] == specimenA);
			Assert.assertTrue('Second selection should be the only available specimen', selections[1] == specimenA);
			Assert.assertTrue('Third selection should be the only available specimen', selections[2] == specimenA);
		}
		
		[Test]
		public function testSelectThreeSurvivorsThreePossibleSpecimens():void
		{
			specimenA.fitness = 1;
			specimenB.fitness = 1;
			specimenC.fitness = 1;
			population.specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 3);
			Assert.assertTrue('First selection should match the first available specimen', selections[0] == specimenA);
			Assert.assertTrue('Second selection should be the second available specimen', selections[1] == specimenB);
			Assert.assertTrue('Third selection should be the third available specimen', selections[2] == specimenC);
		}
		
		[Test]
		public function testSelectThreeSurvivorThreePossibleSpecimensDominantSpecimen():void
		{
			specimenA.fitness = 0;
			specimenB.fitness = 0;
			specimenC.fitness = 1;
			population.specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 3);
			Assert.assertTrue('First selection should match the dominant specimen', selections[0] == specimenC);
			Assert.assertTrue('Second selection should match the dominant specimen', selections[1] == specimenC);
			Assert.assertTrue('Third selection should match the dominant specimen', selections[2] == specimenC);
		}
		
		[Test]
		public function testSelectTwoSurvivorsThreePossibleSpecimensUnevenFitnesses():void
		{
			specimenA.fitness = 1;
			specimenB.fitness = 2;
			specimenC.fitness = 2.5;
			population.specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 2;
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 2);
			// Assuming that the DEFAULT_SEED is 2, the split point comes out to ~7E-6, a very low value, causing the 
			// evenly-placed pointers to entirely miss the third-ranked bin
			Assert.assertTrue('First selection should match the best specimen', selections[0] == specimenC);
			Assert.assertTrue('Second selection should match the second-best specimen', selections[1] == specimenB);
		}
		
		[Test]
		public function testSelectOneSurvivorOneSpecimenZeroFitness():void
		{
			specimenA.fitness = 0;
			population.specimens = [specimenA];
			selector.numberOfSelections = 1;
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 1);
			Assert.assertTrue('Selections should contain the only available specimen', selections[0] == specimenA);
		}
		
		[Test]
		public function testSelectThreeSurvivorsOnePossibleSpecimenZeroFitness():void
		{
			specimenA.fitness = 0;
			population.specimens = [specimenA];
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 3);
			Assert.assertTrue('First selection should be the only available specimen', selections[0] == specimenA);
			Assert.assertTrue('Second selection should be the only available specimen', selections[1] == specimenA);
			Assert.assertTrue('Third selection should be the only available specimen', selections[2] == specimenA);
		}
		
		[Test]
		public function testSelectThreeSurvivorsThreePossibleSpecimensZeroFitness():void
		{
			specimenA.fitness = 0;
			specimenB.fitness = 0;
			specimenC.fitness = 0;
			population.specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 3);
			Assert.assertTrue('First selection should match the first available specimen', selections[0] == specimenA);
			Assert.assertTrue('Second selection should be the second available specimen', selections[1] == specimenB);
			Assert.assertTrue('Third selection should be the third available specimen', selections[2] == specimenC);
		}
	}
}