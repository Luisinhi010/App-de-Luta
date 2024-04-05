package;

import flixel.system.FlxAssets.FlxShader;

using StringTools;

typedef ShaderEffect =
{
	var shader:Dynamic;
}

class CircleEffect extends Effect
{
	public var shader:CircleShader = new CircleShader();

	public function new() {}
}

class CircleShader extends FlxShader
{
	@:glFragmentSource('
	#pragma header


	void main() 
	{
	float len = length(openfl_TextureCoordv - vec2(0.5, 0.5));
	float r = 0.5 - (1.0 / openfl_TextureSize.x);
	vec4 c = flixel_texture2D(bitmap, openfl_TextureCoordv);
	vec4 color = mix(vec4(0, 0, 0, 0.5), c, c.a);
	gl_FragColor = color * clamp(1 - ((len - r) * openfl_TextureSize.x), 0, 1);
	}

')
	public function new()
	{
		super();
	}
}

class Effect
{
	public function setValue(shader:FlxShader, variable:String, value:Float)
		Reflect.setProperty(Reflect.getProperty(shader, 'variable'), 'value', [value]);
}
