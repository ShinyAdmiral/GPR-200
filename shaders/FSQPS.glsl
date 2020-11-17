#version 450

layout (location = 0) out vec4 rtFragColor;

in vec2 vTexcoord;

//uniform vec2 uResolution;
uniform sampler2D uTex;
float getLum(in vec4 color)
{
    //return luiminosity
    return 0.2126 * color.x + 0.7152 * color.y + 0.0722 * color.z;
}
void main()
{
	vec2 uv = vTexcoord;
	float lum = getLum(texture(uTex, uv));
	vec4 col = vec4(vec3(texture(uTex, uv)) * lum * lum * lum, 1.0);
	rtFragColor = col;//texture(uTex, uv);
}