package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxAssets.FlxShader;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.display.ShaderInput;
import openfl.utils.Assets;

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

class BWShaderEffect extends Effect
{
	public var shader(default, null):BWShaderGLSL = new BWShaderGLSL();

	public var lowerBound(default, set):Float;
	public var upperBound(default, set):Float;
	public var invert(default, set):Bool;

	public function new(_lowerBound:Float = 0.01, _upperBound:Float = 0.15, _invert:Bool = false):Void
	{
		lowerBound = _lowerBound;
		upperBound = _upperBound;
		invert = _invert;
	}

	function set_invert(v:Bool):Bool
	{
		invert = v;
		shader.invert.value = [invert];
		return v;
	}

	function set_lowerBound(v:Float):Float
	{
		lowerBound = v;
		shader.lowerBound.value = [lowerBound];
		return v;
	}

	function set_upperBound(v:Float):Float
	{
		upperBound = v;
		shader.upperBound.value = [upperBound];
		return v;
	}
}

class BWShaderGLSL extends FlxShader
{
	@:glFragmentSource('
		#pragma header

		uniform bool invert;
		uniform float lowerBound;
		uniform float upperBound;

		void main()
		{
			vec4 textureColor = texture2D(bitmap, openfl_TextureCoordv);

			float gray = 0.21 * textureColor.r + 0.71 * textureColor.g + 0.07 * textureColor.b;

			float outColor = 0;

			if(gray > upperBound){
				outColor = 1;
			}
			else if(!(gray < lowerBound) && (upperBound - lowerBound) != 0){
				outColor = (gray - lowerBound) / (upperBound - lowerBound);
			}

			if(invert){
				outColor = (1 - outColor) * textureColor.a;
			}

			gl_FragColor = vec4(outColor, outColor, outColor, textureColor.a);
		}')
	public function new()
	{
		super();
	}
}

class ChromaticAberrationEffect extends Effect
{
	public var shader:ChromaticAberrationShader;

	public function new(offset:Float = 0.00)
	{
		shader = new ChromaticAberrationShader();
		shader.enabled.value = [true];
		shader.rOffset.value = [offset];
		shader.gOffset.value = [0.0];
		shader.bOffset.value = [-offset];
	}

	public function setChrome(chromeOffset:Float):Void
	{
		if (chromeOffset <= 0)
			shader.enabled.value = [false];
		else
		{
			shader.enabled.value = [true];
			shader.rOffset.value = [chromeOffset];
			shader.gOffset.value = [0.0];
			shader.bOffset.value = [chromeOffset * -1];
		}
	}
}

class ChromaticAberrationShader extends FlxShader
{
	@:glFragmentSource('#pragma header

		uniform bool enabled = true;

		uniform float rOffset;
		uniform float gOffset;
		uniform float bOffset;

		void main()
		{
			vec4 color = texture2D(bitmap,openfl_TextureCoordv);
			if(!enabled)
			{
				gl_FragColor=color;
				return;
			}
			vec4 col1 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(rOffset, 0.0));
			vec4 col2 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(gOffset, 0.0));
			vec4 col3 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(bOffset, 0.0));
			vec4 toUse = texture2D(bitmap, openfl_TextureCoordv);
			toUse.r = col1.r;
			toUse.g = col2.g;
			toUse.b = col3.b;
			//float someshit = col4.r + col4.g + col4.b;

			gl_FragColor = toUse;
		}')
	public function new()
	{
		super();
	}
}

class CustomChromaticEffect extends Effect
{
	public var shader:CustomChromatic;

	public function new(offset:Float = 0.00)
	{
		shader = new CustomChromatic();
		shader.multiplier.value = [offset];
	}

	public function setChrome(chromeOffset:Float):Void
		shader.multiplier.value = [chromeOffset];
}

