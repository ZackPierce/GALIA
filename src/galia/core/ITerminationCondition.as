package galia.core
{
	public interface ITerminationCondition
	{
		function isTerminationConditionSatisfied(algorithmLogger:IAlgorithmLogger):Boolean;
	}
}