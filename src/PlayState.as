package  
{
	import org.flixel.*;
	import flash.ui.Mouse;
	
	public class PlayState extends FlxState
	{
		//classes
		public var gameplay:Gameplay;
		
		public function PlayState() 
		{
		}
		
		override public function create():void 
		{
			//TODO: disable debug for release
			//FlxG.debug = true;
			//FlxG.visualDebug = true;
			
			//flixel initialization
			FlxG.bgColor = Game.BG_COLOR;
			FlxG.flashFramerate = 60;
			
			//initialize classes
			gameplay = new Gameplay();
			GUI.create();
			
			//groups
			add(gameplay.group);
			add(GUI.group);
		}
		
		override public function update():void 
		{
			super.update();
			Mouse.show();
			
			gameplay.update();
			GUI.update();
		}
	}
}