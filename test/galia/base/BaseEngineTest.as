package galia.base
{
	import flexunit.framework.Assert;
	
	import galia.base.supportClasses.TrivialEngine;
	import galia.core.IEngine;
	import galia.core.IPopulation;
	import galia.core.IPopulationEvolutionOperator;
	import galia.core.IPopulationFitnessEvaluator;
	import galia.core.IPopulationSnapshot;
	import galia.core.ISeedingStrategy;
	import galia.core.ISelector;
	import galia.core.ITerminationCondition;
	import galia.fitness.supportClasses.InspectableImmediatePopulationFitnessEvaluator;
	import galia.fitness.supportClasses.TrivialSpecimenFitnessEvaluator;
	import galia.populationEvolution.supportClasses.InspectablePopulationEvolutionOperator;
	import galia.seeding.supportClasses.TrivialChromosomeSeedingStrategy;
	import galia.selection.supportClasses.TrivialSelector;
	import galia.termination.supportClasses.InspectableMaxGenerationIndex;
	
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.handleSignal;
	
	public class BaseEngineTest
	{
		protected var engine:IEngine = null;
		
		protected var maxGenerationIndex:uint = 3000;
		
		protected var populationsCreated:Array;
		protected var populationsFinished:Array;
		protected var populationsFinishedSnapshots:Array;
		protected var terminationConditionSatisfied:ITerminationCondition;
		
		protected var populationSize:uint = 10;
		protected var seedingStrategy:ISeedingStrategy;
		protected var populationFitnessEvaluator:IPopulationFitnessEvaluator;
		protected var selector:ISelector;
		protected var populationEvolutionOperator:IPopulationEvolutionOperator;
		protected var terminationConditions:Array;

		[Before]
		public function setUp():void {
			engine = new TrivialEngine();
			setUpSideEffectRecordingContainers();
			assignEngineComponentsToEngineProperties();
		}
		
		protected function setUpSideEffectRecordingContainers():void {
			populationsCreated = [];
			populationsFinished = [];
			populationsFinishedSnapshots = [];
		}
		
		protected function assignEngineComponentsToEngineProperties():void {
			engine.populationSize = populationSize;
			engine.seedingStrategy = seedingStrategy;
			engine.populationFitnessEvaluator = populationFitnessEvaluator;
			engine.selector = selector;
			engine.populationEvolutionOperator = populationEvolutionOperator;
			engine.terminationConditions = terminationConditions;
		}
		
		[After]
		public function tearDown():void {
			engine = null;
			
			populationSize = 0;
			seedingStrategy = null;
			populationFitnessEvaluator = null;
			selector = null;
			populationEvolutionOperator = null;
			terminationConditions = null;
			
			populationsCreated = null;
			populationsFinished = null;
			populationsFinishedSnapshots = null;
			terminationConditionSatisfied = null;
		}
		
		[Test(async)]
		public function testStartInitiatedSignalPattern():void {
			maxGenerationIndex = 3;
			populationSize = 10;
			seedingStrategy = new TrivialChromosomeSeedingStrategy();
			populationFitnessEvaluator = new InspectableImmediatePopulationFitnessEvaluator(new TrivialSpecimenFitnessEvaluator());
			selector = new TrivialSelector(5);
			populationEvolutionOperator = new InspectablePopulationEvolutionOperator();
			terminationConditions = [new InspectableMaxGenerationIndex(maxGenerationIndex)];
			assignEngineComponentsToEngineProperties();
			
			handleSignal(this, engine.populationCreated, populationCreatedHandler);
			engine.start();
		}
		
		protected function populationCreatedHandler(signalAsyncEvent:SignalAsyncEvent, passThroughData:Object):void {
			var population:IPopulation = signalAsyncEvent.args[0];
			Assert.assertNotNull("Population dispatched via PopulationCreated should not be null", population);
			Assert.assertStrictlyEquals("IPopulation specimens length should match the target populationSize", populationSize, population.specimens.length);
			for each (var previousPopulation:IPopulation in populationsCreated) {
				Assert.assertTrue("All previous populations created should have a generation index less than the current population", population.generationIndex > previousPopulation.generationIndex);
				Assert.assertFalse("No previous population created should have the same id", population.id == previousPopulation.id); 
			}
			populationsCreated.push(population);
			handleSignal(this, engine.populationFinished, populationFinishedHandler);
		}
		
		protected function populationFinishedHandler(signalAsyncEvent:SignalAsyncEvent, passThroughData:Object):void {
			var population:IPopulation = signalAsyncEvent.args[0];
			var snapshot:IPopulationSnapshot = signalAsyncEvent.args[1];
			Assert.assertNotNull("IPopulation dispatched via PopulationFinished should not be null", population);
			Assert.assertNotNull("IPopulationSnapshot dispatched via PopulationFinished should not be null", snapshot);
			Assert.assertStrictlyEquals("IPopulation specimens length should match the target populationSize", engine.populationSize, population.specimens.length);
			Assert.assertStrictlyEquals("IPopulationSnapshot id should match IPopulation id", population.id, snapshot.populationIdentifier);
			for each (var previousPopulation:IPopulation in populationsFinished) {
				Assert.assertTrue("All previous populations finished should have a generation index less than the current population", population.generationIndex > previousPopulation.generationIndex);
				Assert.assertFalse("No previous population finished should have the same id", population.id == previousPopulation.id);
			}
			populationsFinished.push(population);
			populationsFinishedSnapshots.push(snapshot);
			if (populationsFinished.length <= maxGenerationIndex) {
				handleSignal(this, engine.populationCreated, populationCreatedHandler);
			} else {
				handleSignal(this, engine.terminationConditionSatisfied, generationsTerminationConditionSatisfied, 500, null, terminationConditionTimeoutHandler);
			}
		}
		
		protected function generationsTerminationConditionSatisfied(signalAsyncEvent:SignalAsyncEvent, passThroughData:Object):void {
			var terminationCondition:ITerminationCondition = signalAsyncEvent.args[0];
			var numPopulations:uint = maxGenerationIndex + 1;
			Assert.assertStrictlyEquals("Seeding strategy should only be used once.", 1, (seedingStrategy as TrivialChromosomeSeedingStrategy).numGenerateChromosomesCalls);
			Assert.assertStrictlyEquals("Number of evaluatePopulationFitness calls should be equal to number of generations", numPopulations, (populationFitnessEvaluator as InspectableImmediatePopulationFitnessEvaluator).numEvaluatePopulationFitnessCalls);
			Assert.assertStrictlyEquals("Number of evolvePopulation calls should be equal to number of generations  minus one for the last, unpropogated population", numPopulations - 1, (populationEvolutionOperator as InspectablePopulationEvolutionOperator).numEvolvePopulationCalls);
			Assert.assertNotNull("ITerminationCondition should not be null", terminationCondition);
			Assert.assertStrictlyEquals("Number of detected populations via PopulationCreated should match max number of generations", numPopulations, populationsCreated.length);
			Assert.assertStrictlyEquals("Number of detected populations via PopulationFinished should match max number of generations", numPopulations, populationsFinished.length);
			Assert.assertStrictlyEquals("Number of detected snapshots via PopulationFinished should match max number of generations", numPopulations, populationsFinishedSnapshots.length);
		}
		
		protected function terminationConditionTimeoutHandler():void {
			Assert.fail("TerminationConditionSatisfied must be dispatched");
		}
	}
}