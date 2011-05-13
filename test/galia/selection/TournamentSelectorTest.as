package galia.selection
{
	import flexunit.framework.Assert;
	
	import galia.base.Specimen;
	import galia.core.ISpecimen;
	
	public class TournamentSelectorTest extends SelectorTest
	{
		
		[Before]
		override public function setUp():void
		{
			super.setUp();
			selector = new TournamentSelector();
			seed = DEFAULT_SEED;
			(selector as TournamentSelector).seed = seed;
		}
		
		[After]
		override public function tearDown():void
		{
			super.tearDown();
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
		public function testSelectSurvivorsSingleSpecimenTournamentSizeTwo():void {
			specimens = [specimenA];
			selector.numberOfSelections = 1;
			(selector as TournamentSelector).tournamentSize = 2;
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length of 1', selections.length == 1);
		}
		
		[Test]
		public function testSelectSurvivorsSingleSpecimenSourceTournamentSizeTwoPick5():void {
			specimens = [specimenA];
			selector.numberOfSelections = 5;
			(selector as TournamentSelector).tournamentSize = 2;
			var selections:Array = selector.selectSurvivors(specimens);
			
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
			specimens = [specimenA, specimenB, specimenC, specimenD];
			
			
			selector.numberOfSelections = 1;
			(selector as TournamentSelector).tournamentSize = 2;
			(selector as TournamentSelector).bestSelectionProbability = 1.0; 
			var selections:Array = selector.selectSurvivors(specimens);
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 1);
			// For the DEFAULT_SEED of 2, we expect the first tournament to select specimens from indices 0 and 1, meaning specimens A and B
			// Next, the expected split point for selection between tournament members is 0.5112106446230664
			// Since the bestSelectionProbability is 1.0, we expect the best of these two options, specimenB to be selected
			Assert.assertTrue('Seed is the same as the one used for the initial testing observations', (selector as TournamentSelector).seed == 2);
			Assert.assertTrue('Selected specimen is best of single tournament', selections[0] == specimenB); 
		}
		
		[Test]
		public function testSelectSurvivorsLowP():void {
			specimenA.fitness = 0;
			specimenB.fitness = 1;
			specimenC.fitness = 2;
			specimenD.fitness = 3;
			specimens = [specimenA, specimenB, specimenC, specimenD];
			
			
			selector.numberOfSelections = 1;
			(selector as TournamentSelector).tournamentSize = 2;
			(selector as TournamentSelector).bestSelectionProbability = 0.25; 
			var selections:Array = selector.selectSurvivors(specimens);
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 1);
			// For the DEFAULT_SEED of 2, we expect the first tournament to select specimens from indices 0 and 1, meaning specimens A and B
			// Next, the expected split point for selection between tournament members is 0.5112106446230664
			// Since the bestSelectionProbability is 0.25, we expect the WORST of these two options, specimenA to be selected
			Assert.assertTrue('Seed is the same as the one used for the initial testing observations', (selector as TournamentSelector).seed == 2);
			Assert.assertTrue('Selected specimen is worst of single tournament', selections[0] == specimenA); 
		}
		
		[Test]
		public function testSelectSurvivorsMultipleTournaments():void {
			specimenA.fitness = 0;
			specimenB.fitness = 1;
			specimenC.fitness = 2;
			specimenD.fitness = 3;
			specimens = [specimenA, specimenB, specimenC, specimenD];
			
			selector.numberOfSelections = 2;
			(selector as TournamentSelector).tournamentSize = 2;
			(selector as TournamentSelector).bestSelectionProbability = 0.75; 
			var selections:Array = selector.selectSurvivors(specimens);
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 2);
			// For the DEFAULT_SEED of 2, we expect the first tournament to select specimens from indices 0 and 1, meaning specimens A and B
			// Next, the expected split point for selection between tournament members is 0.5112106446230664
			// Since the bestSelectionProbability is 0.75 we expect the best of these two options, specimenB to be selected
			Assert.assertTrue('Seed is the same as the one used for the initial testing observations', (selector as TournamentSelector).seed == 2);
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
			specimens = [specimenA, specimenB, specimenC, specimenD];
			
			selector.numberOfSelections = 1;
			(selector as TournamentSelector).tournamentSize = 3;
			(selector as TournamentSelector).bestSelectionProbability = 0.75; 
			var selections:Array = selector.selectSurvivors(specimens);
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 1);
			// For the DEFAULT_SEED of 2, we expect the first tournament to select specimens from indices 0,1, and 2 meaning specimens A and B and C
			// Next, the expected split point for selection between tournament members is 0.9173002640798985.
			// Since the bestSelectionProbability is 0.75 we expect the second best of these three options, specimenB to be selected
			Assert.assertTrue('Seed is the same as the one used for the initial testing observations', (selector as TournamentSelector).seed == 2);
			Assert.assertTrue('Selected specimen is the second best of first tournament', selections[0] == specimenB);
		}
	}
}