package;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

class Util
{
	public static function returnColor(?str:String = ''):FlxColor
	{
		switch (str.toLowerCase().replace(' ', ''))
		{
			case "black" | "preto":
				return FlxColor.BLACK;
			case "white" | "branco":
				return FlxColor.WHITE;
			case "blue" | "azul":
				return FlxColor.BLUE;
			case "brown" | "marrom":
				return FlxColor.BROWN;
			case "cyan" | "ciano":
				return FlxColor.CYAN;
			case "yellow" | "amarelo":
				return FlxColor.YELLOW;
			case "gray" | "cinza":
				return FlxColor.GRAY;
			case "green" | "verde":
				return FlxColor.GREEN;
			case "lime" | "limao":
				return FlxColor.LIME;
			case "magenta":
				return FlxColor.MAGENTA;
			case "orange" | "laranja":
				return FlxColor.ORANGE;
			case "pink" | "rosa":
				return FlxColor.PINK;
			case "purple" | "roxo":
				return FlxColor.PURPLE;
			case "red" | "vermelho":
				return FlxColor.RED;
			case "transparent" | 'trans' | 'transparente':
				return FlxColor.TRANSPARENT;
		}
		return FlxColor.WHITE;
	}

	inline public static function updatescreenratio()
	{
		#if desktop
		@:privateAccess {
			FlxG.width = 1920;
			FlxG.height = 1080;
		}
		// Application.current.window.borderless = false;
		#end
	}

	inline public static function boundTo(value:Float, min:Float, max:Float):Float
		return Math.max(min, Math.min(max, value));

	inline public static function updatewindowres(width:Int, height:Int):Void
	{
		if (!FlxG.fullscreen)
		{
			var lastRes:Array<Int> = [Application.current.window.width, Application.current.window.height];
			var windowsPos:Array<Int> = [Application.current.window.x, Application.current.window.y];
			FlxG.resizeWindow(width, height);
			Application.current.window.move(Std.int(windowsPos[0] - (width - lastRes[0]) / 2), Std.int(windowsPos[1] - (height - lastRes[1]) / 2));
		}
	}
}
