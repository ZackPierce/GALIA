package galia.populationEvolution
{
	import galia.core.IPopulationEvolutionOperator;
	
	public class SplitPopulationEvolution implements IPopulationEvolutionOperator
	{
		private var _populationEvolutionOperators:Array = [];
		private var _populationOperatorWeights:Array = [];
		
		public function SplitPopulationEvolution(populationEvolutionOperators:Array = null, populationOperatorWeights:Array = null) {
			this._populationEvolutionOperators = populationEvolutionOperators ? populationEvolutionOperators : [];
			this._populationOperatorWeights = populationOperatorWeights ? populationOperatorWeights : [];
		}
		
		public function evolvePopulation(specimens:Array, targetPopulationSize:uint):Array {
			if (!specimens || targetPopulationSize == 0) {
				return [];
			}
			var rawWeights:Array = _populationOperatorWeights.concat();
			var numOperators:uint = _populationEvolutionOperators.length;
			var weightSum:Number = 0;
			var defaultRawWeight:Number = 1.0 / numOperators;
			for (var i:int = 0; i < numOperators; i++) {
				var rawWeight:Number = defaultRawWeight;
				if (i < _populationOperatorWeights.length) {
					var foundWeight:Number = Number(rawWeights[i]); 
					rawWeight = !isNaN(foundWeight) && foundWeight >= 0 ? foundWeight : 0;
				}
				rawWeights[i] = rawWeight; 
				weightSum += rawWeight;
			}
			var population:Array = specimens.concat();
			if (weightSum == 0) {
				return population;
			}
			var outputPopulation:Array = [];
			var numInputSpecimens:uint = specimens.length;
			for (var j:int = 0; j < _populationEvolutionOperators.length; j++) {
				var normalizedPopulationPortion:uint = uint(Math.ceil((rawWeights[j]/weightSum)*numInputSpecimens));
				var operatorPortionOfPopulation:Array = [];
				while (population.length > 0 && operatorPortionOfPopulation.length < normalizedPopulationPortion) {
					operatorPortionOfPopulation.push(population.pop());
				}
				var populationOperator:IPopulationEvolutionOperator = _populationEvolutionOperators[j];
				var operatorOutput:Array = populationOperator.evolvePopulation(operatorPortionOfPopulation, operatorPortionOfPopulation.length); 
				outputPopulation = outputPopulation.concat(operatorOutput);
			}
			
			return outputPopulation;
		}
		
		public function get populationEvolutionOperators():Array {
			return _populationEvolutionOperators;
		}
		
		public function set populationEvolutionOperators(value:Array):void {
			if (value) {
				this._populationEvolutionOperators = value;
				this._populationOperatorWeights = [];
			} else {
				this._populationEvolutionOperators = [];
				this._populationOperatorWeights = [];
			}
		}
		
		public function get populationOperatorWeights():Array {
			return _populationOperatorWeights;
		}
		
		public function set populationOperatorWeights(value:Array):void {
			if (value) {
				this._populationOperatorWeights = value;
			} else {
				this._populationOperatorWeights = null;
			}
		}
		
		public function setPopulationEvolutionOperatorsAndWeights(populationEvolutionOperators:Array, populationOperatorWeights:Array = null):void {
			if (populationEvolutionOperators) {
				this._populationEvolutionOperators = populationEvolutionOperators;
				this.populationOperatorWeights = populationOperatorWeights ? populationOperatorWeights : []; 
			} else {
				this._populationEvolutionOperators = [];
				this._populationOperatorWeights = [];
			}
		}
	}
}