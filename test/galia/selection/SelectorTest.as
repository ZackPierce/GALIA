package galia.selection
{
	import flexunit.framework.Assert;
	
	import galia.base.Specimen;
	import galia.core.ISelector;
	import galia.core.ISpecimen;
	import galia.selection.supportClasses.TrivialSelector;

	public class SelectorTest
	{
		protected static const DEFAULT_SEED:uint = 2;
		
		protected var selector:ISelector;
		
		protected var seed:uint;
		protected var specimens:Array;
		
		protected var specimenA:ISpecimen;
		protected var specimenB:ISpecimen;
		protected var specimenC:ISpecimen;
		protected var specimenD:ISpecimen;
		protected var specimenE:ISpecimen;
		protected var specimenF:ISpecimen;
		protected var specimenG:ISpecimen;
		
		[Before]
		public function setUp():void
		{
			selector = new TrivialSelector();
			seed = 2;
			specimens = [];
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
			specimens = null;
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
		
		public function SelectorTest()
		{
		}
		
		[Test]
		public function testSelectSurvivorsNullSpecimens():void {
			specimens = null;
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length of 0', selections.length == 0);
		}
		
		[Test]
		public function testSelectSurvivorsEmptySpecimens():void {
			specimens = [];
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length of 0', selections.length == 0);
		}
		
		[Test]
		public function testSelectOneSurvivorOneSpecimen():void
		{
			specimenA.fitness = 1;
			specimens = [specimenA];
			selector.numberOfSelections = 1;
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 1);
			Assert.assertTrue('Selections should contain the only available specimen', selections[0] == specimenA);
		}
		
		[Test]
		public function testSelectThreeSurvivorsOnePossibleSpecimen():void
		{
			specimenA.fitness = 1;
			specimens = [specimenA];
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 3);
			Assert.assertTrue('First selection should be the only available specimen', selections[0] == specimenA);
			Assert.assertTrue('Second selection should be the only available specimen', selections[1] == specimenA);
			Assert.assertTrue('Third selection should be the only available specimen', selections[2] == specimenA);
		}
		
		[Test]
		public function testSelectOneSurvivorOneSpecimenZeroFitness():void
		{
			specimenA.fitness = 0;
			specimens = [specimenA];
			selector.numberOfSelections = 1;
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 1);
			Assert.assertTrue('Selections should contain the only available specimen', selections[0] == specimenA);
		}
		
		[Test]
		public function testSelectThreeSurvivorsOnePossibleSpecimenZeroFitness():void
		{
			specimenA.fitness = 0;
			specimens = [specimenA];
			selector.numberOfSelections = 3;
			var selections:Array = selector.selectSurvivors(specimens);
			
			Assert.assertNotNull('Returned selections array should be non-null', selections);
			Assert.assertTrue('Returned selections array should have a length matching the desired number of selections', selections.length == 3);
			Assert.assertTrue('First selection should be the only available specimen', selections[0] == specimenA);
			Assert.assertTrue('Second selection should be the only available specimen', selections[1] == specimenA);
			Assert.assertTrue('Third selection should be the only available specimen', selections[2] == specimenA);
		}
	}
}