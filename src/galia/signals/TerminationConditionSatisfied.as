package galia.signals
{
	import galia.core.ITerminationCondition;
	
	import org.osflash.signals.Signal;
	
	public class TerminationConditionSatisfied extends Signal
	{
		public function TerminationConditionSatisfied() {
			super(ITerminationCondition);
		}
	}
}