package galia.core
{
	import galia.signals.PopulationCreated;
	import galia.signals.PopulationFinished;
	import galia.signals.TerminationConditionSatisfied;

	public interface IEngine
	{
		function start():void;
		
		function get populationSize():uint;
		function set populationSize(value:uint):void;
		
		function get algorithmLogger():IAlgorithmLogger;
		function set algorithmLogger(value:IAlgorithmLogger):void;
		
		function get seedingStrategy():ISeedingStrategy;
		function set seedingStrategy(value:ISeedingStrategy):void;
		
		function get populationFitnessEvaluator():IPopulationFitnessEvaluator;
		function set populationFitnessEvaluator(value:IPopulationFitnessEvaluator):void;
		
		function get selector():ISelector;
		function set selector(value:ISelector):void;
		
		function get populationEvolutionOperator():IPopulationEvolutionOperator;
		function set populationEvolutionOperator(value:IPopulationEvolutionOperator):void;
		
		function get terminationConditions():Array;
		function set terminationConditions(value:Array):void;
		
		function get populationCreated():PopulationCreated;
		function get populationFinished():PopulationFinished;
		function get terminationConditionSatisfied():TerminationConditionSatisfied;
	}
}