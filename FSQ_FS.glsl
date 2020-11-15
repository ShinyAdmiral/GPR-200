#version 450

layout (location = 0) out vec4 rtFragColor;

in vec2 vTexcoord;

uniform vec2 uResolution;
uniform sampler2D uTex;

void main()
{
	vec2 uv = vTexcoord;
	vec4 col = texture(uTex, uv);
	
	rtFragColor = col;
}