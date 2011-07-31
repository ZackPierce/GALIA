package galia.termination
{
	import galia.core.IAlgorithmLogger;
	import galia.core.ISpecimen;
	import galia.core.ITerminationCondition;
	
	public class MaxFitnessOverThreshold implements ITerminationCondition
	{
		public var targetFitnessThreshold:Number;
		
		public function MaxFitnessOverThreshold(targetFitness:Number = Number.MAX_VALUE) {
			this.targetFitnessThreshold = targetFitness;
		}
		
		public function isTerminationConditionSatisfied(algorithmLogger:IAlgorithmLogger):Boolean {
			var topSpecimen:ISpecimen = algorithmLogger ? algorithmLogger.getTopSpecimen() : null;
			if (topSpecimen && topSpecimen.fitness > targetFitnessThreshold) {
				return true;
			}
			return false;
		}
	}
}