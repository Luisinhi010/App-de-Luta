package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.system.Capabilities;
import sys.thread.Thread;

class Main extends Sprite
{
	var game:FlxGame;

	public static var fpsVar:FPS;

	public static var gameThreads:Array<Thread> = [];
	private static var __threadCycle:Int = 0;

	public static function execAsync(func:Void->Void)
		gameThreads[(__threadCycle++) % gameThreads.length].events.run(func);

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
		for (i in 0...4)
		{
			gameThreads.push(Thread.createWithEventLoop(function()
			{
				Thread.current().events.promise();
			}));
		}
		game = new FlxGame(1280, 720, PlayState, #if (flixel < "5.0.0") 1, #end 60, 60, true, false);
		addChild(game);
		// lime.app.Application.current.window.setIcon(lime.utils.Assets.getImage(Paths.image('icon')));
		// lime.app.Application.current.window.borderless = true;
		FlxG.mouse.visible = FlxG.mouse.useSystemCursor = true;
		// trace('Monitor Width: ' + Capabilities.screenResolutionX + ', Monitor Height: ' + Capabilities.screenResolutionY);
		Util.updatewindowres(Std.int(Capabilities.screenResolutionX * .7), Std.int(Capabilities.screenResolutionY * .7));

		// Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
	}
}
