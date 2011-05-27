package galia.populationEvolution.supportClasses
{
	import galia.core.IChromosome;
	import galia.core.IProcreationOperator;
	
	public class TrivialChromosomeProcreationOperator implements IProcreationOperator
	{
		private var _numberOfParentsRequired:uint = 0;
		
		public var procreationExecuted:Boolean = false;
		
		public function TrivialChromosomeProcreationOperator()
		{
		}
		
		public function procreate(parentChromosomes:Array):Array {
			procreationExecuted = true;
			var kids:Array = [];
			if (!parentChromosomes || parentChromosomes.length == 0) {
				kids.push(new TrivialChromosome());
				return kids;
			}
			for each (var parent:IChromosome in parentChromosomes) {
				kids.push(new TrivialChromosome());
			}
			return kids;
		}
		
		public function get numberOfParentsRequired():uint {
			return _numberOfParentsRequired;
		}
		
		public function set numberOfParentsRequired(value:uint):void {
			_numberOfParentsRequired = value;
		}
	}
}