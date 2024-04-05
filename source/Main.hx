package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.system.Capabilities;

class Main extends Sprite
{
	var game:FlxGame;

	public static var fpsVar:FPS;

	public static function main():Void
		Lib.current.addChild(new Main());

	public function new()
	{
		super();

		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);

		setupGame();
	}

	private function setupGame()
	{
		Util.initThreads();
		game = new FlxGame(1920, 1080, PlayState, #if (flixel < "5.0.0") 1, #end 60, 60, true, false);
		addChild(game);
		flixel.FlxSprite.defaultAntialiasing = true;
		FlxG.mouse.visible = FlxG.mouse.useSystemCursor = true;

		// sys.io.File.saveContent("debug.txt", 'x${Capabilities.screenResolutionX * .7} y${Capabilities.screenResolutionY * .7}');
		// x1344 y756 se o monitor é 1080p...

		// Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
	}
}
