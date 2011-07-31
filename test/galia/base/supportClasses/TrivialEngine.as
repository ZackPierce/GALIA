package galia.base.supportClasses
{
	import galia.base.AlgorithmLogger;
	import galia.base.Population;
	import galia.base.Specimen;
	import galia.core.IAlgorithmLogger;
	import galia.core.IChromosome;
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
	
	public class TrivialEngine implements IEngine
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
		
		public function TrivialEngine() {
		}
		
		public function start():void {
			var terminationCondition:ITerminationCondition = null;
			var generationIndex:int = 0;
			var chromosomes:Array = seedingStrategy.generateChromosomes(populationSize); // Seeding intentionally ignored!
			
			var population:IPopulation = new Population();
			population.generationIndex = generationIndex;
			population.id = 'seed';
			for each (var chromosome:IChromosome in chromosomes) {
				var specimen:ISpecimen = new Specimen();
				specimen.chromosome = chromosome;
				population.specimens.push(specimen);
			}
			
			// Note that no actual evolution or fitness testing is happening here yet!
			while (true) {
				populationCreated.dispatch(population);
				populationFitnessEvaluator.populationFitnessEvaluated.addOnce(function (evaluatedSpecimens:Array):void {
					population.specimens = evaluatedSpecimens;}
				);
				populationFitnessEvaluator.evaluatePopulationFitness(population.specimens);
				algorithmLogger.logPopulation(population);
				populationFinished.dispatch(population, algorithmLogger.getPopulationSnapshotForGeneration(generationIndex));
				terminationCondition = getAnySatisfiedTerminationCondition()
				if (terminationCondition) {
					_terminationConditionSatisfied.dispatch(terminationCondition);
					break;
				}
				
				generationIndex++;
				population = new Population();
				population.specimens = populationEvolutionOperator.evolvePopulation(population.specimens, populationSize)
				population.generationIndex = generationIndex;
				population.id = generationIndex.toString();
			}
		}
		
		private function generateBlankSpecimensForPopulation(population:IPopulation):void {
			while (population.specimens.length < populationSize) {
				population.specimens.push(new Specimen());
			}
		}
		
		private function getAnySatisfiedTerminationCondition():ITerminationCondition {
			for each (var terminationCondition:ITerminationCondition in terminationConditions) {
				if (terminationCondition.isTerminationConditionSatisfied(algorithmLogger)) {
					return terminationCondition;
				}
			}
			return null;
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