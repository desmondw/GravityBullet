package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	
	public class Gameplay 
	{
		//static variables
		public static var bulletBounds:FlxRect = new FlxRect( -Game.SCREEN_WIDTH * 9, 64, Game.SCREEN_WIDTH * 10, Game.SCREEN_HEIGHT);
		
		//classes
		private var player:Player;
		private var cloud:Cloud;
		private var background:Background;
		
		//groups
		public var group:FlxGroup = new FlxGroup();
		private var grp_entities:FlxGroup = new FlxGroup();
		
		public function Gameplay() 
		{
			//player
			player = new Player(Game.SCREEN_WIDTH / 2, Game.SCREEN_HEIGHT - 64);
			player.x -= player.width / 2; //changes based on graphic width
			
			//cloud
			cloud = new Cloud(0, 0);
			
			//background
			background = new Background(player.width);
			
			//groups
			grp_entities.add(background.group);
			grp_entities.add(cloud);
			grp_entities.add(player.group);
			grp_entities.add(player);
			grp_entities.add(player.grp_bullets);
			group.add(grp_entities);
		}
		
		public function update():void 
		{
			player.update();
			cloud.update();
			cloud.chasePlayer(player.getCenterX());
			background.update(player.x, player.y);
			
			detectCollisions();
		}
		
		private function detectCollisions():void 
		{
			FlxG.overlap(player, player.grp_bullets, bulletHitPlayer);
		}
		
		private function bulletHitPlayer(playerObject:FlxObject, bulletObject:FlxObject):void 
		{
			//make sure bullet isnt being recycled
			if ((bulletObject as Bullet).falling)
			{
				bulletObject.kill();
				
				player.damage++;
				player.sfx_hit.play();
				
				if (player.damage > 2)
					gameOver();
				else
					;//player.play("idle" + player.damage);
			}
		}
		
		public function gameOver():void
		{
			
		}
	}
}