#version 450

in vec4 color;
out vec4 outColor;
in vec2 bWater;
in vec3 loc;
in float noiseInfo;
uniform sampler2D colorTex;
/*
biome info:

> .8 - snow
.80 - .7 rock / dirty snow
.

*/

float snowStart = 1.;
float snowEnd = .6;
vec4 snowColor = vec4(1.);

float rockStart = snowEnd;
float rockEnd = .5;
vec4 rockColor = vec4(.2);

float grassStart = rockEnd;
float grassEnd = 0.;
vec4  grassColor = vec4(0.,.5,0.,0.) ;

float terrainBlend = .2;

void main() 
{
	outColor = texture(colorTex, vec2(.5,0.));
}