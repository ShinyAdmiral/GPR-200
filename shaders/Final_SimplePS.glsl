#version 450

in vec4 color;
out vec4 outColor;
in vec2 bWater;
void main() {

if(true)
{
	outColor = color;
	return;
}
	if(bWater.x > 0.)
	{
		outColor =	vec4(0.,0.,1.,.25);
		return;
	}
	
	float angle = dot(vec3(0,0,1.), color.xyz);
	if(angle > .5)
	{
		outColor = vec4(0.,angle,0., 1.);
		return;
	}
	else
	{
		outColor = vec4(angle);
	}
}