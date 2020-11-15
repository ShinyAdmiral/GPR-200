#version 450

layout (location = 0) out vec4 rtFragColor;

//in vec4 vPosClip;
in vec3 vNormal;



void main()
{
	vec3 color = vNormal * 0.5 + 0.5;

    rtFragColor = vec4(color, 1.0);
}