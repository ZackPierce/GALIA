package galia.termination
{
	import galia.core.IAlgorithmLogger;
	import galia.core.ITerminationCondition;
	
	public class MaxGenerationIndex implements ITerminationCondition
	{
		public var maximumGenerationIndex:uint = uint.MAX_VALUE;
		
		public function MaxGenerationIndex(maximumGenerationIndex:uint = uint.MAX_VALUE) {
			this.maximumGenerationIndex = maximumGenerationIndex;
		}
		
		public function terminationConditionSatisfied(algorithmLogger:IAlgorithmLogger):Boolean {
			return algorithmLogger && algorithmLogger.getMaximumGenerationIndex() > maximumGenerationIndex;
		}
	}
}