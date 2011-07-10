package galia.seeding
{
	import galia.core.ISeedingStrategy;
	import galia.procreation.ByteArrayRandomizedCreation;
	
	public class ByteArrayRandomizedCreationSeedingStrategy implements ISeedingStrategy
	{
		public var chromosomeSize:uint = 0;
		
		private var byteArrayRandomizedCreation:ByteArrayRandomizedCreation = new ByteArrayRandomizedCreation();
		
		public function ByteArrayRandomizedCreationSeedingStrategy(chromosomeSize:uint = 0) {
			this.chromosomeSize = chromosomeSize;
		}
		
		public function generateChromosomes(numberOfChromosomes:uint):Array {
			var outputChromosomes:Array = [];
			byteArrayRandomizedCreation.explicitChromosomeSize = chromosomeSize;
			for (var i:uint = 0; i < numberOfChromosomes; i++) {
				outputChromosomes.push(byteArrayRandomizedCreation.procreate(null)[0]);
			}
			return outputChromosomes;
		}
	}
}