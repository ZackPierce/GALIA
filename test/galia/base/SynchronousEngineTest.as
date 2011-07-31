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
	
	public class SynchronousEngineTest extends BaseEngineTest
	{
		private var sprite:Sprite;
		private var frameCount:uint;
		
		[Before]
		override public function setUp():void {
			engine = new SynchronousEngine();
			populationSize = 10;
			seedingStrategy = new TrivialChromosomeSeedingStrategy();
			populationFitnessEvaluator = new InspectableImmediatePopulationFitnessEvaluator(new TrivialSpecimenFitnessEvaluator());
			selector = new TrivialSelector(5);
			populationEvolutionOperator = new InspectablePopulationEvolutionOperator();
			terminationConditions = [new InspectableMaxGenerationIndex(3)];
			assignEngineComponentsToEngineProperties();
			
			setUpSideEffectRecordingContainers();
			
			
			sprite = new Sprite();
		}
		
		[After]
		override public function tearDown():void {
			super.tearDown();
			sprite = null;
			frameCount = 0;
		}
		
		[Test(async)]
		public function testStartToEndSynchronicity():void {
			maxGenerationIndex = 3;
			engine.terminationConditions = [new InspectableMaxGenerationIndex(maxGenerationIndex)];
			handleSignal(this, engine.terminationConditionSatisfied, sameFrameTerminationConditionSatisfied);
			sprite.addEventListener(Event.ENTER_FRAME, spriteFrameEnterHandler);
			engine.start();
		}
		
		protected function spriteFrameEnterHandler(event:Event):void {
			frameCount++;
		}
		
		protected function sameFrameTerminationConditionSatisfied(signalAsyncEvent:SignalAsyncEvent, passThroughData:Object):void {
			Assert.assertStrictlyEquals("No frames should have passed since the start function was called.", 0, frameCount);
		}
	}
}