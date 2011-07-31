package galia.termination
{
	import galia.core.IAlgorithmLogger;
	import galia.core.ITerminationCondition;
	
	public class ActiveRunningTimeOverDurationLimit implements ITerminationCondition
	{
		public var durationLimitInMilliseconds:uint;
		
		public function ActiveRunningTimeOverDurationLimit(durationLimitInMilliseconds:uint = uint.MAX_VALUE) {
			this.durationLimitInMilliseconds = durationLimitInMilliseconds;
		}
		
		public function isTerminationConditionSatisfied(algorithmLogger:IAlgorithmLogger):Boolean {
			return algorithmLogger && algorithmLogger.getAlgorithmRunningDuration() > durationLimitInMilliseconds;
		}
	}
}