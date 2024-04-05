package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileSquare;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.filters.BlurFilter;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.system.Capabilities;
import openfl.ui.Mouse;

using FlxSpriteTools;

class PlayState extends flixel.FlxState
{
	var lorem:String = Paths.text('lorem');

	// grariende de fundo
	var transGradient:FlxSprite;

	// para controlar a camera
	var cam:FlxCamera;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	// camera adicional que não vai ir com a rolagem
	var uiCamera:FlxCamera;

	// para a barra de rolagem.
	var scroll:Bool;
	var scrollbar:FlxSprite;
	var scrollThumb:FlxSprite;
	var isDragging:Bool = false;
	var dragOffsetY:Float;
	final scrollbarHeight:Int = FlxG.height;
	final scrollbarWidth:Int = 26;

	// uma barra em cima
	var topbar:FlxSprite;
	var pfp:FlxSprite;

	// altura da camera/rolagem/pagina
	var scrollSpeed:Int = 32;
	var scrollOffset:Float = 0;
	var minX:Float = 959.5;
	var minY:Float = 539.5;
	var maxY:Float = 0;
	var currentY:Float = 0;
	final limitY:Float = FlxG.height * 10; // limite de altura da camera // 10 x 1080p... = 10800

	// com a a pagina só com os 4 sprites de teste da 2081 então talvez nem precisa de um limite

	/**
	 * Prepara a câmera principal
	 */
	function prepareCamera():Void
	{
		cam = new FlxCamera();
		uiCamera = new FlxCamera();
		uiCamera.bgColor.alpha = 0;
		FlxG.cameras.reset(cam);
		FlxG.cameras.add(uiCamera, false);
		FlxG.cameras.setDefaultDrawTarget(cam, true);
		cam.antialiasing = true;
		uiCamera.antialiasing = true;
		camFollow = new FlxObject(minX, minY, 1, 1);
		camFollowPos = new FlxObject(minX, minY, 1, 1);
		add(camFollow);
		add(camFollowPos);
		FlxG.camera.follow(camFollowPos, null, 1);
	}

	/**
	 * Cria os elementos de interface do usuário
	 */
	function createUiElements():Void
	{
		topbar = new FlxSprite(0, 0).makeGraphic(FlxG.width, 75, Util.returnColor('black'));
		topbar.alpha = 0.5;
		topbar.cameras = [uiCamera];
		add(topbar);

		scroll = (maxY >= cam.height);
		scrollbar = new FlxSprite(FlxG.width - scrollbarWidth, topbar.height);
		scrollbar.moves = false;
		scrollbar.active = false;
		scrollbar.makeGraphic(scrollbarWidth, scrollbarHeight - Std.int(scrollbar.y), Util.returnColor('gray'));
		scrollbar.visible = scroll;
		scrollbar.cameras = [uiCamera];
		add(scrollbar);

		scrollThumb = new FlxSprite(0, 10).makeGraphic(Std.int(scrollbarWidth / 1.5), 120, Util.returnColor('white'));
		scrollThumb.moves = false;
		scrollThumb.active = false;
		scrollThumb.centerOnSprite(scrollbar, X);
		scrollThumb.visible = scroll;
		scrollThumb.cameras = [uiCamera];
		// scrollThumb.shader = new Shaders.CircleEffect().shader;
		add(scrollThumb);
	}

