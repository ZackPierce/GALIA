package galia.seeding
{
	import galia.core.ISeedingStrategy;
	
	/** 
	 * An ISeedingStrategy implementation that produces seed chromosomes 
	 * drawn from an external Array of pre-made IChromosome objects.
	 */
	public class ExternalSourceSeedingStrategy implements ISeedingStrategy
	{
		/** An Array of objects that implement IChromosome used by the generateChromosomes method. */
		public var chromosomeSource:Array; // of type IChromosome
		
		private var drawIndex:uint = 0;
		
		public function ExternalSourceSeedingStrategy(chromosomeSource:Array = null) {
			this.chromosomeSource = chromosomeSource;
		}
		
		/**
		 * @inheritDoc
		 */
		public function generateChromosomes(numberOfChromosomes:uint):Array {
			if (!chromosomeSource) {
				return [];
			}
			var sourceLength:uint = chromosomeSource.length;
			if (sourceLength == 0 || numberOfChromosomes == 0) {
				return [];
			}
			var outputChromosomes:Array = [];
			
			while (outputChromosomes.length < numberOfChromosomes) {
				if (drawIndex >= sourceLength) {
					drawIndex = 0;
				}
				outputChromosomes.push(chromosomeSource[drawIndex]);
				drawIndex++;
			}
			return outputChromosomes;
		}
	}
}