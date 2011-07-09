package galia.signals
{
	import galia.core.ISpecimen;
	
	import org.osflash.signals.Signal;
	
	/**
	 * A Signal used to indicate that the fitness property of the dispatched ISpecimen
	 * has been calculated and set.
	 */
	public class SpecimenFitnessEvaluated extends Signal
	{
		public function SpecimenFitnessEvaluated() {
			super(ISpecimen);
		}
	}
}