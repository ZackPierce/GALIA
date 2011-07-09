package galia.fitness.supportClasses
{
	import galia.core.ISpecimen;
	import galia.core.ISpecimenFitnessEvaluator;
	
	public class InspectableSynchronousSpecimenFitnessEvaluator implements ISpecimenFitnessEvaluator
	{
		public var specimensEvaluationStarted:Array = []
		public var specimensEvaluationCompleted:Array = [];
		
		public function InspectableSynchronousSpecimenFitnessEvaluator() {
		}
		
		public function evaluateSpecimen(specimen:ISpecimen):void {
			specimensEvaluationStarted.push(specimen);
			specimen.fitness = 1;
			specimen.isFitnessTested = true;
			specimensEvaluationCompleted.push(specimen);
		}
	}
}