package  
{
	import org.flixel.*;
	
	public class Cloud extends FlxSprite
	{
		//constants
		private const VELOCITY_COEFFICIENT:Number = 1;
		private const ACCELERATION_COEFFICIENT:int = 4;
		private const ACCELERATION_JUMP_COEFFICIENT:int = 1;
		private const ACCELERATION_FALL_COEFFICIENT:int = 2;
		private const DRAG_COEFFICIENT:int = 4;
		
		override public function Cloud(x:uint, y:uint)
		{
			super(x, y);
			
			loadGraphic(Assets.cloud, true, false, 192, 64);
			addAnimation("idle", new Array(0, 0), 8);
			play("idle");
			
			//set movement physics
			maxVelocity.x = width * VELOCITY_COEFFICIENT;
			maxVelocity.y = height * VELOCITY_COEFFICIENT;
			drag.x = maxVelocity.x * DRAG_COEFFICIENT;
			drag.y = maxVelocity.y * DRAG_COEFFICIENT;
			acceleration.x = 0;
			acceleration.y = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
		}
		
		public function chasePlayer(playerX:int):void 
		{
			//x = playerX;
			if (playerX > x + width / 2)
				acceleration.x = maxVelocity.x * ACCELERATION_COEFFICIENT;
			else if (playerX < x + width / 2)
				acceleration.x = -maxVelocity.x * ACCELERATION_COEFFICIENT;
		}
	}
}