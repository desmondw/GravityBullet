package  
{
	import org.flixel.*;
	
	public class Background 
	{
		//group
		public var group:FlxGroup = new FlxGroup();
		
		//background
		private var parallax1:FlxSprite; //closest
		private var parallax2:FlxSprite; //mid-range
		private var parallax3:FlxSprite; //farthest
		
		//layer offset
		private var offset1:int = -Game.SCREEN_WIDTH;
		private var offset2:int = -(Game.SCREEN_WIDTH / 2);
		private var offset3:int = -(Game.SCREEN_WIDTH * 1.5 / 2 - Game.SCREEN_WIDTH / 2);
		
		//shifting degree for each layer
		private var shift1:Number;
		private var shift2:Number;
		private var shift3:Number;
		
		//player width
		private var playerWidth:int;
		
		public function Background(playerWidth:int) 
		{
			this.playerWidth = playerWidth;
			
			//closest
			parallax1 = new FlxSprite(offset1, 0, Assets.parallax1);
			shift1 = (parallax1.width - Game.SCREEN_WIDTH) / (Game.SCREEN_WIDTH - playerWidth);
			
			//mid-range
			parallax2 = new FlxSprite(offset2, 0, Assets.parallax2);
			shift2 = (parallax2.width - Game.SCREEN_WIDTH) / (Game.SCREEN_WIDTH - playerWidth);
			
			//farthest
			parallax3 = new FlxSprite(offset3, 0, Assets.parallax3);
			shift3 = (parallax3.width - Game.SCREEN_WIDTH) / (Game.SCREEN_WIDTH - playerWidth);
			
			//add to group
			group.add(parallax3);
			//group.add(parallax2);
			group.add(parallax1);
		}
		
		public function update(x:int, y:int):void
		{
			//var centeredX = x + playerWidth / 2;
			x = (x + playerWidth / 2) - Game.SCREEN_WIDTH / 2; //gives player position relative to screen center, with adjustment for player center
			
			parallax1.x = offset1 + x * shift1;// - x * shift1;
			parallax2.x = offset2 + x * shift2;// - x * shift2;
			parallax3.x = offset3 + x * shift3;// - x * shift3;
		}
	}
}