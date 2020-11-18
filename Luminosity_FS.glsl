#version 450

//output
layout (location = 0) out vec4 rtFragColor;

//varrying input
in vec2 vTexcoord;

//texture
uniform sampler2D uTex;

// calcViewport: Get Luminosity
//    color:     color of fragment
float getLum(in vec4 color)
{
    //return luiminosity
    return 0.2126 * color.x + 0.7152 * color.y + 0.0722 * color.z;
}

void main()
{
	//get luminosity 
	float lum = getLum(texture(uTex, vTexcoord));
	
	//get color
	vec4 col = vec4(vec3(texture(uTex, vTexcoord)) * lum * lum * lum, 1.0);
	
	//output
	rtFragColor = col;
}