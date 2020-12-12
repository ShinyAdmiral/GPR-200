#version 450

in vec4 color;
out vec4 outColor;
in vec2 bWater;
in vec3 loc;
void main() {
	//outColor = color*.5+.5; // adjust range
	if(false)
	{
		outColor = color*.5+.5; // adjust range
		return;
	}
	if(bWater.x > 0.)
	{
		outColor =	vec4(0.,0.,100.,.25);
		return;
	}
	float angle = dot(color.xyz, vec3(0.,0.,1.));
	if(angle > .35)
	{
		if(loc.x > 0.5)
		{
			float sColor = loc.x;
			outColor = vec4(sColor);
		}
		else
		{
			outColor = vec4(0.,angle,0., 1.);
		}
		return;
	}
	else
	{
		outColor = vec4(angle);
	}
}