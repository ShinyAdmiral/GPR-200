#version 450

uniform mat4 matVP;
uniform mat4 matGeo;
uniform float matMaxHeight;
uniform sampler2D noiseTex;
uniform sampler2D normTex;
uniform float iTime;
uniform bool water;
layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec2 texCoord;
out vec4 color;
out vec2 bWater;
void main() 
{
	if(water)
	{
	bWater = vec2(1.,1.);
	}
	else
	{
	bWater = vec2(0.,0.);
	}

	vec2 lookUp = texCoord;
	float timeOff = iTime;
	timeOff = 1.2;
	float scale = .85;
	lookUp *= scale; 				
	
	float origin = texture(noiseTex, lookUp).r;

	float dif = 0.01;
	vec2 off = vec2(dif,dif);
	float top =    texture(noiseTex, lookUp + off.y).r;
	float bottom = texture(noiseTex, lookUp - off.y).r;
	float left =   texture(noiseTex, lookUp + off.x).r;
	float right =  texture(noiseTex, lookUp - off.x).r;
				
	vec4 newPos = vec4(pos, 1.);
	float maxHeight = matMaxHeight;
	
	maxHeight *= .2;
	newPos.x += origin * maxHeight;
	
	vec3 newNorm = vec3(0.0);

	newNorm = vec3(origin);
	
	// uv & sample
	vec3 deltaHoriz = vec3(off.x + off.x, 0., right - left);	
	vec3 deltaVertical = vec3(0., off.y + off.y,  top - bottom);
	deltaHoriz = normalize(deltaHoriz);
	deltaVertical = normalize(deltaVertical);
	newNorm = cross(deltaHoriz, deltaVertical);
	
	newNorm = texture(normTex, lookUp).xyz;

	color = vec4(newNorm, 1.0); // alpha blending
	if(water)
	{
		color = vec4(0.,0.,1.,0.);
	}


	gl_Position = matVP * matGeo * newPos;

}
