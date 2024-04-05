package;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import openfl.system.Capabilities;

using StringTools;

/**
 * uma classe muito util pra mim.
 */
class Util
{
	#if !html5
	public static var gameThreads:Array<sys.thread.Thread> = [];
	private static var __threadCycle:Int = 0;

	public static function initThreads():Void
		for (i in 0...4)
			gameThreads.push(sys.thread.Thread.createWithEventLoop(function() sys.thread.Thread.current().events.promise()));

	public static function execAsync(func:Void->Void)
		gameThreads[(__threadCycle++) % gameThreads.length].events.run(func);
	#else
	public static function initThreads():Void {}

	public static function execAsync(func:Void->Void)
		func();
	#end

	/**
	 * Retorna a cor correspondente ao nome fornecido.
	 * 
	 * @param str O nome da cor desejada.
	 * @return A cor correspondente, ou branco se o nome da cor não for reconhecido.
	 */
	public static function returnColor(?str:String = ''):FlxColor
	{
		switch (str.toLowerCase())
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
			case "dark red" | "vermelho escuro":
				return 0x8B0000;
			case "silver" | "prata":
				return 0xC0C0C0;
			case "dark brown" | "marrom escuro":
				return 0x654321;
			case "burnt orange" | "laranja queimado":
				return 0xCC5500;
			case "transparent" | 'trans' | 'transparente':
				return FlxColor.TRANSPARENT;
			case "light gray" | "cinza claro":
				return 0xD3D3D3;

			case "pantone blue":
				return 0x0018A8;
			case "pantone green":
				return 0x00AD43;
			case "pantone yellow":
				return 0xFFD300;
			case "pantone orange":
				return 0xFF5E00;
			case "pantone pink":
				return 0xFF66A1;
		}
		return FlxColor.WHITE;
	}

	/**
	 * Atualiza a resolução das cameras do haxe.
	 */
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

	/**
	 * Atualiza o tamanho da janela.
	 * 
	 * @param width A largura desejada da janela.
	 * @param height A altura desejada da janela.
	 */
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

	/**
	 * Centraliza a janela na tela se não estiver em tela cheia.
	 */
	inline public static function centerWindow():Void
	{
		if (!FlxG.fullscreen)
		{
			Application.current.window.move(Std.int((Capabilities.screenResolutionX / 2) - (Application.current.window.width / 2)),
				Std.int((Capabilities.screenResolutionY / 2) - (Application.current.window.height / 2)));
		}
	}
}
