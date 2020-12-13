#version 450

in vec4 color;
out vec4 outColor;
in vec2 bWater;
in vec3 loc;
in float noiseInfo;
uniform sampler2D noiseTex;
uniform sampler2D colorTex;
/*
biome info:
wddsadwasdawdaa
> .8 - snow
.80 - .7 rock / dirty snow
.

*/

float snowStart = 1.;
float snowEnd = .6;
vec4 snowColor = vec4(1.);

float rockStart = .5;
float rockEnd = .4;
vec4 rockColor = vec4(.2);

float grassStart = rockEnd;
float grassEnd = 0.;
vec4  grassColor = vec4(0.,.5,0.,0.) ;

float terrainBlend = .2;

void main() 
{
	float blend = 0.05;
	vec4 above = texture(colorTex, vec2(1-noiseInfo-.3+blend,0.));
	vec4 below = texture(colorTex, vec2(1-noiseInfo-.3-blend,0.));
	outColor = mix(above,below,.5);
}