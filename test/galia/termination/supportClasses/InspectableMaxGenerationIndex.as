package galia.termination.supportClasses
{
	import galia.core.IAlgorithmLogger;
	import galia.termination.MaxGenerationIndex;
	
	public class InspectableMaxGenerationIndex extends MaxGenerationIndex
	{
		public var numIsTerminationConditionSatisfiedCalls:uint = 0;
		
		public function InspectableMaxGenerationIndex(maximumGenerationIndex:uint=4.294967295E9) {
			super(maximumGenerationIndex);
		}
		
		override public function isTerminationConditionSatisfied(algorithmLogger:IAlgorithmLogger):Boolean {
			numIsTerminationConditionSatisfiedCalls++;
			return super.isTerminationConditionSatisfied(algorithmLogger);
		}
	}
}