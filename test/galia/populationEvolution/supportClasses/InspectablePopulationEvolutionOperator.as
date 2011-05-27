package galia.populationEvolution.supportClasses
{
	import flash.utils.getTimer;
	
	import galia.base.Specimen;
	import galia.core.IPopulationEvolutionOperator;
	
	public class InspectablePopulationEvolutionOperator implements IPopulationEvolutionOperator
	{
		public var evolvePopulationRun:Boolean = false;
		public var lastEvolvePopulationExecution:uint = 0;
		
		public function InspectablePopulationEvolutionOperator()
		{
		}
		
		public function evolvePopulation(specimens:Array, targetPopulationSize:uint):Array
		{
			evolvePopulationRun = true;
			lastEvolvePopulationExecution = (new Date()).time;
			var population:Array = [];
			while (population.length < targetPopulationSize) {
				population.push(new Specimen());
			}
			
			return population;
		}
	}
}