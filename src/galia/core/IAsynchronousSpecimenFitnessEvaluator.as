package galia.core
{
	import galia.signals.SpecimenFitnessEvaluated;

	public interface IAsynchronousSpecimenFitnessEvaluator extends ISpecimenFitnessEvaluator
	{
		/**
		 * A Signal dispatched when the potentially-asynchronous evaluation of a specimen
		 * previously passed to the evaluateSpecimen function is complete.
		 */
		function get specimenFitnessEvaluated():SpecimenFitnessEvaluated;
		function set specimenFitnessEvaluated(specimenFitnessEvaluatedSignal:SpecimenFitnessEvaluated):void;
	}
}