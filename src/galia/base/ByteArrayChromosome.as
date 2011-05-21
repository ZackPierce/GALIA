package galia.base
{
	import flash.utils.ByteArray;
	
	import galia.core.IChromosome;
	
	public class ByteArrayChromosome extends ByteArray implements IChromosome
	{
		public function ByteArrayChromosome(source:ByteArray = null)
		{
			super();
			if (source) {
				this.writeBytes(source);
				this.position = 0;
			}
		}
	}
}