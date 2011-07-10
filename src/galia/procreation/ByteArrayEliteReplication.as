package galia.procreation
{
	import galia.base.ByteArrayChromosome;
	import galia.core.IProcreationOperator;
	
	public class ByteArrayEliteReplication implements IProcreationOperator
	{
		public function ByteArrayEliteReplication() {
		}
		
		public function procreate(parentChromosomes:Array):Array {
			if (!parentChromosomes || parentChromosomes.length < numberOfParentsRequired) {
				return [];
			}
			var children:Array = [];
			for each (var parentChromosome:ByteArrayChromosome in parentChromosomes) {
				children.push(new ByteArrayChromosome(parentChromosome));
			}
			return children;
		}
		
		public function get numberOfParentsRequired():uint {
			return 1;
		}
	}
}