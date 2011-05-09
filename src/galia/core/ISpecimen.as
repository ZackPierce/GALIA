package galia.core
{
	/**
	 * Represents the an individual in a population with a particular chromosome.
	 * Stores identification and fitness-calculation-related metadata. 
	 */
	public interface ISpecimen
	{
		function get id():String;
		function set id(value:String):void;
		
		function get chromosome():IChromosome;
		function set chromosome(value:IChromosome):void;
		
		function get fitness():Number;
		function set fitness(value:Number):void;
		
		function get normalizedFitness():Number;
		function set normalizedFitness(value:Number):void;
		
		function get isFitnessTested():Boolean;
		function set isFitnessTested(value:Boolean):void;
		
		function get accumulatedNormalizedFitness():Number;
		function set accumulatedNormalizedFitness(value:Number):void;
	}
}