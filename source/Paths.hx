package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	inline static function getPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String)
	{
		return getPath(file);
	}

	inline static public function txt(key:String)
	{
		return getPath('data/$key.txt');
	}

	inline static public function text(key:String)
	{
		return openfl.Assets.getText(txt(key));
	}

	inline static public function textArray(key:String)
	{
		return text(key).split(',');
	}

	inline static public function xml(key:String)
	{
		return getPath('data/$key.xml');
	}

	inline static public function json(key:String)
	{
		return getPath('data/$key.json');
	}

	static public function sound(key:String)
	{
		return getPath('sounds/$key.$SOUND_EXT');
	}

	inline static public function soundRandom(key:String, min:Int, max:Int)
	{
		return sound(key + FlxG.random.int(min, max));
	}

	inline static public function music(key:String)
	{
		return getPath('music/$key.$SOUND_EXT');
	}

	inline static public function image(key:String)
	{
		return getPath('images/$key.png');
	}

	inline static public function font(key:String)
	{
		return getPath('fonts/$key.ttf');
	}

	inline static public function getSparrowAtlas(key:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key), file('images/$key.xml'));
	}
}
