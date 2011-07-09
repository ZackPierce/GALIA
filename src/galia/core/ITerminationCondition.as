package galia.core
{
	public interface ITerminationCondition
	{
		function terminationConditionSatisfied(algorithmLogger:IAlgorithmLogger):Boolean;
	}
}