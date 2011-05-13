package galia.selection
{
	import flexunit.framework.Assert;
	
	public class RankBasedSelectorTest extends SelectorTest
	{		
		[Before]
		override public function setUp():void
		{
			super.setUp();
			selector = new RankBasedSelector();
			(selector as RankBasedSelector).seed = 2; 
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
		public function testSelectSurvivors():void
		{
			Assert.fail("Test method Not yet implemented");
		}
	}
}