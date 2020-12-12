#version 450

uniform mat4 matVP;
uniform mat4 matGeo;
uniform float matMaxHeight;
uniform sampler2D noiseTex;
uniform float iTime;
uniform bool water;
layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec2 texCoord;
out vec4 color;
out vec2 bWater;
out vec3 loc;
out float noiseInfo;
void main() 
{
	float maxHeight;
	if(water)
	{
	bWater = vec2(1.,1.);
	maxHeight = 0;
	}
	else
	{
	bWater = vec2(0.,0.);
	maxHeight = 3.5;
	}

	vec2 lookUp = texCoord;

	float origin = texture(noiseTex, lookUp).r;
	noiseInfo = origin;
	float dif = 1./10.; // look for slight blue
	vec3 topOffset   = vec3(0.,dif, 0.);
	vec3 bottomOffset= vec3(0.,-dif, 0.) ;
	vec3 rightOffset =  vec3(-dif, 0., 0.);
	vec3 leftOffset  = vec3(dif, 0., 0.);
	
	topOffset.z =    texture(noiseTex, lookUp + topOffset.xy).r;
	bottomOffset.z = texture(noiseTex, lookUp + bottomOffset.xy).r;
	leftOffset.z =   texture(noiseTex, lookUp + leftOffset.xy).r;
	rightOffset.z =  texture(noiseTex, lookUp + rightOffset.xy).r;
			
	vec4 newPos = vec4(pos, 1.);
	
	maxHeight *= .3;
	newPos.x += origin * maxHeight;
	
	vec3 newNorm = vec3(0.0);

	newNorm = vec3(origin);
	
	// uv & sample
	vec3 deltaHoriz = topOffset-bottomOffset;
	vec3 deltaVertical = rightOffset-leftOffset;
	newNorm = cross(deltaHoriz, deltaVertical);
	newNorm = normalize(newNorm);

	if(water)
	{
		color = vec4(0.,0.,1.,0.);
	}
	loc = newPos.xyz;
	gl_Position = matVP * matGeo * newPos;

}
