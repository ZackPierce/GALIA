package galia.fitness
{
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	
	import galia.base.Specimen;
	import galia.core.ISpecimen;
	import galia.fitness.supportClasses.InspectableAsynchronousSpecimenFitnessEvaluator;
	
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.handleSignal;
	
	public class SpooledParallelPopulationFitnessEvaluatorTest
	{
		private var spooledParallelPopulationFitnessEvaluator:SpooledParallelPopulationFitnessEvaluator;
		
		private var asynchronousSpecimenFitnessEvaluator:InspectableAsynchronousSpecimenFitnessEvaluator;
		
		private var specimens:Array;
		
		[Before]
		public function setUp():void
		{
			spooledParallelPopulationFitnessEvaluator = new SpooledParallelPopulationFitnessEvaluator();
			asynchronousSpecimenFitnessEvaluator = new InspectableAsynchronousSpecimenFitnessEvaluator();
			specimens = [];
			for (var i:int = 0; i < 5; i++) {
				var specimen:ISpecimen = new Specimen();
				specimen.id = String.fromCharCode(i);
				specimens.push(specimen);
			}
		}
		
		[After]
		public function tearDown():void
		{
			spooledParallelPopulationFitnessEvaluator = null;
			asynchronousSpecimenFitnessEvaluator = null;
			specimens = null;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test(async, 'Null specimens array should still result in a populationFitnessEvaluated dispatch')]
		public function testEvaluatePopulationFitnessNullSpecimensArray():void
		{
			specimens = null;
			spooledParallelPopulationFitnessEvaluator.asynchronousSpecimenFitnessEvaluator = asynchronousSpecimenFitnessEvaluator;
			handleSignal(this, spooledParallelPopulationFitnessEvaluator.populationFitnessEvaluated, populationFitnessEvaluatedHandlerConfirmNullSpecimensDispatched);
			spooledParallelPopulationFitnessEvaluator.evaluatePopulationFitness(specimens);
		}
		
		private function populationFitnessEvaluatedHandlerConfirmNullSpecimensDispatched(event:SignalAsyncEvent, data:Object):void {
			Assert.assertNull('If the input specimens array is null, the PopulationFitnessEvaluated dispatched array should also be null', event.args[0]);
		}
		
		[Test(async, 'Empty specimens array should still result in a populationFitnessEvaluated dispatch')]
		public function testEvaluatePopulationFitnessEmptySpecimensArray():void
		{
			specimens = [];
			spooledParallelPopulationFitnessEvaluator.asynchronousSpecimenFitnessEvaluator = asynchronousSpecimenFitnessEvaluator;
			handleSignal(this, spooledParallelPopulationFitnessEvaluator.populationFitnessEvaluated, populationFitnessEvaluatedHandlerConfirmSameSpecimensDispatched);
			spooledParallelPopulationFitnessEvaluator.evaluatePopulationFitness(specimens);
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
		public function testEvaluatePopulationFitnessAsynchronousSpecimenFitnessEvaluator():void
		{
			spooledParallelPopulationFitnessEvaluator.asynchronousSpecimenFitnessEvaluator = asynchronousSpecimenFitnessEvaluator;
			spooledParallelPopulationFitnessEvaluator.maximumParallelActiveSpecimenFitnessEvaluations = 1;
			handleSignal(this, asynchronousSpecimenFitnessEvaluator.specimenFitnessEvaluated, individualSpecimenFitnessEvaluatedHandler);
			handleSignal(this, spooledParallelPopulationFitnessEvaluator.populationFitnessEvaluated, populationFitnessEvaluatedHandlerConfirmSameSpecimensDispatched);
			spooledParallelPopulationFitnessEvaluator.evaluatePopulationFitness(specimens);
			Assert.assertStrictlyEquals('The number of fitness tests running should be equal to the max available parallel size if the number of specimens is greater than or equal to the max active amount', spooledParallelPopulationFitnessEvaluator.maximumParallelActiveSpecimenFitnessEvaluations, asynchronousSpecimenFitnessEvaluator.specimensEvaluationActive.length);
		}
		
		private function individualSpecimenFitnessEvaluatedHandler(event:SignalAsyncEvent, data:Object):void {
			var specimenJustFinishingEvaluation:ISpecimen = event.args[0];
			Assert.assertNotNull('Specimen returned through SpecimenFitnessEvaluated should not be null', specimenJustFinishingEvaluation);
			Assert.assertTrue('The number of fitness tests running after each individual specimen finishes should not exceed the max parallel amount', asynchronousSpecimenFitnessEvaluator.specimensEvaluationActive.length < spooledParallelPopulationFitnessEvaluator.maximumParallelActiveSpecimenFitnessEvaluations);
		}
		
		[Test(async)]
		public function testEvaluatePopulationFitnessAsynchronousSpecimenFitnessEvaluatorHigherMaxParallelThanSpecimensAvailable():void
		{
			spooledParallelPopulationFitnessEvaluator.asynchronousSpecimenFitnessEvaluator = asynchronousSpecimenFitnessEvaluator;
			spooledParallelPopulationFitnessEvaluator.maximumParallelActiveSpecimenFitnessEvaluations = specimens.length + 1;
			handleSignal(this, asynchronousSpecimenFitnessEvaluator.specimenFitnessEvaluated, individualSpecimenFitnessEvaluatedHandler);
			handleSignal(this, spooledParallelPopulationFitnessEvaluator.populationFitnessEvaluated, populationFitnessEvaluatedHandlerConfirmSameSpecimensDispatched);
			spooledParallelPopulationFitnessEvaluator.evaluatePopulationFitness(specimens);
			Assert.assertStrictlyEquals('The number of fitness tests running should be equal to the number of specimens if the number of specimens is less than the max active parallel amount', specimens.length, asynchronousSpecimenFitnessEvaluator.specimensEvaluationActive.length);
		}
	}
}