package galia.fitness.supportClasses
{
	import galia.core.ISpecimen;
	import galia.core.ISpecimenFitnessEvaluator;
	
	public class TrivialSpecimenFitnessEvaluator implements ISpecimenFitnessEvaluator
	{
		public function TrivialSpecimenFitnessEvaluator() {
		}
		
		public function evaluateSpecimen(specimen:ISpecimen):void {
			specimen.fitness = Math.random();
		}
	}
}