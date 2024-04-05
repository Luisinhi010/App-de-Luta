package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxAxes;

class FlxSpriteTools
{
	/**
	 * Centraliza um sprite `s` em relação a um sprite `t`.
	 * 
	 * @param s O sprite que será centralizado.
	 * @param t O sprite de referência sobre o qual `s` será centralizado.
	 * @param axes Os eixos nos quais a centralização deve ocorrer (padrão é ambos, X e Y).
	 */
	public static function centerOnSprite(s:FlxObject, t:FlxObject, ?axes:FlxAxes = FlxAxes.XY):Void
	{
		if (axes == FlxAxes.XY || axes == FlxAxes.X)
			s.x = t.x + (t.width / 2) - (s.width / 2);

		if (axes == FlxAxes.XY || axes == FlxAxes.Y)
			s.y = t.y + (t.height / 2) - (s.height / 2);
	}

	/**
	 * Ajusta o tamanho gráfico do sprite para um tamanho exato.
	 * 
	 * @param obj O sprite cujo tamanho gráfico será ajustado.
	 * @param width A nova largura desejada para o sprite.
	 * @param height A nova altura desejada para o sprite.
	 */
	public static function exactSetGraphicSize(obj:FlxSprite, width:Float, height:Float)
	{
		obj.scale.set(Math.abs(((obj.width - width) / obj.width) - 1), Math.abs(((obj.height - height) / obj.height) - 1));
		obj.updateHitbox();
	}
}
