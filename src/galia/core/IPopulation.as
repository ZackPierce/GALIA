package galia.core
{
	public interface IPopulation
	{
		/**
		 * @return An array of objects of type ISpecimen
		 *  Implementation note: deliberately avoiding the more appropriate Vector.<Specimen> to be compatible with Flash Player 9.x
		 * 
		 */
		function get specimens():Array; 
		
		/**
		 * @param value An array of objects of type ISpecimen
		 */
		function set specimens(value:Array):void;
	}
}