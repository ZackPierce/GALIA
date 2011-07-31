package galia.signals
{
	import galia.core.IPopulation;
	
	import org.osflash.signals.Signal;
	
	public class PopulationCreated extends Signal
	{
		public function PopulationCreated() {
			super(IPopulation);
		}
	}
}