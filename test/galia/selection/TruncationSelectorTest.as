package galia.selection
{
	import flexunit.framework.Assert;
	
	import galia.math.ParkMillerRandomNumberGenerator;
	
	public class TruncationSelectorTest extends SelectorTest
	{		
		[Before]
		override public function setUp():void {
			super.setUp();
			selector = new TruncationSelector();
			(selector as TruncationSelector).randomNumberGenerator = new ParkMillerRandomNumberGenerator(2);
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
		public function testSelectSurvivorsOneSurvivor():void {
			specimenA.fitness = 1;
			specimenB.fitness = 2;
			specimenC.fitness = 3;
			specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 1;
			var selections:Array = selector.selectSurvivors(specimens);
			
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 1);
			Assert.assertTrue('Best specimen should be selected', selections[0] == specimenC);
		}
		
		[Test]
		public function testSelectSurvivorsTwoSurvivors():void {
			specimenA.fitness = 1;
			specimenB.fitness = 2;
			specimenC.fitness = 3;
			specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 2;
			var selections:Array = selector.selectSurvivors(specimens);
			
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 2);
			Assert.assertTrue('Best specimen should be selected', selections[0] == specimenC);
			Assert.assertTrue('Second-best specimen should be selected', selections[1] == specimenB);
		}
		
		[Test]
		public function testSelectSurvivorsFourSurvivorsThreeSpecimens():void {
			specimenA.fitness = 1;
			specimenB.fitness = 2;
			specimenC.fitness = 3;
			specimens = [specimenA, specimenB, specimenC];
			selector.numberOfSelections = 4;
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 4);
			Assert.assertTrue('Best specimen should be selected', selections[0] == specimenC);
			Assert.assertTrue('Second-best specimen should be selected', selections[1] == specimenB);
			Assert.assertTrue('Third-best specimen should be selected', selections[2] == specimenA);
			Assert.assertTrue('Best specimen should be selected again', selections[3] == specimenC);
		}
	}
}