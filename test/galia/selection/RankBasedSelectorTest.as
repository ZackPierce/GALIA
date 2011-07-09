package galia.selection
{
	import flexunit.framework.Assert;
	
	public class RankBasedSelectorTest extends SelectorTest
	{		
		[Before]
		override public function setUp():void {
			super.setUp();
			selector = new RankBasedSelector();
			(selector as RankBasedSelector).seed = 2; 
		}
		
		[After]
		override public function tearDown():void {
			super.tearDown();
			selector = null;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void {
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void {
		}
		
		[Test]
		public function testSelectSurvivorsOneSurvivorSUS():void {
			Assert.assertTrue('Default delegate helper selector is a StochasticUniversalSamplingSelector', (selector as RankBasedSelector).helperSelector is StochasticUniversalSamplingSelector);
			((selector as RankBasedSelector).helperSelector as StochasticUniversalSamplingSelector).seed = 2;
			specimenA.fitness = 1;
			specimenB.fitness = 2;
			specimenC.fitness = 3;
			specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 1;
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertTrue('Selector seed matches seed used for precalculated assumptions', (selector as RankBasedSelector).seed == 2);
			Assert.assertTrue('Helper selector seed matches seed used for precalculated assumptions', ((selector as RankBasedSelector).helperSelector as StochasticUniversalSamplingSelector).seed == 2);
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 1);
			Assert.assertTrue('Best specimen should be selected', selections[0] == specimenC);
		}
		
		[Test]
		public function testSelectSurvivorsTwoSurvivorsSUS():void {
			Assert.assertTrue('Default delegate helper selector is a StochasticUniversalSamplingSelector', (selector as RankBasedSelector).helperSelector is StochasticUniversalSamplingSelector);
			((selector as RankBasedSelector).helperSelector as StochasticUniversalSamplingSelector).seed = 2;
			specimenA.fitness = 1;
			specimenB.fitness = 2;
			specimenC.fitness = 3;
			specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 2;
			var selections:Array = selector.selectSurvivors(specimens);
			Assert.assertTrue('Selector seed matches seed used for precalculated assumptions', (selector as RankBasedSelector).seed == 2);
			Assert.assertTrue('Helper selector seed matches seed used for precalculated assumptions', ((selector as RankBasedSelector).helperSelector as StochasticUniversalSamplingSelector).seed == 2);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 2);
			Assert.assertTrue('Best specimen should be selected', selections[0] == specimenC);
			Assert.assertTrue('Second-best specimen should be selected', selections[1] == specimenB);
		}
	}
}