class CustomChromatic extends FlxShader
{
	@:glFragmentSource('#pragma header

	uniform bool enabled = true;
	
	uniform float multiplier;
	
	void main() 
	{
		vec4 color = texture2D(bitmap,openfl_TextureCoordv);
		if(!enabled)
		{
			gl_FragColor=color;
			return;
		}

		float distance = pow(distance(openfl_TextureCoordv.st, vec2(0.5)), 3.0);
	
		vec4 rValue = texture2D(bitmap, clamp(openfl_TextureCoordv.st + vec2((multiplier * distance) * 5, 0.0), 0.0, 1.0));
		vec4 gValue = texture2D(bitmap, clamp(openfl_TextureCoordv.st, 0.0, 1.0));
		vec4 bValue = texture2D(bitmap, clamp(openfl_TextureCoordv.st - vec2((multiplier * distance) * 5, 0.0), 0.0, 1.0));
		vec4 toUse = texture2D(bitmap, openfl_TextureCoordv);
		toUse.r = rValue.r;
		toUse.g = gValue.g;
		toUse.b = bValue.b;
	
		gl_FragColor =  toUse/*vec4(rValue.r, gValue.g, bValue.b, 1.0)*/;
	}	
	')
	public function new()
	{
		super();
	}
}

class BloomEffect extends Effect
{
	public var shader:BloomShader = new BloomShader();

	public function new(blurSize:Float, intensity:Float)
	{
		shader.blurSize.value = [blurSize];
		shader.intensity.value = [intensity];
	}
}

class BloomShader extends FlxShader
{
	@:glFragmentSource('
	
	#pragma header
	
	uniform float intensity = 0.35;
	uniform float blurSize = 1.0/512.0;
void main()
{
   vec4 sum = vec4(0);
   vec2 texcoord = openfl_TextureCoordv;
   int j;
   int i;

   //thank you! http://www.gamerendering.com/2008/10/11/gaussian-blur-filter-shader/ for the 
   //blur tutorial
   // blur in y (vertical)
   // take nine samples, with the distance blurSize between them
   sum += flixel_texture2D(bitmap, vec2(texcoord.x - 4.0*blurSize, texcoord.y)) * 0.05;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x - 3.0*blurSize, texcoord.y)) * 0.09;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x - 2.0*blurSize, texcoord.y)) * 0.12;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x - blurSize, texcoord.y)) * 0.15;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y)) * 0.16;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x + blurSize, texcoord.y)) * 0.15;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x + 2.0*blurSize, texcoord.y)) * 0.12;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x + 3.0*blurSize, texcoord.y)) * 0.09;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x + 4.0*blurSize, texcoord.y)) * 0.05;
	
	// blur in y (vertical)
   // take nine samples, with the distance blurSize between them
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y - 4.0*blurSize)) * 0.05;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y - 3.0*blurSize)) * 0.09;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y - 2.0*blurSize)) * 0.12;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y - blurSize)) * 0.15;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y)) * 0.16;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y + blurSize)) * 0.15;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y + 2.0*blurSize)) * 0.12;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y + 3.0*blurSize)) * 0.09;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y + 4.0*blurSize)) * 0.05;

   //increase blur with intensity!
  gl_FragColor = sum*intensity + flixel_texture2D(bitmap, texcoord); 
  // if(sin(iTime) > 0.0)
   //    fragColor = sum * sin(iTime)+ texture(iChannel0, texcoord);
  // else
	//   fragColor = sum * -sin(iTime)+ texture(iChannel0, texcoord);
}
	
	
	')
	public function new()
	{
		super();
	}
}

class InvertColorsEffect extends Effect
{
	public var shader:InvertShader = new InvertShader();

	public function new(lockAlpha)
	{
		//	shader.lockAlpha.value = [lockAlpha];
	}
}

class InvertShader extends FlxShader
{
	@:glFragmentSource('
    #pragma header
    
    vec4 sineWave(vec4 pt)
    {
	
	return vec4(1.0 - pt.x, 1.0 - pt.y, 1.0 - pt.z, pt.w);
    }

    void main()
    {
        vec2 uv = openfl_TextureCoordv;
        gl_FragColor = sineWave(texture2D(bitmap, uv));
		gl_FragColor.a = 1.0 - gl_FragColor.a;
    }')
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
