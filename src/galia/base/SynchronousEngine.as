package galia.base
{
	import galia.core.IAlgorithmLogger;
	import galia.core.IEngine;
	import galia.core.IPopulation;
	import galia.core.IPopulationEvolutionOperator;
	import galia.core.IPopulationFitnessEvaluator;
	import galia.core.ISeedingStrategy;
	import galia.core.ISelector;
	import galia.core.ISpecimen;
	import galia.core.ITerminationCondition;
	import galia.signals.PopulationCreated;
	import galia.signals.PopulationFinished;
	import galia.signals.TerminationConditionSatisfied;

	/** An implementation of IEngine that executes a genetic algorithm synchronously.
	 *  Due to the synchronous execution scheme, this engine is not suited for applications
	 *  requiring responsive user interactions while the engine runs. 
	 */
	public class SynchronousEngine implements IEngine
	{
		private var _populationSize:uint = 1;
		
		private var _algorithmLogger:IAlgorithmLogger = new AlgorithmLogger();
		private var _seedingStrategy:ISeedingStrategy;
		private var _populationFitnessEvaluator:IPopulationFitnessEvaluator;
		private var _selector:ISelector;
		private var _populationEvolutionOperator:IPopulationEvolutionOperator;
		private var _terminationConditions:Array;
		
		private var _populationCreated:PopulationCreated = new PopulationCreated();
		private var _populationFinished:PopulationFinished = new PopulationFinished();
		private var _terminationConditionSatisfied:TerminationConditionSatisfied = new TerminationConditionSatisfied();
		
		private var currentPopulation:IPopulation;
		private var generationIndex:uint = 0;
		
		public function SynchronousEngine() {
			
		}
		
		public function start():void {
			if (!algorithmLogger || !_seedingStrategy || !_populationFitnessEvaluator || !_selector || !_populationEvolutionOperator) {
				throw new Error("Missing one or more of the required IEngine components.");
				return;
			}
			algorithmLogger.logAlgorithmStart();
			currentPopulation = new Population();
			currentPopulation.generationIndex = generationIndex;
			currentPopulation.id = currentPopulation.generationIndex.toString();
			var specimens:Array = currentPopulation.specimens;
			var chromosomes:Array = seedingStrategy.generateChromosomes(populationSize);
			var numChromosomes:uint = chromosomes.length;
			for (var i:uint; i < numChromosomes; i++) {
				var specimen:ISpecimen = new Specimen();
				specimen.chromosome = chromosomes[i];
				specimen.id = generationIndex.toString() + '_' + i.toString();
				specimens.push(specimen);
			}
			populationFitnessEvaluator.populationFitnessEvaluated.add(populationFitnessEvaluatedHandler);
			runGeneration();
		}
		
		private function runGeneration():void {
			populationCreated.dispatch(currentPopulation);
			populationFitnessEvaluator.evaluatePopulationFitness(currentPopulation.specimens);
		}
		
		private function populationFitnessEvaluatedHandler(specimens:Array):void {
			currentPopulation.specimens = specimens;
			algorithmLogger.logPopulation(currentPopulation);
			populationFinished.dispatch(currentPopulation, algorithmLogger.getPopulationSnapshotForGeneration(generationIndex));
			var terminationCondition:ITerminationCondition = getAnySatisfiedTerminationCondition();
			if (terminationCondition) {
				algorithmLogger.logAlgorithmStop();
				cleanUpHandlers();
				terminationConditionSatisfied.dispatch(terminationCondition);
				return;
			}
			var survivors:Array = selector.selectSurvivors(specimens);
			var freshSpecimens:Array = populationEvolutionOperator.evolvePopulation(survivors, populationSize);
			generationIndex++;
			currentPopulation = new Population();
			currentPopulation.generationIndex = generationIndex;
			currentPopulation.id = currentPopulation.generationIndex.toString();
			var numSpecimens:uint = freshSpecimens.length;
			for (var i:uint = 0; i < numSpecimens; i++) {
				var specimen:ISpecimen = freshSpecimens[i];
				specimen.id = generationIndex.toString() + "_" + i.toString();
				currentPopulation.specimens.push(specimen);
			}
			runGeneration();
		}
		
		private function getAnySatisfiedTerminationCondition():ITerminationCondition {
			for each (var terminationCondition:ITerminationCondition in terminationConditions) {
				if (terminationCondition.isTerminationConditionSatisfied(algorithmLogger)) {
					return terminationCondition;
				}
			}
			return null;
		}
		
		private function cleanUpHandlers():void {
			populationFitnessEvaluator.populationFitnessEvaluated.remove(populationFitnessEvaluatedHandler);
		}
		
		public function get populationSize():uint {
			return _populationSize;
		}
		
		public function set populationSize(value:uint):void {
			_populationSize = value;
		}
		
		public function get algorithmLogger():IAlgorithmLogger {
			return _algorithmLogger;
		}
		public function set algorithmLogger(value:IAlgorithmLogger):void {
			_algorithmLogger = value;
		}
		
		public function get seedingStrategy():ISeedingStrategy {
			return _seedingStrategy;
		}
		
		public function set seedingStrategy(value:ISeedingStrategy):void {
			_seedingStrategy = value;
		}
		
		public function get populationFitnessEvaluator():IPopulationFitnessEvaluator {
			return _populationFitnessEvaluator;
		}
		public function set populationFitnessEvaluator(value:IPopulationFitnessEvaluator):void {
			_populationFitnessEvaluator = value;
		}
		
		public function get selector():ISelector {
			return _selector;
		}
		
		public function set selector(value:ISelector):void {
			_selector = value;
		}
		
		public function get populationEvolutionOperator():IPopulationEvolutionOperator {
			return _populationEvolutionOperator;
		}
		
		public function set populationEvolutionOperator(value:IPopulationEvolutionOperator):void {
			_populationEvolutionOperator = value;
		}
		
		public function get terminationConditions():Array {
			return _terminationConditions;
		}
		
		public function set terminationConditions(value:Array):void {
			_terminationConditions = value;
		}
		
		public function get populationCreated():PopulationCreated {
			return _populationCreated;
		}
		
		public function get populationFinished():PopulationFinished {
			return _populationFinished;
		}
		
		public function get terminationConditionSatisfied():TerminationConditionSatisfied {
			return _terminationConditionSatisfied;
		}
	}
}