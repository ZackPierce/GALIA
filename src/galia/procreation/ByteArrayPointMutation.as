package galia.procreation
{
	import com.gskinner.utils.Rndm;
	
	import galia.base.ByteArrayChromosome;
	import galia.core.IProcreationOperator;
	
	public class ByteArrayPointMutation implements IProcreationOperator
	{
		private var _mutationRate:Number = 0;
		
		protected var randomNumberGenerator:Rndm = new Rndm(Math.random()*uint.MAX_VALUE);
		
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
		
		public function get mutationRate():Number {
			return _mutationRate;
		}
		
		public function set mutationRate(value:Number):void {
			_mutationRate = value;
		}
		
		public function get seed():uint {
			return randomNumberGenerator.seed;
		}
		
		public function set seed(value:uint):void {
			randomNumberGenerator.seed = value;
		}
	}
}