package galia.populationEvolution
{
	import galia.core.IPopulationEvolutionOperator;
	
	public class SerialPopulationEvolution implements IPopulationEvolutionOperator
	{
		private var _populationEvolutionOperators:Array = [];
		
		public function SerialPopulationEvolution(populationEvolutionOperators:Array = null) {
			this.populationEvolutionOperators = populationEvolutionOperators;
		}
		
		public function evolvePopulation(specimens:Array, targetPopulationSize:uint):Array {
			var population:Array = specimens;
			for (var i:int = 0; i < populationEvolutionOperators.length; i++) {
				var currentPopulationEvolutionOperator:IPopulationEvolutionOperator = populationEvolutionOperators[i] as IPopulationEvolutionOperator;
				if (!currentPopulationEvolutionOperator) {
					continue;
				}
				population = currentPopulationEvolutionOperator.evolvePopulation(population, targetPopulationSize);
			}
			return population;
		}
		
		public function get populationEvolutionOperators():Array {
			return _populationEvolutionOperators;
		}
		
		public function set populationEvolutionOperators(value:Array):void {
			if (!value) {
				_populationEvolutionOperators = [];
			} else {
				_populationEvolutionOperators = value;
			}
		}
	}
}