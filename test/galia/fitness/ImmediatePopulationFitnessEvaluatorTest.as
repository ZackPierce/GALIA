package galia.fitness
{
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	
	import galia.base.Specimen;
	import galia.core.ISpecimen;
	import galia.fitness.supportClasses.InspectableAsynchronousSpecimenFitnessEvaluator;
	import galia.fitness.supportClasses.InspectableSynchronousSpecimenFitnessEvaluator;
	
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.handleSignal;
	import org.osflash.signals.utils.proceedOnSignal;
	
	public class ImmediatePopulationFitnessEvaluatorTest
	{
		private var immediatePopulationFitnessEvaluator:ImmediatePopulationFitnessEvaluator;
		
		
		private var synchronousSpecimenFitnessEvaluator:InspectableSynchronousSpecimenFitnessEvaluator;
		private var asynchronousSpecimenFitnessEvaluator:InspectableAsynchronousSpecimenFitnessEvaluator;
		
		private var specimens:Array;
		
		[Before]
		public function setUp():void {
			immediatePopulationFitnessEvaluator = new ImmediatePopulationFitnessEvaluator();
			synchronousSpecimenFitnessEvaluator = new InspectableSynchronousSpecimenFitnessEvaluator();
			asynchronousSpecimenFitnessEvaluator = new InspectableAsynchronousSpecimenFitnessEvaluator();
			specimens = [];
			for (var i:int = 0; i < 5; i++) {
				var specimen:ISpecimen = new Specimen();
				specimen.id = String.fromCharCode(i);
				specimens.push(specimen);
			}
		}
		
		[After]
		public function tearDown():void {
			immediatePopulationFitnessEvaluator = null;
			synchronousSpecimenFitnessEvaluator = null;
			asynchronousSpecimenFitnessEvaluator = null;
			specimens = null;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void {
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void {
		}
		
		[Test(async, 'Null specimens array should still result in a populationFitnessEvaluated dispatch')]
		public function testEvaluatePopulationFitnessNullSpecimensArray():void {
			specimens = null;
			handleSignal(this, immediatePopulationFitnessEvaluator.populationFitnessEvaluated, populationFitnessEvaluatedHandlerConfirmNullSpecimensDispatched);
			immediatePopulationFitnessEvaluator.evaluatePopulationFitness(specimens);
		}
		
		private function populationFitnessEvaluatedHandlerConfirmNullSpecimensDispatched(event:SignalAsyncEvent, data:Object):void {
			Assert.assertNull('If the input specimens array is null, the PopulationFitnessEvaluated dispatched array should also be null', event.args[0]);
		}
		
		[Test(async, 'Empty specimens array should still result in a populationFitnessEvaluated dispatch')]
		public function testEvaluatePopulationFitnessEmptySpecimensArray():void {
			specimens = [];
			handleSignal(this, immediatePopulationFitnessEvaluator.populationFitnessEvaluated, populationFitnessEvaluatedHandlerConfirmSameSpecimensDispatched);
			immediatePopulationFitnessEvaluator.evaluatePopulationFitness(specimens);
		}
		
		private function populationFitnessEvaluatedHandlerConfirmSameSpecimensDispatched(event:SignalAsyncEvent, data:Object):void {
			Assert.assertNotNull('If the input specimens array is non-null, the PopulationFitnessEvaluated dispatched array should be non-null', event.args[0]);
			var outputSpecimens:Array = event.args[0] as Array;
			Assert.assertStrictlyEquals('The input specimens array should have the same length as the PopulationFitnessEvaluated dispatched array', specimens.length, outputSpecimens.length);
			var specimenIds:Dictionary = new Dictionary();
			for (var j:int = 0; j < specimens.length; j++) {
				specimenIds[(specimens[j] as ISpecimen).id] = false;
			}
			
			for (var i:int = 0; i < outputSpecimens.length; i++) {
				var specimen:ISpecimen = outputSpecimens[i];
				specimenIds[specimen.id] = true;
				Assert.assertTrue('Every ISpecimen should have its isFitnessTested property set to true after PopulationFitnessEvaluated is dispatched', specimen.isFitnessTested);
			}
			
			for each (var value:Object in specimenIds) {
				Assert.assertTrue('Every ISpecimen id from the input specimen array should be found in the output dispatched specimen array', value);
			}
		}
		
		[Test(async)]
		public function testEvaluatePopulationFitnessSynchronousSpecimenFitnessEvaluator():void {
			immediatePopulationFitnessEvaluator.specimenFitnessEvaluator = synchronousSpecimenFitnessEvaluator;
			handleSignal(this, immediatePopulationFitnessEvaluator.populationFitnessEvaluated, populationFitnessEvaluatedHandlerConfirmSameSpecimensDispatched);
			immediatePopulationFitnessEvaluator.evaluatePopulationFitness(specimens);
		}
		
		[Test(async)]
		public function testEvaluatePopulationFitnessAsynchronousSpecimenFitnessEvaluator():void {
			immediatePopulationFitnessEvaluator.specimenFitnessEvaluator = asynchronousSpecimenFitnessEvaluator;
			handleSignal(this, immediatePopulationFitnessEvaluator.populationFitnessEvaluated, populationFitnessEvaluatedHandlerConfirmSameSpecimensDispatched);
			immediatePopulationFitnessEvaluator.evaluatePopulationFitness(specimens);
		}
	}
}