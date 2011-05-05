package fxg2as3
{
	public class NamingTracker
	{
		protected var idPool:int = 0;
		
		public function NamingTracker()
		{
		}
		
		public function getNextId():int
		{
			return ++idPool;
		}
		
		public function getCurrentId():int
		{
			return idPool;
		}
	}
}