package  
{
	import org.flixel.*;
	
	public class GUI 
	{
		public static var group:FlxGroup = new FlxGroup();
		public static var border:FlxSprite;
		public static var border2:FlxSprite;
		
		public static function create():void 
		{
			border = new FlxSprite();
			border.makeGraphic(100, Game.SCREEN_HEIGHT, 0xff000000);
			
			border2 = new FlxSprite(Game.SCREEN_WIDTH - 100);
			border2.makeGraphic(100, Game.SCREEN_HEIGHT, 0xff000000);
			
			//group.add(border);
			//group.add(border2);
		}
		
		public static function update():void 
		{
			
		}
	}
}