	override public function create()
	{
		Util.updatewindowres(Std.int(Capabilities.screenResolutionX * .7), Std.int(Capabilities.screenResolutionY * .7));
		Util.updatescreenratio();
		Util.centerWindow();
		// por algum motivo não centraliza automaticamente quando a tela é menos que 1080p??
		// assumindo que isso vai ser apresentado na quela bosta de note da positivo da escola, eu estou modulando tudo isso para 1080p atoa
		// poxa, se for ainda, nem sei se vou poder usar shaders, aquilo lá nem roda google direito mdsss

		prepareCamera();

		var colors:Array<String> = ['trans', 'gray'];
		transGradient = FlxGradient.createGradientFlxSprite(Std.int(FlxG.height * 2), Std.int(FlxG.height * 2),
			[for (i in 0...colors.length) Util.returnColor(colors[i])], 1, 90, false);
		transGradient.pixels.applyFilter(transGradient.pixels, transGradient.pixels.rect, new Point(), new BlurFilter(0, 40, 40));
		transGradient.moves = false;
		transGradient.active = false;
		var scale:Float = Math.max(FlxG.width / transGradient.width, FlxG.height / transGradient.height);
		transGradient.scale.x = transGradient.scale.y = scale * 1.5;
		transGradient.scrollFactor.set();
		transGradient.updateHitbox();
		transGradient.screenCenter();
		add(transGradient);

		addText('Artes\nMortais', Util.returnColor('white'), 0, 36);
		var text:FlxText = addText('Ponto', Util.returnColor('cyan'), 0, 40);
		text.x = FlxG.width * 0.3;
		text.italic = true;
		text.underline = true;
		var imagetext = addImageWithText('LogoInteira', 80, lorem, Util.returnColor('white'), 36);
		imagetext.image.x = FlxG.width * 0.3;
		addImage('LogoInteira', 80, 36);
		addImage('LogoInteira', 160, 36);
		addImage('Logo', 120);
		addImage('LogoNome', 30);
		addImage('LogoNomeRes', 30);

		if (currentY > limitY)
			currentY = limitY;
		maxY = currentY;
		// maxY = limitY; // para testes
		scrollOffset = cam.height / maxY;

		createUiElements();
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (scroll) // nem ligar para a rolagem se não tiver o motivo :rollingeyes:
		{
			if (FlxG.mouse.justPressed && scrollThumb.overlapsPoint(FlxG.mouse.getWorldPosition(uiCamera), true))
			{
				isDragging = true;
				Mouse.hide();
				dragOffsetY = FlxG.mouse.getWorldPosition(uiCamera).y - scrollThumb.y;
			}
			else if (FlxG.mouse.justReleased)
			{
				isDragging = false;
				Mouse.show();
			}

			if (isDragging)
			{
				var newY:Float = FlxG.mouse.getWorldPosition(uiCamera).y - dragOffsetY;
				newY = FlxMath.bound(newY, scrollbar.y, scrollbar.y + scrollbar.height - scrollThumb.height);
				scrollThumb.y = newY;

				var thumbRange:Float = scrollbar.height - scrollThumb.height;
				var contentRange:Float = maxY - minY;
				var relativePosition:Float = (newY - scrollbar.y) / thumbRange;
				camFollow.y = minY + relativePosition * contentRange;

				camFollow.y = FlxMath.bound(camFollow.y, minY, maxY - scrollOffset);
			}
			else if (FlxG.mouse.wheel != 0)
			{
				camFollow.y -= FlxG.mouse.wheel * scrollSpeed;
				camFollow.y = FlxMath.bound(camFollow.y, minY, maxY - scrollOffset);
			}

			var scrollRange:Float = maxY - minY;
			var thumbPosition:Float = (camFollow.y - minY) / scrollRange * (scrollbar.height - scrollThumb.height);
			scrollThumb.y = thumbPosition + scrollbar.y;
			scrollThumb.y = FlxMath.bound(scrollThumb.y, scrollbar.y, scrollbar.y + scrollbar.height - scrollThumb.height);
		}

		var lerpVal:Float = FlxMath.bound(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		super.update(elapsed);
	}

	private function addText(content:String, color:FlxColor = FlxColor.WHITE, fieldWidth:Int = null, size:Int = 8, padding:Float = 20):FlxText
	{
		if (fieldWidth == null)
			fieldWidth = FlxG.width - (scrollbarWidth * 2);
		var text:FlxText = new FlxText(0, currentY + padding, fieldWidth, content, size);
		text.setFormat(Paths.font('Roboto'), size, color, "center", Util.returnColor('transparent'));
		text.antialiasing = true;
		text.screenCenter(X);
		add(text);
		currentY += text.height + padding;
		return text;
	}

	private function addImage(graphicPath:String, radius:Float = 80, padding:Float = 20):FlxSprite
	{
		var image:FlxSprite = addDefaultImage(graphicPath, padding);
		var mask:BitmapData = createRoundedRectangleMask(Std.int(image.width), Std.int(image.height), radius);
		var pixels:BitmapData = image.pixels.clone();
		for (x in 0...Std.int(image.width))
			for (y in 0...Std.int(image.height))
				if (mask.getPixel32(x, y) == 0x00000000)
					pixels.setPixel32(x, y, 0x00000000);
		image.pixels = pixels;
		return image;
	}

	private function addImageWithText(graphicPath:String, radius:Float = 80, textContent:String, textColor:FlxColor = FlxColor.WHITE, textSize:Int = 12,
			padding:Float = 20)
	{
		var image:FlxSprite = addImage(graphicPath, radius, padding);
		var text:FlxText = new FlxText(image.x + image.width + 10, image.y, 400, textContent, textSize);
		text.setFormat(Paths.font('Roboto'), textSize, textColor, "left", Util.returnColor('transparent'));
		add(text);

		while (text.height > image.height)
		{
			textSize -= 1;
			text.size = textSize;
			text.updateHitbox();
		}

		for (i => sprite in [image, text])
		{
			sprite.screenCenter(X);
			sprite.x += ((i == 0) ? -(sprite.width + 10) : (sprite.width + 10)) / 2;
		}

		text.antialiasing = true;

		return {image: image, text: text};
	}

	private function addDefaultImage(graphicPath:String, padding:Float = 20):FlxSprite
	{
		var image:FlxSprite = new FlxSprite().loadGraphic(Paths.image(graphicPath));
		image.moves = false;
		image.active = false;
		image.screenCenter(X);
		image.y = currentY + padding;
		add(image);
		currentY += image.height + padding;
		return image;
	}

	private function createRoundedRectangleMask(width:Int, height:Int, radius:Float):BitmapData
	{
		var bitmap:BitmapData = new BitmapData(width, height, true, 0x00000000);
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.drawRoundRect(0, 0, width, height, Std.int(radius), Std.int(radius));
		shape.graphics.endFill();
		bitmap.draw(shape, new Matrix(), null, null, null, true);
		return bitmap;
	}
}
