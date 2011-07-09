package galia.selection
{
	import flexunit.framework.Assert;
	
	import galia.base.Specimen;
	import galia.core.ISpecimen;
	
	public class RouletteWheelSelectorTest extends SelectorTest
	{
		[Before]
		override public function setUp():void {
			super.setUp();
			selector = new RouletteWheelSelector();
			(selector as RouletteWheelSelector).seed = 1;
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
		public function testSelectSurvivorsSimple():void {
			specimenA.fitness = 0; // Corresponds to accumulated normalized fitness of 0
			specimenB.fitness = 1; // Corresponds to accumulated normalized fitness of 1/6.0
			specimenC.fitness = 2; // Corresponds to accumulated normalized fitness of 3/6.0
			specimenD.fitness = 3; // Corresponds to accumulated normalized fitness of 6/6.0
			specimens = [specimenA, specimenB, specimenC, specimenD];
			selector.numberOfSelections = 3;
			
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertTrue('Proper number of selections made', selections.length == 3);
			// Since we expect default seed to cause Rndm to produce the following values: 0.000007826602259425612, 0.13153778837616625, 0.7556053224280331, 0.4586501321564493,
			// the corresponding first accumulated normalized fitnesses that would be found are specimenB, specimenB, specimenD, and specimenB again
			Assert.assertTrue('First selection is B', selections[0] == specimenB);
			Assert.assertTrue('Second selection is also specimenB', selections[1] == specimenB);
			Assert.assertTrue('Third selection is specimenD', selections[2] == specimenD);
		}
		
		[Test]
		public function testSelectSurvivorsSimpleDisordered():void {
			specimenA.fitness = 0; // Corresponds to accumulated normalized fitness of 0
			specimenB.fitness = 1; // Corresponds to accumulated normalized fitness of 1/6.0
			specimenC.fitness = 2; // Corresponds to accumulated normalized fitness of 3/6.0
			specimenD.fitness = 3; // Corresponds to accumulated normalized fitness of 6/6.0
			specimens = [specimenD, specimenA, specimenC, specimenB];
			selector.numberOfSelections = 3;
			
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertTrue('Proper number of selections made', selections.length == 3);
			// Since we expect default seed to cause Rndm to produce the following values: 0.000007826602259425612, 0.13153778837616625, 0.7556053224280331, 0.4586501321564493,
			// the corresponding first accumulated normalized fitnesses that would be found are specimenB, specimenB, specimenD, and specimenB again
			Assert.assertTrue('First selection is B', selections[0] == specimenB);
			Assert.assertTrue('Second selection is also specimenB', selections[1] == specimenB);
			Assert.assertTrue('Third selection is specimenD', selections[2] == specimenD);
		}
	}
}