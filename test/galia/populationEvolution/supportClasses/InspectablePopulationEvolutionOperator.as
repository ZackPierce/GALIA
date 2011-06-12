package galia.populationEvolution.supportClasses
{
	import flash.utils.getTimer;
	
	import galia.base.Specimen;
	import galia.core.IPopulationEvolutionOperator;
	import galia.core.ISpecimen;
	
	public class InspectablePopulationEvolutionOperator implements IPopulationEvolutionOperator
	{
		public var evolvePopulationRun:Boolean = false;
		public var lastEvolvePopulationExecution:uint = 0;
		
		public var specimenIdPrefix:String = '';
		public var specimenIdCount:uint = 0;
		
		public function InspectablePopulationEvolutionOperator(specimenIdPrefix:String = '')
		{
			this.specimenIdPrefix = specimenIdPrefix;
		}
		
		public function evolvePopulation(specimens:Array, targetPopulationSize:uint):Array
		{
			evolvePopulationRun = true;
			lastEvolvePopulationExecution = (new Date()).time;
			var population:Array = [];
			while (population.length < targetPopulationSize) {
				var specimen:ISpecimen = new Specimen();
				specimen.id = specimenIdPrefix + (specimenIdCount++).toString(); 
				population.push(specimen);
			}
			
			return population;
		}
	}
}