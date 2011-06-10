package galia.core
{
	public interface ISpecimenFitnessEvaluator
	{
		/**
		 * Calcuates and sets the fitness property of the input ISpecimen
		 * 
		 * @param specimen The ISpecimen to evaluate, usually on the basis of some interpretation of the chromosome.
		 */
		function evaluateSpecimen(specimen:ISpecimen):void;
	}
}