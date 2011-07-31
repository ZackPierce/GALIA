package galia.procreation
{
	import galia.base.ByteArrayChromosome;
	import galia.core.IProcreationOperator;
	import galia.core.IRandomNumberGenerator;
	import galia.math.MathRandomNumberGenerator;
	
	public class ByteArrayPointMutation implements IProcreationOperator
	{
		private var _mutationRate:Number = 0;
		
		public var randomNumberGenerator:IRandomNumberGenerator = new MathRandomNumberGenerator();
		
		public function ByteArrayPointMutation(mutationRate:Number = 0) {
			this.mutationRate = mutationRate;
		}
		
		public function procreate(parentChromosomes:Array):Array {
			if (!parentChromosomes || parentChromosomes.length < numberOfParentsRequired) {
				return [];
			}
			var children:Array = [];
			for each (var parent:ByteArrayChromosome in parentChromosomes) {
				var kid:ByteArrayChromosome = new ByteArrayChromosome(parent);
				var chromosomeLength:uint = kid.length;
				for (var i:int = 0; i < chromosomeLength; i++) {
					var shouldMutate:Boolean = randomNumberGenerator.random() < mutationRate;
					if (shouldMutate) {
						kid.position = i;
						kid.writeByte(randomNumberGenerator.integer(-127, 128));
					}
				}
				kid.position = 0;
				children.push(kid);
			}
			
			return children;
		}
		
		public function get numberOfParentsRequired():uint {
			return 1;
		}
		
		/** A Number between 0 and 1.0 indicating the fraction of the chromosome that should be mutated */ 
		public function get mutationRate():Number {
			return _mutationRate;
		}
		
		public function set mutationRate(value:Number):void {
			_mutationRate = value;
		}
	}
}