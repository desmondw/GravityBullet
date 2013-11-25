package
{
	import org.flixel.*;
	import flash.events.Event;
 
	public class Game extends FlxGame
	{
		public static const SCREEN_WIDTH:uint = 640;
		public static const SCREEN_HEIGHT:uint = 480;
		public static const ZOOM:uint = 1;
		public static const BG_COLOR:uint = 0xffaaaaaa;
		
		override public function Game(main:Main)
		{
			super(SCREEN_WIDTH / ZOOM, SCREEN_HEIGHT / ZOOM, PlayState, ZOOM);
			
			//TODO: disable debug for release
			forceDebugger = true;
		}
	}
}