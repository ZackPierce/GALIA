package galia.procreation
{
	import galia.base.ByteArrayChromosome;
	import galia.core.IProcreationOperator;
	import galia.core.IRandomNumberGenerator;
	import galia.math.MathRandomNumberGenerator;
	
	public class ByteArrayRandomizedCreation implements IProcreationOperator
	{
		private var _explicitChromosomeSize:uint;
		private var isExplicitChromosomeSizeSet:Boolean = false;
		
		public var randomNumberGenerator:IRandomNumberGenerator = new MathRandomNumberGenerator();
		
		public function ByteArrayRandomizedCreation() {
		}
		
		public function get explicitChromosomeSize():uint {
			return _explicitChromosomeSize;
		}
		
		public function set explicitChromosomeSize(value:uint):void {
			_explicitChromosomeSize = value;
			isExplicitChromosomeSizeSet = true;
		} 
		
		/**
		 * @inheritDoc
		 * Always produces at least one ByteArrayChromosome.
		 * If explicitChromosomeSize has been set, all output chromosomes will have that length.
		 * Otherwise, each output chromosome will have the same length as the parent chromosome
		 * at the equivalent position in the parentChromosomes input array index.
		 */
		public function procreate(parentChromosomes:Array):Array {
			var numberOfParentChromosomes:int = parentChromosomes ? parentChromosomes.length : 0;
			var fallbackChromosomeSize:uint = _explicitChromosomeSize;
			var numberOfOutputChromosomes:int = numberOfParentChromosomes > 1 ? numberOfParentChromosomes : 1;
			var outputChromosomes:Array = [];
			for (var i:int = 0; i < numberOfOutputChromosomes; i++) {
				var currentChromosomeTargetSize:uint = fallbackChromosomeSize;
				if (!isExplicitChromosomeSizeSet && i < numberOfParentChromosomes) {
					currentChromosomeTargetSize = (parentChromosomes[i] as ByteArrayChromosome).length;
				}
				var byteArrayChromosome:ByteArrayChromosome = new ByteArrayChromosome();
				for (var j:uint = 0; j < currentChromosomeTargetSize; j++) {
					byteArrayChromosome.writeByte(randomNumberGenerator.integer(-128, 128)); // Waste of random bits, but less size-checking
				}
				byteArrayChromosome.position = 0;
				outputChromosomes.push(byteArrayChromosome);
			}
			return outputChromosomes;
		}
		
		public function get numberOfParentsRequired():uint {
			return 1; // Requires one parent in order to inspect it to determine desired chromosome size
		}
	}
}