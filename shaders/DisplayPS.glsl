#version 450

//output and input
layout (location = 0) out vec4 rtFragColor;
layout (location = 1) in vec4 gl_FragCoord;

//uniform vec2 uResolution;
uniform sampler2D uScene;
uniform sampler2D uBlur;
uniform vec2 uResolution;

//varrying
in vec2 vTexcoord;

void main()
{	
	//add textures togher for convolution
	rtFragColor = texture(uScene, vTexcoord) + texture(uBlur, vTexcoord);
}