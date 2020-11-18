#version 450
const int B = 66;

//output and input
layout (location = 0) out vec4 rtFragColor;
layout (location = 1) in vec4 gl_FragCoord;

//uniform vec2 uResolution;
uniform sampler2D uScene;
uniform sampler2D uBlur;
uniform sampler2D uKeyboard;
uniform vec2 uResolution;

//varrying
in vec2 vTexcoord;

void main()
{	
	//gather input
	float toggleBloom = 1.0 - texelFetch(uKeyboard, ivec2(B	, 0), 0).x;

	//add textures togher for convolution
	rtFragColor = texture(uScene, vTexcoord) + texture(uBlur, vTexcoord) * toggleBloom;
}