package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	
	public class Player extends FlxSprite
	{
		//movement constants
		private const MAX_VELOCITY_COEFFICIENT:Number = 8;
		private const ACCELERATION_COEFFICIENT:Number = 4;
		private const ACCELERATION_JUMP_COEFFICIENT:Number = 1;
		private const ACCELERATION_FALL_COEFFICIENT:Number = 2;
		private const DRAG_COEFFICIENT:Number = 4;
		private const TURNAROUND_COEFFICIENT:Number = .65;
		private const SLOW_COEFFICIENT:Number = .5;
		
		//movement
		private var maxVelocityX:int;
		
		//private var visualWidth:int;
		//private var visualHeight:int;
		
		//group
		public var group:FlxGroup = new FlxGroup();
		public var grp_bullets:FlxGroup = new FlxGroup();
		public var grp_weapons:FlxGroup = new FlxGroup();
		public var grp_dust:FlxGroup = new FlxGroup();
		
		//weapons
		public var weapons:Array = new Array(10);
		public var weaponsGraphics:Array = new Array(10);
		
		//sounds
		public var sfx_hit:FlxSound = new FlxSound();
		
		//dust
		private var dust:FlxSprite;
		
		//status
		public var damage:uint = 0;
		public var activeWeapon:uint = 0;
		
		override public function Player(x:uint, y:uint)
		{
			super(x, y);
			
			//load graphics and animations
			loadGraphic(Assets.player, true, false, 64, 32);
			addAnimation("idle", new Array(0, 0), 4);
			addAnimation("runLeft", new Array(1, 1), 4);
			addAnimation("runRight", new Array(2, 2), 4);
			play("idle");
			
			//dust
			dust = new FlxSprite(0, 0);
			dust.loadGraphic(Assets.dust, true, true, 64, 32);
			dust.addAnimation("fast", new Array(0, 1, 2, 3, 4, 5, 6, 5, 4, 3, 2, 1), 24);
			dust.addAnimation("slow", new Array(0, 1, 2, 3, 4, 3, 2, 1), 16);
			dust.play("fast");
			dust.visible = true;
			grp_dust.add(dust);
			
			//load sounds
			sfx_hit.loadEmbedded(Assets.player_hit);
			
			//set bounding box
			var visHeight = height;
			height *= .7;
			width *= .7;
			centerOffsets();
			offset.y = visHeight * .3;
			
			//set movement physics
			maxVelocity.x = width * MAX_VELOCITY_COEFFICIENT;
			maxVelocity.y = height * MAX_VELOCITY_COEFFICIENT;
			drag.x = maxVelocity.x * DRAG_COEFFICIENT;
			drag.y = maxVelocity.y * DRAG_COEFFICIENT;
			maxVelocityX = maxVelocity.x;
			
			//load weapons
			initializeWeapons();
			
			//groups
			group.add(grp_dust);
			group.add(grp_weapons);
		}
		
		private function initializeWeapons():void 
		{
			var sound:FlxSound = new FlxSound();
			var weapon:Weapon;
			var sprite:FlxSprite;
			
			//{ Weapon 0 - normal / easy
			//bullets
			weapon = new Weapon("weapon0", this, "x", "y");
			weapon.makeImageBullet(50, Assets.bullet0, 0, 0);
			weapon.setBulletOffset(width / 2 - weapon.width / 2, -(weapon.height));
			weapon.setBulletDirection(FlxWeapon.BULLET_UP, 250);
			weapon.setFireRate(300);
			weapon.setBulletGravity(0, 100);
			weapon.setBulletBounds(Gameplay.bulletBounds);
			
			//sound
			sound.loadEmbedded(Assets.weapon0Sound);
			//weapon.onFireSound = sound;
			weapons[0] = weapon;
			
			//weapon graphic
			sprite = new FlxSprite(x, y);
			sprite.loadGraphic(Assets.weapon0, true);
			sprite.addAnimation("idle", new Array(1, 1), 8);
			sprite.play("idle");
			weaponsGraphics[0] = sprite;
			weaponsGraphics[0].visible = false;
			//}
			
			//{ Weapon 1 - shotgun
			//bullets
			weapon = new Weapon("weapon1", this, "x", "y");
			weapon.setFireRate(400);
			weapon.subWeapons = new Array(5);
			
			//sub0 - up-left
			weapon.subWeapons[0] = new Weapon("sub0", this, "x", "y");
			weapon.subWeapons[0].makeImageBullet(20, Assets.bullet1, 0, 0);
			weapon.subWeapons[0].setBulletOffset(width / 2 - weapon.subWeapons[0].width / 2, -(weapon.subWeapons[0].height));
			weapon.subWeapons[0].setBulletDirection(FlxWeapon.BULLET_UP - 12, 995);
			weapon.subWeapons[0].setBulletGravity(0, 1500);
			weapon.subWeapons[0].enabled = true;
			
			//sub1 - up-up-left
			weapon.subWeapons[1] = new Weapon("sub1", this, "x", "y");
			weapon.subWeapons[1].makeImageBullet(20, Assets.bullet1, 0, 0);
			weapon.subWeapons[1].setBulletOffset(width / 2 - weapon.subWeapons[1].width / 2, -(weapon.subWeapons[1].height));
			weapon.subWeapons[1].setBulletDirection(FlxWeapon.BULLET_UP - 6, 995);
			weapon.subWeapons[1].setBulletGravity(0, 1500);
			weapon.subWeapons[1].enabled = true;
			
			//sub2 - up
			weapon.subWeapons[2] = new Weapon("sub2", this, "x", "y");
			weapon.subWeapons[2].makeImageBullet(20, Assets.bullet1, 0, 0);
			weapon.subWeapons[2].setBulletOffset(width / 2 - weapon.subWeapons[2].width / 2, -(weapon.subWeapons[2].height));
			weapon.subWeapons[2].setBulletDirection(FlxWeapon.BULLET_UP + 0, 995);
			weapon.subWeapons[2].setBulletGravity(0, 1500);
			weapon.subWeapons[2].enabled = true;
			
			//sub3 - up-up-right
			weapon.subWeapons[3] = new Weapon("sub3", this, "x", "y");
			weapon.subWeapons[3].makeImageBullet(20, Assets.bullet1, 0, 0);
			weapon.subWeapons[3].setBulletOffset(width / 2 - weapon.subWeapons[3].width / 2, -(weapon.subWeapons[3].height));
			weapon.subWeapons[3].setBulletDirection(FlxWeapon.BULLET_UP + 6, 995);
			weapon.subWeapons[3].setBulletGravity(0, 1500);
			weapon.subWeapons[3].enabled = true;
			
			//sub4 - up-right
			weapon.subWeapons[4] = new Weapon("sub4", this, "x", "y");
			weapon.subWeapons[4].makeImageBullet(20, Assets.bullet1, 0, 0);
			weapon.subWeapons[4].setBulletOffset(width / 2 - weapon.subWeapons[4].width / 2, -(weapon.subWeapons[4].height));
			weapon.subWeapons[4].setBulletDirection(FlxWeapon.BULLET_UP + 12, 995);
			weapon.subWeapons[4].setBulletGravity(0, 1500);
			weapon.subWeapons[4].enabled = true;
			
			//sound
			sound.loadEmbedded(Assets.weapon1Sound);
			//weapon.onFireSound = sound;
			weapons[1] = weapon;
			
			//weapon graphic
			sprite = new FlxSprite(x, y);
			sprite.loadGraphic(Assets.weapon1, true);
			sprite.addAnimation("idle", new Array(1, 1), 8);
			sprite.play("idle");
			weaponsGraphics[1] = sprite;
			weaponsGraphics[1].visible = false;
			//}
			
			//{ Weapon 2 - flower spread
			//bullets
			weapon = new Weapon("weapon2", this, "x", "y");
			weapon.setFireRate(1100);
			weapon.subWeapons = new Array(7);
			
			//sub0 - left
			weapon.subWeapons[0] = new Weapon("sub0", this, "x", "y");
			weapon.subWeapons[0].makeAnimatedBullet(20, Assets.bullet2, 32, 32, new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1), 10, true);
			weapon.subWeapons[0].setBulletOffset(width / 2 - weapon.subWeapons[0].width / 2, -(weapon.subWeapons[0].height));
			weapon.subWeapons[0].setBulletDirection(FlxWeapon.BULLET_UP - 12.45, 250);
			weapon.subWeapons[0].setBulletGravity(0, 100);
			weapon.subWeapons[0].enabled = true;
			
			//sub1
			weapon.subWeapons[1] = new Weapon("sub1", this, "x", "y");
			weapon.subWeapons[1].makeAnimatedBullet(20, Assets.bullet2, 32, 32, new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1), 10, true);
			weapon.subWeapons[1].setBulletOffset(width / 2 - weapon.subWeapons[1].width / 2, -(weapon.subWeapons[1].height));
			weapon.subWeapons[1].setBulletDirection(FlxWeapon.BULLET_UP - 8.3, 250);
			weapon.subWeapons[1].setBulletGravity(0, 100);
			weapon.subWeapons[1].enabled = true;
			
			//sub2
			weapon.subWeapons[2] = new Weapon("sub2", this, "x", "y");
			weapon.subWeapons[2].makeAnimatedBullet(20, Assets.bullet2, 32, 32, new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1), 10, true);
			weapon.subWeapons[2].setBulletOffset(width / 2 - weapon.subWeapons[2].width / 2, -(weapon.subWeapons[2].height));
			weapon.subWeapons[2].setBulletDirection(FlxWeapon.BULLET_UP - 4.15, 250);
			weapon.subWeapons[2].setBulletGravity(0, 100);
			weapon.subWeapons[2].enabled = true;
			
			//sub3 - mid
			weapon.subWeapons[3] = new Weapon("sub3", this, "x", "y");
			weapon.subWeapons[3].makeAnimatedBullet(20, Assets.bullet2, 32, 32, new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1), 10, true);
			weapon.subWeapons[3].setBulletOffset(width / 2 - weapon.subWeapons[3].width / 2, -(weapon.subWeapons[3].height));
			weapon.subWeapons[3].setBulletDirection(FlxWeapon.BULLET_UP + 0, 250);
			weapon.subWeapons[3].setBulletGravity(0, 100);
			weapon.subWeapons[3].enabled = true;
			
			//sub4
			weapon.subWeapons[4] = new Weapon("sub4", this, "x", "y");
			weapon.subWeapons[4].makeAnimatedBullet(20, Assets.bullet2, 32, 32, new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1), 10, true);
			weapon.subWeapons[4].setBulletOffset(width / 2 - weapon.subWeapons[4].width / 2, -(weapon.subWeapons[4].height));
			weapon.subWeapons[4].setBulletDirection(FlxWeapon.BULLET_UP + 4.15, 250);
			weapon.subWeapons[4].setBulletGravity(0, 100);
			weapon.subWeapons[4].enabled = true;
			
			//sub5
			weapon.subWeapons[5] = new Weapon("sub5", this, "x", "y");
			weapon.subWeapons[5].makeAnimatedBullet(20, Assets.bullet2, 32, 32, new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1), 10, true);
			weapon.subWeapons[5].setBulletOffset(width / 2 - weapon.subWeapons[5].width / 2, -(weapon.subWeapons[5].height));
			weapon.subWeapons[5].setBulletDirection(FlxWeapon.BULLET_UP + 8.3, 250);
			weapon.subWeapons[5].setBulletGravity(0, 100);
			weapon.subWeapons[5].enabled = true;
			
			//sub6 - right
			weapon.subWeapons[6] = new Weapon("sub6", this, "x", "y");
			weapon.subWeapons[6].makeAnimatedBullet(20, Assets.bullet2, 32, 32, new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1), 10, true);
			weapon.subWeapons[6].setBulletOffset(width / 2 - weapon.subWeapons[6].width / 2, -(weapon.subWeapons[6].height));
			weapon.subWeapons[6].setBulletDirection(FlxWeapon.BULLET_UP + 12.45, 250);
			weapon.subWeapons[6].setBulletGravity(0, 100);
			weapon.subWeapons[6].enabled = true;
			
			//sound
			sound.loadEmbedded(Assets.weapon2Sound);
			//weapon.onFireSound = sound;
			weapons[2] = weapon;
			
			//weapon graphic
			sprite = new FlxSprite(x, y);
			sprite.loadGraphic(Assets.weapon2, true);
			sprite.addAnimation("idle", new Array(1, 1), 8);
			sprite.play("idle");
			weaponsGraphics[2] = sprite;
			weaponsGraphics[2].visible = false;
			//}
			
			//{ Weapon 3 - jumping jacks / xGravity
			//bullets
			weapon = new Weapon("weapon3", this, "x", "y");
			weapon.setFireRate(600);
			weapon.subWeapons = new Array(2);
			
			//sub0 - left
			weapon.subWeapons[0] = new Weapon("sub0", this, "x", "y");
			weapon.subWeapons[0].makeImageBullet(20, Assets.bullet3, 0, 0);
			weapon.subWeapons[0].setBulletOffset(width / 2 - weapon.subWeapons[0].width / 2, -(weapon.subWeapons[0].height));
			weapon.subWeapons[0].setBulletDirection(FlxWeapon.BULLET_UP - 20, 800);
			weapon.subWeapons[0].setBulletGravity(500, 1000);
			weapon.subWeapons[0].enabled = true;
			
			//sub1
			weapon.subWeapons[1] = new Weapon("sub1", this, "x", "y");
			weapon.subWeapons[1].makeImageBullet(20, Assets.bullet3, 0, 0);
			weapon.subWeapons[1].setBulletOffset(width / 2 - weapon.subWeapons[1].width / 2, -(weapon.subWeapons[1].height));
			weapon.subWeapons[1].setBulletDirection(FlxWeapon.BULLET_UP - 2, 800);
			weapon.subWeapons[1].setBulletGravity(100, 1000);
			weapon.subWeapons[1].enabled = true;
			
			//sub2 - middle
			weapon.subWeapons[2] = new Weapon("sub2", this, "x", "y");
			weapon.subWeapons[2].makeImageBullet(20, Assets.bullet3, 0, 0);
			weapon.subWeapons[2].setBulletOffset(width / 2 - weapon.subWeapons[2].width / 2, -(weapon.subWeapons[2].height));
			weapon.subWeapons[2].setBulletDirection(FlxWeapon.BULLET_UP + 0, 810);
			weapon.subWeapons[2].setBulletGravity(0, 1000);
			weapon.subWeapons[2].enabled = true;
			
			//sub3
			weapon.subWeapons[3] = new Weapon("sub3", this, "x", "y");
			weapon.subWeapons[3].makeImageBullet(20, Assets.bullet3, 0, 0);
			weapon.subWeapons[3].setBulletOffset(width / 2 - weapon.subWeapons[3].width / 2, -(weapon.subWeapons[3].height));
			weapon.subWeapons[3].setBulletDirection(FlxWeapon.BULLET_UP + 2, 800);
			weapon.subWeapons[3].setBulletGravity(-100, 1000);
			weapon.subWeapons[3].enabled = true;
			
			//sub4 - right
			weapon.subWeapons[4] = new Weapon("sub4", this, "x", "y");
			weapon.subWeapons[4].makeImageBullet(20, Assets.bullet3, 0, 0);
			weapon.subWeapons[4].setBulletOffset(width / 2 - weapon.subWeapons[4].width / 2, -(weapon.subWeapons[4].height));
			weapon.subWeapons[4].setBulletDirection(FlxWeapon.BULLET_UP + 20, 800);
			weapon.subWeapons[4].setBulletGravity(-500, 1000);
			weapon.subWeapons[4].enabled = true;
			
			//sound
			sound.loadEmbedded(Assets.weapon3Sound);
			//weapon.onFireSound = sound;
			weapons[3] = weapon;
			
			//weapon graphic
			sprite = new FlxSprite(x, y);
			sprite.loadGraphic(Assets.weapon3, true);
			sprite.addAnimation("idle", new Array(1, 1), 8);
			sprite.play("idle");
			weaponsGraphics[3] = sprite;
			weaponsGraphics[3].visible = false;
			//}
			
			//TODO: BUG: Fix bullets sometimes going up half the height they should
			//{ Weapon 4 - giant bullet
			//bullets
			weapon = new Weapon("weapon4", this, "x", "y");
			weapon.makeImageBullet(20, Assets.bullet4, 0, 0);
			weapon.setBulletOffset(width / 2 - weapon.width / 2, -(weapon.height));
			weapon.setBulletDirection(FlxWeapon.BULLET_UP, 135);
			weapon.setFireRate(1000);
			weapon.setBulletGravity(0, 100);
			weapon.setBulletBounds(Gameplay.bulletBounds);
			weapon.fallingGravityY = 3000;
			
			//sound
			sound.loadEmbedded(Assets.weapon4Sound);
			//weapon.onFireSound = sound;
			weapons[4] = weapon;
			
			//weapon graphic
			sprite = new FlxSprite(x, y);
			sprite.loadGraphic(Assets.weapon4, true);
			sprite.addAnimation("idle", new Array(1, 1), 8);
			sprite.play("idle");
			weaponsGraphics[4] = sprite;
			weaponsGraphics[4].visible = false;
			//}
			
			//{ Weapon 5
			//bullets
			weapon = new Weapon("weapon5", this, "x", "y");
			weapon.makeImageBullet(20, Assets.bullet5, 0, 0);
			weapon.setBulletOffset(width / 2 - weapon.width / 2, -(weapon.height));
			weapon.setBulletDirection(FlxWeapon.BULLET_UP, 250);
			weapon.setFireRate(300);
			weapon.setBulletGravity(0, 100);
			weapon.setBulletBounds(Gameplay.bulletBounds);
			
			//sound
			sound.loadEmbedded(Assets.weapon5Sound);
			//weapon.onFireSound = sound;
			weapons[5] = weapon;
			
			//weapon graphic
			sprite = new FlxSprite(x, y);
			sprite.loadGraphic(Assets.weapon5, true);
			sprite.addAnimation("idle", new Array(1, 1), 8);
			sprite.play("idle");
			weaponsGraphics[5] = sprite;
			weaponsGraphics[5].visible = false;
			//}
			
			//{ Weapon 6
			//bullets
			weapon = new Weapon("weapon6", this, "x", "y");
			weapon.makeImageBullet(20, Assets.bullet6, 0, 0);
			weapon.setBulletOffset(width / 2 - weapon.width / 2, -(weapon.height));
			weapon.setBulletDirection(FlxWeapon.BULLET_UP, 250);
			weapon.setFireRate(300);
			weapon.setBulletGravity(0, 100);
			weapon.setBulletBounds(Gameplay.bulletBounds);
			
			//sound
			sound.loadEmbedded(Assets.weapon6Sound);
			//weapon.onFireSound = sound;
			weapons[6] = weapon;
			
			//weapon graphic
			sprite = new FlxSprite(x, y);
			sprite.loadGraphic(Assets.weapon6, true);
			sprite.addAnimation("idle", new Array(1, 1), 8);
			sprite.play("idle");
			weaponsGraphics[6] = sprite;
			weaponsGraphics[6].visible = false;
			//}
			
			//{ Weapon 7
			//bullets
			weapon = new Weapon("weapon7", this, "x", "y");
			weapon.makeImageBullet(20, Assets.bullet7, 0, 0);
			weapon.setBulletOffset(width / 2 - weapon.width / 2, -(weapon.height));
			weapon.setBulletDirection(FlxWeapon.BULLET_UP, 250);
			weapon.setFireRate(300);
			weapon.setBulletGravity(0, 100);
			weapon.setBulletBounds(Gameplay.bulletBounds);
			
			//sound
			sound.loadEmbedded(Assets.weapon7Sound);
			//weapon.onFireSound = sound;
			weapons[7] = weapon;
			
			//weapon graphic
			sprite = new FlxSprite(x, y);
			sprite.loadGraphic(Assets.weapon7, true);
			sprite.addAnimation("idle", new Array(1, 1), 8);
			sprite.play("idle");
			weaponsGraphics[7] = sprite;
			weaponsGraphics[7].visible = false;
			//}
			
			//{ Weapon 8
			//bullets
			weapon = new Weapon("weapon8", this, "x", "y");
			weapon.makeImageBullet(20, Assets.bullet8, 0, 0);
			weapon.setBulletOffset(width / 2 - weapon.width / 2, -(weapon.height));
			weapon.setBulletDirection(FlxWeapon.BULLET_UP, 250);
			weapon.setFireRate(300);
			weapon.setBulletGravity(0, 100);
			weapon.setBulletBounds(Gameplay.bulletBounds);
			
			//sound
			sound.loadEmbedded(Assets.weapon8Sound);
			//weapon.onFireSound = sound;
			weapons[8] = weapon;
			
			//weapon graphic
			sprite = new FlxSprite(x, y);
			sprite.loadGraphic(Assets.weapon8, true);
			sprite.addAnimation("idle", new Array(1, 1), 8);
			sprite.play("idle");
			weaponsGraphics[8] = sprite;
			weaponsGraphics[8].visible = false;
			//}
			
			//{ Weapon 9
			//bullets
			weapon = new Weapon("weapon9", this, "x", "y");
			weapon.makeImageBullet(20, Assets.bullet9, 0, 0);
			weapon.setBulletOffset(width / 2 - weapon.width / 2, -(weapon.height));
			weapon.setBulletDirection(FlxWeapon.BULLET_UP, 250);
			weapon.setFireRate(300);
			weapon.setBulletGravity(0, 100);
			weapon.setBulletBounds(Gameplay.bulletBounds);
			
			//sound
			sound.loadEmbedded(Assets.weapon9Sound);
			//weapon.onFireSound = sound;
			weapons[9] = weapon;
			
			//weapon graphic
			sprite = new FlxSprite(x, y);
			sprite.loadGraphic(Assets.weapon9, true);
			sprite.addAnimation("idle", new Array(1, 1), 8);
			sprite.play("idle");
			weaponsGraphics[9] = sprite;
			weaponsGraphics[9].visible = false;
			//}
			
			//add bullets to group
			for (var i:int = 0; i < weapons.length; i++)
			{
				if (weapons[i].subWeapons.length > 0)
				{
					for (var j:int = 0; j < weapons[i].subWeapons.length; j++)
						grp_bullets.add(weapons[i].subWeapons[j].group);
				}
				else
					grp_bullets.add(weapons[i].group);
			}
			
			//add weapon graphics to group
			for (var i:int = 0; i < weaponsGraphics.length; i++)
				grp_weapons.add(weaponsGraphics[i]);
			
			//changeWeapon(0); //TODO: enable for release
			changeWeapon(2); //TODO: remove test
		}
		
		override public function update():void 
		{
			debugWeapons(); //TODO: comment out for release
			updateMovement();
			for (var i:int = 0; i < weapons.length; i++)
				weapons[i].update();
			updateWeaponsGraphics();
			fire();
		}
		
		private function debugWeapons():void 
		{
			if (FlxG.keys.Q)
				changeWeapon(0);
			if (FlxG.keys.ONE)
				changeWeapon(1);
			if (FlxG.keys.TWO)
				changeWeapon(2);
			if (FlxG.keys.THREE)
				changeWeapon(3);
			if (FlxG.keys.FOUR)
				changeWeapon(4);
			if (FlxG.keys.FIVE)
				changeWeapon(5);
			if (FlxG.keys.SIX)
				changeWeapon(6);
			if (FlxG.keys.SEVEN)
				changeWeapon(7);
			if (FlxG.keys.EIGHT)
				changeWeapon(8);
			if (FlxG.keys.NINE)
				changeWeapon(9);
		}
		
		private function updateMovement():void 
		{
			//update null values
			acceleration.x = 0;
			acceleration.y = 0;
			maxVelocity.x = maxVelocityX;
			play("idle");
			
			//dust stuff
			dust.visible = false;
			
			//checks for slowing
			if (FlxG.keys.SHIFT)
			{
				maxVelocity.x *= SLOW_COEFFICIENT;
				dust.play("slow");
			}
			else
				dust.play("fast");
			
			//dont execute movement if player deadlocks it with both keys
			if (!(FlxG.keys.A && FlxG.keys.D) && !(FlxG.keys.LEFT && FlxG.keys.RIGHT))
			{
				if (FlxG.keys.A || FlxG.keys.LEFT)
					moveLeft();
				if (FlxG.keys.D || FlxG.keys.RIGHT)
					moveRight();
			}
			
			//keeps player on screen
			if (x < 0)
			{
				x = 0;
				acceleration.x = 0;
				velocity.x = 0;
			}
			else if (x > Game.SCREEN_WIDTH - width)
			{
				x = Game.SCREEN_WIDTH - width;
				acceleration.x = 0;
				velocity.x = 0;
			}
		}
		
		private function updateWeaponsGraphics():void 
		{
			weaponsGraphics[0].x = x + width / 2 - weaponsGraphics[0].width / 2;
			weaponsGraphics[0].y = y - weaponsGraphics[0].height;
			
			weaponsGraphics[1].x = x + width / 2 - weaponsGraphics[1].width / 2;
			weaponsGraphics[1].y = y - weaponsGraphics[1].height;
			
			weaponsGraphics[2].x = x + width / 2 - weaponsGraphics[2].width / 2;
			weaponsGraphics[2].y = y - weaponsGraphics[2].height;
			
			weaponsGraphics[3].x = x + width / 2 - weaponsGraphics[3].width / 2;
			weaponsGraphics[3].y = y - weaponsGraphics[3].height;
			
			weaponsGraphics[4].x = x + width / 2 - weaponsGraphics[4].width / 2;
			weaponsGraphics[4].y = y - weaponsGraphics[4].height;
			
			weaponsGraphics[5].x = x + width / 2 - weaponsGraphics[5].width / 2;
			weaponsGraphics[5].y = y - weaponsGraphics[5].height;
			
			weaponsGraphics[6].x = x + width / 2 - weaponsGraphics[6].width / 2;
			weaponsGraphics[6].y = y - weaponsGraphics[6].height;
			
			weaponsGraphics[7].x = x + width / 2 - weaponsGraphics[7].width / 2;
			weaponsGraphics[7].y = y - weaponsGraphics[7].height;
			
			weaponsGraphics[8].x = x + width / 2 - weaponsGraphics[8].width / 2;
			weaponsGraphics[8].y = y - weaponsGraphics[8].height;
			
			weaponsGraphics[9].x = x + width / 2 - weaponsGraphics[9].width / 2;
			weaponsGraphics[9].y = y - weaponsGraphics[9].height;
		}
		
		public function moveLeft():void 
		{
			if (velocity.x > 0)
				velocity.x *= TURNAROUND_COEFFICIENT;
			acceleration.x = -maxVelocity.x * ACCELERATION_COEFFICIENT;
			play("runLeft");
			
			dust.visible = true;
			dust.facing = LEFT;
			dust.x = x + width;
			dust.y = y + height - dust.height;
		}
		
		public function moveRight():void 
		{
			if (velocity.x < 0)
				velocity.x *= TURNAROUND_COEFFICIENT;
			acceleration.x = maxVelocity.x * ACCELERATION_COEFFICIENT;
			play("runRight");
			
			dust.visible = true;
			dust.facing = RIGHT;
			dust.x = x - dust.width;
			dust.y = y + height - dust.height;
		}
		
		public function moveUp():void 
		{
			acceleration.y = -maxVelocity.y * ACCELERATION_COEFFICIENT;
		}
		
		public function moveDown():void 
		{
			acceleration.y = maxVelocity.y * ACCELERATION_COEFFICIENT;
		}
		
		public function jump():void 
		{
			velocity.y = -maxVelocity.y * ACCELERATION_JUMP_COEFFICIENT;
		}
		
		public function fall():void 
		{
			acceleration.y = maxVelocity.y * ACCELERATION_FALL_COEFFICIENT;
		}
		
		public function fire():void 
		{
			for (var i:int = 0; i < weapons.length; i++)
				weapons[i].fire();
		}
		
		public function changeWeapon(index:int):void
		{
			weapons[activeWeapon].enabled = false;
			weaponsGraphics[activeWeapon].visible = false;
			
			activeWeapon = index;
			
			weapons[activeWeapon].enabled = true;
			weaponsGraphics[activeWeapon].visible = true;
		}
		
		public function getCenterX():int 
		{
			return x + width / 2;
		}
	}
}