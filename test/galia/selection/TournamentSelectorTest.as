package galia.selection
{
	import flexunit.framework.Assert;
	
	import galia.base.Population;
	import galia.base.Specimen;
	import galia.core.IPopulation;
	import galia.core.ISpecimen;
	
	public class TournamentSelectorTest
	{		
		public static const DEFAULT_SEED:uint = 2;
		
		private var selector:TournamentSelector;
		
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
			
			selector = new TournamentSelector();
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
		public function testSelectSurvivorsSingleSpecimenTournamentSizeTwo():void {
			population.specimens = [specimenA];
			selector.numberOfSelections = 1;
			selector.tournamentSize = 2;
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length of 1', selections.length == 1);
		}
		
		[Test]
		public function testSelectSurvivorsSingleSpecimenSourceTournamentSizeTwoPick5():void {
			population.specimens = [specimenA];
			selector.numberOfSelections = 5;
			selector.tournamentSize = 2;
			var selections:Array = selector.selectSurvivors(population);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 5);
			for each (var specimen:ISpecimen in selections) {
				Assert.assertTrue('All selections should be strictly equal to the only available source specimen', specimen === specimenA);
			}
		}
		
		[Test]
		public function testSelectSurvivorsDeterministic():void {
			specimenA.fitness = 0;
			specimenB.fitness = 1;
			specimenC.fitness = 2;
			specimenD.fitness = 3;
			population.specimens = [specimenA, specimenB, specimenC, specimenD];
			
			
			selector.numberOfSelections = 1;
			selector.tournamentSize = 2;
			selector.bestSelectionProbability = 1.0; 
			var selections:Array = selector.selectSurvivors(population);
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 1);
			// For the DEFAULT_SEED of 2, we expect the first tournament to select specimens from indices 0 and 1, meaning specimens A and B
			// Next, the expected split point for selection between tournament members is 0.5112106446230664
			// Since the bestSelectionProbability is 1.0, we expect the best of these two options, specimenB to be selected
			Assert.assertTrue('Seed is the same as the one used for the initial testing observations', selector.seed == 2);
			Assert.assertTrue('Selected specimen is best of single tournament', selections[0] == specimenB); 
		}
		
		[Test]
		public function testSelectSurvivorsLowP():void {
			specimenA.fitness = 0;
			specimenB.fitness = 1;
			specimenC.fitness = 2;
			specimenD.fitness = 3;
			population.specimens = [specimenA, specimenB, specimenC, specimenD];
			
			
			selector.numberOfSelections = 1;
			selector.tournamentSize = 2;
			selector.bestSelectionProbability = 0.25; 
			var selections:Array = selector.selectSurvivors(population);
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 1);
			// For the DEFAULT_SEED of 2, we expect the first tournament to select specimens from indices 0 and 1, meaning specimens A and B
			// Next, the expected split point for selection between tournament members is 0.5112106446230664
			// Since the bestSelectionProbability is 0.25, we expect the WORST of these two options, specimenA to be selected
			Assert.assertTrue('Seed is the same as the one used for the initial testing observations', selector.seed == 2);
			Assert.assertTrue('Selected specimen is worst of single tournament', selections[0] == specimenA); 
		}
		
		[Test]
		public function testSelectSurvivorsMultipleTournaments():void {
			specimenA.fitness = 0;
			specimenB.fitness = 1;
			specimenC.fitness = 2;
			specimenD.fitness = 3;
			population.specimens = [specimenA, specimenB, specimenC, specimenD];
			
			selector.numberOfSelections = 2;
			selector.tournamentSize = 2;
			selector.bestSelectionProbability = 0.75; 
			var selections:Array = selector.selectSurvivors(population);
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 2);
			// For the DEFAULT_SEED of 2, we expect the first tournament to select specimens from indices 0 and 1, meaning specimens A and B
			// Next, the expected split point for selection between tournament members is 0.5112106446230664
			// Since the bestSelectionProbability is 0.75 we expect the best of these two options, specimenB to be selected
			Assert.assertTrue('Seed is the same as the one used for the initial testing observations', selector.seed == 2);
			Assert.assertTrue('Selected specimen is best of first tournament', selections[0] == specimenB);
			// We then expect the second tournament to be between specimens from indices 3 and 0, meaning specimens D and A
			// with a split point of 0.43791837288918073.
			// Since the bestSelectionProbability is 0.75, we expect the best of these two options, specimenD, to be selected
			Assert.assertTrue('Second specimen is best of second tournament', selections[1] == specimenD);
		}
		
		[Test]
		public function testSelectSurvivorsThreeWayTournament():void {
			specimenA.fitness = 0;
			specimenB.fitness = 1;
			specimenC.fitness = 2;
			specimenD.fitness = 3;
			population.specimens = [specimenA, specimenB, specimenC, specimenD];
			
			selector.numberOfSelections = 1;
			selector.tournamentSize = 3;
			selector.bestSelectionProbability = 0.75; 
			var selections:Array = selector.selectSurvivors(population);
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 1);
			// For the DEFAULT_SEED of 2, we expect the first tournament to select specimens from indices 0,1, and 2 meaning specimens A and B and C
			// Next, the expected split point for selection between tournament members is 0.9173002640798985.
			// Since the bestSelectionProbability is 0.75 we expect the second best of these three options, specimenB to be selected
			Assert.assertTrue('Seed is the same as the one used for the initial testing observations', selector.seed == 2);
			Assert.assertTrue('Selected specimen is the second best of first tournament', selections[0] == specimenB);
		}
	}
}