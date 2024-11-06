uniform bool blinking;



float blinking_vfx(float time)
{
	if (blinking)
	{
		//Blinking effect.
		return sin(time);
	}
}