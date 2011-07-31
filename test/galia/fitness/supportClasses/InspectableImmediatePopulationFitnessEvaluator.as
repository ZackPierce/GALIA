package galia.fitness.supportClasses
{
	import galia.core.ISpecimenFitnessEvaluator;
	import galia.fitness.ImmediatePopulationFitnessEvaluator;
	
	public class InspectableImmediatePopulationFitnessEvaluator extends ImmediatePopulationFitnessEvaluator
	{
		public var numEvaluatePopulationFitnessCalls:uint = 0;
		
		public function InspectableImmediatePopulationFitnessEvaluator(specimenFitnessEvaluator:ISpecimenFitnessEvaluator=null) {
			super(specimenFitnessEvaluator);
		}
		
		override public function evaluatePopulationFitness(specimens:Array):void {
			numEvaluatePopulationFitnessCalls++;
			super.evaluatePopulationFitness(specimens);
		}
	}
}