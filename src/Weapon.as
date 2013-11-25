package  
{
	import flash.utils.Timer;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	import flash.utils.getTimer;
	
	public class Weapon extends FlxWeapon
	{
		public var enabled:Boolean = false;
		//public var width:uint = 0;
		//public var height:uint = 0;
		public var subWeapons:Array = new Array(0);
		
		//scaling
		private var scaleTimer:Timer;
		private var scaleLastCount:uint = 0;
		private var scale:Number = 1;
		
		//falling change
		public var fallingGravityY:int;
		public var fallingGravityX:int;
		public var normalGravityY:int;
		public var normalGravityX:int;
		
		override public function Weapon(name:String, parentRef:* = null, xVariable:String = "x", yVariable:String = "y") 
		{
			super(name, parentRef, xVariable, yVariable);
		}
		
		override public function update():void 
		{
			
			//scale bullets
			//if (scale != 1 && scaleTimer.currentCount > scaleLastCount)
			//{
				//scaleLastCount = scaleTimer.currentCount;
				//
				//handles pause behavior for timer
				//if (FlxG.paused)
					//scaleTimer.stop();
				//else
					//scaleTimer.start();
				//
				//group.setAll("scale", new FlxPoint(scale, scale));
			//}
			
			//falling changes
			//if (group != null)
			//{
				//group.setAll("yGravity", fallingGravityY);
				//group.setAll("xGravity", fallingGravityX);
			//}
			
			//falling changes
			if (group != null)
			{
				for (var i:int = 0; i < group.length; i++)
				{
					if (group.members[i] != null && group.members[i].falling)
					{
						group.members[i].yGravity = fallingGravityY;
						group.members[i].xGravity = fallingGravityX;
					}
					else
					{
						group.members[i].yGravity = normalGravityY;
						group.members[i].xGravity = normalGravityX;
					}
				}
			}
			
			//update sub weapons
			for (var i:int = 0; i < subWeapons.length; i++)
				subWeapons[i].update();
		}
		
		override public function setBulletGravity(xForce:int, yForce:int):void 
		{
			super.setBulletGravity(xForce, yForce);
			
			normalGravityY = yForce;
			normalGravityX = xForce;
			fallingGravityY = normalGravityY;
			fallingGravityX = normalGravityX;
		}
		
		override public function makeImageBullet(quantity:uint, image:Class, offsetX:int = 0, offsetY:int = 0, autoRotate:Boolean = false, rotations:uint = 16, frame:int = -1, antiAliasing:Boolean = false, autoBuffer:Boolean = false):Bullet 
		{
			var bullet:Bullet = super.makeImageBullet(quantity, image, offsetX, offsetY, autoRotate, rotations, frame, antiAliasing, autoBuffer);
			width = bullet.width;
			height = bullet.height;
			
			return bullet;
		}
		
		override public function makeAnimatedBullet(quantity:uint, imageSequence:Class, frameWidth:uint, frameHeight:uint, frames:Array, frameRate:uint, looped:Boolean, offsetX:int = 0, offsetY:int = 0):void 
		{
			super.makeAnimatedBullet(quantity, imageSequence, frameWidth, frameHeight, frames, frameRate, looped, offsetX, offsetY);
			width = frameWidth;
			height = frameHeight;
		}
		
		override public function fire():void 
		{
			if (enabled) //if the active weapon
			{
				//either fire the single weapon, or the multiple sub weapons
				if (subWeapons.length == 0) //single
				{
					super.fire();
				}
				else //multiple
				{
					//if the master fire rate is ready to fire, fire all weapons
					if (!(fireRate > 0 && (getTimer() < nextFire)))
					{
						for (var i:int = 0; i < subWeapons.length; i++)
							subWeapons[i].fire();
						
						//housekeeping for firing rate
						nextFire = getTimer() + fireRate;
					}
				}
				
				//play firing sound
				if (onFireSound != null)
					this.onFireSound.play();
			}
		}
		
		public function setScaling(scale:Number, ms:uint):void 
		{
			scaleTimer = new Timer(ms);
			scaleTimer.start();
			scaleLastCount = 0;

			this.scale = scale;
		}
	}
}