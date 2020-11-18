#version 450
layout (location = 0) out vec4 rtFragColor;
layout (location = 1) in vec4 gl_FragCoord;

//uniform vec2 uResolution;
uniform sampler2D uBlur;
uniform sampler2D uScene;
uniform vec2 uResolution;

in vec2 vTexcoord;

void main()
{
	rtFragColor = texture(uScene, vTexcoord) + texture(uBlur, vTexcoord);
}