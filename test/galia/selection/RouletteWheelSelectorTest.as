package galia.selection
{
	import flexunit.framework.Assert;
	
	import galia.base.Population;
	import galia.base.Specimen;
	import galia.core.IPopulation;
	import galia.core.ISpecimen;
	
	public class RouletteWheelSelectorTest
	{
		public static const DEFAULT_SEED:uint = 1;
		
		private var selector:RouletteWheelSelector;
		
		// Expect the default seed to cause Rndm to produce the following values: 0.000007826602259425612, 0.13153778837616625, 0.7556053224280331, 0.4586501321564493
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
			
			selector = new RouletteWheelSelector();
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
		public function testSelectSurvivorsSimple():void
		{
			specimenA.fitness = 0; // Corresponds to accumulated normalized fitness of 0
			specimenB.fitness = 1; // Corresponds to accumulated normalized fitness of 1/6.0
			specimenC.fitness = 2; // Corresponds to accumulated normalized fitness of 3/6.0
			specimenD.fitness = 3; // Corresponds to accumulated normalized fitness of 6/6.0
			population.specimens = [specimenA, specimenB, specimenC, specimenD];
			selector.numberOfSelections = 3;
			
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertTrue('Proper number of selections made', selections.length == 3);
			// Since we expect default seed to cause Rndm to produce the following values: 0.000007826602259425612, 0.13153778837616625, 0.7556053224280331, 0.4586501321564493,
			// the corresponding first accumulated normalized fitnesses that would be found are specimenB, specimenB, specimenD, and specimenB again
			Assert.assertTrue('First selection is B', selections[0] == specimenB);
			Assert.assertTrue('Second selection is also specimenB', selections[1] == specimenB);
			Assert.assertTrue('Third selection is specimenD', selections[2] == specimenD);
		}
		
		[Test]
		public function testSelectSurvivorsSimpleDisordered():void
		{
			specimenA.fitness = 0; // Corresponds to accumulated normalized fitness of 0
			specimenB.fitness = 1; // Corresponds to accumulated normalized fitness of 1/6.0
			specimenC.fitness = 2; // Corresponds to accumulated normalized fitness of 3/6.0
			specimenD.fitness = 3; // Corresponds to accumulated normalized fitness of 6/6.0
			population.specimens = [specimenD, specimenA, specimenC, specimenB];
			selector.numberOfSelections = 3;
			
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertTrue('Proper number of selections made', selections.length == 3);
			// Since we expect default seed to cause Rndm to produce the following values: 0.000007826602259425612, 0.13153778837616625, 0.7556053224280331, 0.4586501321564493,
			// the corresponding first accumulated normalized fitnesses that would be found are specimenB, specimenB, specimenD, and specimenB again
			Assert.assertTrue('First selection is B', selections[0] == specimenB);
			Assert.assertTrue('Second selection is also specimenB', selections[1] == specimenB);
			Assert.assertTrue('Third selection is specimenD', selections[2] == specimenD);
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
	}
}