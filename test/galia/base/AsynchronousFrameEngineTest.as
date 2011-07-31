package galia.base
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flexunit.framework.Assert;
	
	import galia.fitness.supportClasses.InspectableImmediatePopulationFitnessEvaluator;
	import galia.fitness.supportClasses.TrivialSpecimenFitnessEvaluator;
	import galia.populationEvolution.supportClasses.InspectablePopulationEvolutionOperator;
	import galia.seeding.supportClasses.TrivialChromosomeSeedingStrategy;
	import galia.selection.supportClasses.TrivialSelector;
	import galia.termination.MaxGenerationIndex;
	import galia.termination.supportClasses.InspectableMaxGenerationIndex;
	
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.handleSignal;
	
	public class AsynchronousFrameEngineTest extends BaseEngineTest
	{
		private var sprite:Sprite;
		private var frameWait:uint;
		private var frameCount:uint;
		
		[Before]
		override public function setUp():void {
			engine = new AsynchronousFrameEngine();
			sprite = new Sprite();
			maxGenerationIndex = 3;
			populationSize = 10;
			seedingStrategy = new TrivialChromosomeSeedingStrategy();
			populationFitnessEvaluator = new InspectableImmediatePopulationFitnessEvaluator(new TrivialSpecimenFitnessEvaluator());
			selector = new TrivialSelector(5);
			populationEvolutionOperator = new InspectablePopulationEvolutionOperator();
			terminationConditions = [new InspectableMaxGenerationIndex(maxGenerationIndex)];
			assignEngineComponentsToEngineProperties();
			setUpSideEffectRecordingContainers();
		}
		
		[After]
		override public function tearDown():void {
			super.tearDown();
			sprite = null;
			frameWait = 0;
			frameCount = 0;
		}
		
		[Test(async)]
		public function testStartZeroFrameWait():void {
			frameWait = 0;
			(engine as AsynchronousFrameEngine).frameWait = frameWait;
			handleSignal(this, engine.terminationConditionSatisfied, frameWaitTerminationConditionSatisfied);
			sprite.addEventListener(Event.ENTER_FRAME, spriteFrameEnterHandler);
			engine.start();
		}
		
		[Test(async)]
		public function testStartOneFrameWait():void {
			frameWait = 1;
			(engine as AsynchronousFrameEngine).frameWait = frameWait;
			handleSignal(this, engine.terminationConditionSatisfied, frameWaitTerminationConditionSatisfied);
			sprite.addEventListener(Event.ENTER_FRAME, spriteFrameEnterHandler);
			engine.start();
		}
		
		[Test(async, timeout=1000)]
		public function testStartFiveFrameWait():void {
			frameWait = 5;
			(engine as AsynchronousFrameEngine).frameWait = frameWait;
			handleSignal(this, engine.terminationConditionSatisfied, frameWaitTerminationConditionSatisfied, 1000);
			sprite.addEventListener(Event.ENTER_FRAME, spriteFrameEnterHandler);
			engine.start();
		}
		
		protected function spriteFrameEnterHandler(event:Event):void {
			frameCount++;
		}
		
		protected function frameWaitTerminationConditionSatisfied(signalAsyncEvent:SignalAsyncEvent, passThroughData:Object):void {
			var numberOfPopulations:uint = maxGenerationIndex + 1;
			Assert.assertStrictlyEquals("Number frames passed should equal the frameWait times the number of populations minus one for the seed population fitness that was run immediately (or zero if the frameWait was zero).", Math.max(0, (frameWait*numberOfPopulations) - 1), frameCount);
		}
		
	}
}