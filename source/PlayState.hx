package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import haxe.io.Path;
import ibwwg.FlxScrollableArea;
import lime.app.Application;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.Screen;
import openfl.display.Shape;
import openfl.geom.Point;

using FlxSpriteTools;

class PlayState extends FlxState
{
	// para controlar a camera
	var cam:FlxCamera;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	// camera que não vai ir com a rolagem
	var uiCamera:FlxCamera;

	// para a barra de rolagem.
	var scrollbar:FlxSprite;
	var scrollThumb:FlxSprite;
	var scrollbarHeight:Int = FlxG.height;
	var scrollbarWidth:Int = 12;

	// altura da camera/rolagem/pagina
	private var scrollSpeed:Float = 30;
	private var scrollOffset:Int = 0;
	private var minY:Float = 359.5;
	private var maxY:Float = 0;
	private var currentY:Float = 0;
	private var limitY:Float = Math.POSITIVE_INFINITY; // limite de altura da camera

	private function prepareCamera():Void
	{
		cam = new FlxCamera();
		uiCamera = new FlxCamera();
		uiCamera.bgColor.alpha = 0;
		FlxG.cameras.reset(cam);
		FlxG.cameras.add(uiCamera, false);
		FlxG.cameras.setDefaultDrawTarget(cam, true);
		camFollow = new FlxObject(639.5, 359.5, 1, 1);
		camFollowPos = new FlxObject(639.5, 359.5, 1, 1);
		add(camFollow);
		add(camFollowPos);
	}

	private function createUiElements():Void
	{
		var show:Bool = (maxY >= cam.height);
		scrollbar = new FlxSprite(FlxG.width - scrollbarWidth, 10);
		scrollbar.makeGraphic(12, scrollbarHeight - Std.int(scrollbar.y), FlxColor.GRAY);
		scrollbar.visible = show;
		scrollbar.cameras = [uiCamera];
		add(scrollbar);

		scrollThumb = new FlxSprite(FlxG.width - (scrollbarWidth / 2), 10).makeGraphic(Std.int(scrollbarWidth / 2), 60, FlxColor.WHITE);
		scrollThumb.visible = show;
		scrollThumb.cameras = [uiCamera];
		add(scrollThumb);
	}

	override public function create()
	{
		prepareCamera();

		var backgroundColors:Array<String> = ["black", "gray"];
		var transGradient:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, Std.int(maxY - minY),
			[for (i in 0...backgroundColors.length) Util.returnColor(backgroundColors[i])], 1, 90);
		add(transGradient);

		addText('Artes\nMortais', FlxColor.WHITE, 0, 24);
		addText('Ponto', FlxColor.CYAN, 0, 24).x = 200;
		addImage('LogoInteira');
		addImage('Logo');
		addImage('LogoNome');
		addImage('LogoNomeRes');

		if (currentY > limitY)
			currentY = limitY;
		maxY = currentY;
		// maxY = limitY; // para testes
		// scrollOffset = cam.height;

		createUiElements();
		FlxG.camera.follow(camFollowPos, null, 1);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		var lerpVal:Float = Util.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		var scrollRange:Float = (maxY - scrollOffset) - minY;
		var thumbPosition:Float = (camFollow.y - minY) / scrollRange * (scrollbarHeight - scrollThumb.height);
		scrollThumb.y = thumbPosition + scrollbar.y;
		scrollThumb.y = FlxMath.bound(scrollThumb.y, scrollbar.y, scrollbar.y + scrollbar.height - scrollThumb.height);

		super.update(elapsed);

		if (FlxG.mouse.wheel != 0)
		{
			camFollow.y -= FlxG.mouse.wheel * scrollSpeed;
			camFollow.y = FlxMath.bound(camFollow.y, minY, maxY - scrollOffset);
		}
	}

	private function addText(content:String, color:FlxColor = FlxColor.WHITE, fieldWidth:Int = null, size:Int = 8, padding:Float = 20):FlxText
	{
		if (fieldWidth == null)
			fieldWidth = FlxG.width - (scrollbarWidth * 2);
		var text:FlxText = new FlxText(0, currentY + padding, fieldWidth, content, size);
		text.setFormat(null, size, color, "center", FlxColor.BLACK);
		text.screenCenter(X);
		add(text);
		currentY += text.height + padding;
		return text;
	}

	private function addImage(graphicPath:String, padding:Float = 20):FlxSprite
	{
		var image:FlxSprite = new FlxSprite().loadGraphic(Paths.image(graphicPath));
		image.screenCenter(X);
		image.y = currentY + padding;
		add(image);
		currentY += image.height + padding;
		return image;
	}
}
