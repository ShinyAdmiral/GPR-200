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

void main() 
{
	vec2 lookUp = texCoord + .2;
	float timeOff = iTime;
	timeOff = 1.2;
	lookUp.y += timeOff / 1.5;
	lookUp *= .1;					
	
	float origin = texture(noiseTex, lookUp).r;
	vec2 off = vec2(0.01,0.01);
	float top = texture(noiseTex, lookUp + off.y).r;
	float bottom = texture(noiseTex, lookUp - off.y).r;
	float left = texture(noiseTex, lookUp + off.x).r;
	float right = texture(noiseTex, lookUp - off.x).r;
	
	
	
	vec4 newPos = vec4(pos, 1.);
	float maxHeight = matMaxHeight;
	
//	maxHeight *= .8;
	newPos.x += origin * maxHeight;
	vec3 newNorm = vec3(0.0);
	
	newNorm = vec3(origin);
	
	// rise and run
	// difference of horizontal change (change over x & y)
	// cross product of that
	
	// uv & sample
	vec3 deltaHoriz = vec3(off.x + off.x, 0., right - left);	
	vec3 deltaVertical = vec3(0., off.y + off.y, top - bottom);
	deltaHoriz = normalize(deltaHoriz);
	deltaVertical = normalize(deltaVertical);
	newNorm = cross(deltaHoriz, deltaVertical);
	
	color = vec4(newNorm, 0.5); // alpha blending
	if(water)
	color = vec4(0.,0.,1.,0.);
	gl_Position = matVP * matGeo * newPos;
}
