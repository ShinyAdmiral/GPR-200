#version 450

//input and output
layout (location = 0) out vec4 rtFragColor;
layout (location = 1) in vec4 gl_FragCoord;

//uniform vec2 uResolution;
uniform sampler2D uTex;
uniform vec2 uResolution;

// guassianBlur: Blur image
//    tex:     texture passed form previous buffer
//    coord:   fragment coordinate
//    res:     inverse Resolution of image
vec4 guassianBlur(sampler2D tex, vec2 coord, vec2 res)
{
    //make temp color
	vec4 color = vec4(0.0);
    
    //add each sample to the final color after calculating color, 
    //weight, and resolution of each pixel at the coord
    
    //Please not that the gaussian weights have been averaged because
    //samples are being taken from the corners of the sample blocks
    color += texture(tex, (coord + vec2(-1.5,  -1.5)) * res) * 6.25;
    color += texture(tex, (coord + vec2(-1.5,  -0.5)) * res) * 12.5;
    color += texture(tex, (coord + vec2(-1.5,   0.5)) * res) * 12.5;
    color += texture(tex, (coord + vec2(-1.5,   1.5)) * res) * 22.0;
    
    color += texture(tex, (coord + vec2(-0.5,  -1.5)) * res) * 12.5;
    color += texture(tex, (coord + vec2(-0.5,  -0.5)) * res) * 25.0;
    color += texture(tex, (coord + vec2(-0.5,   0.5)) * res) * 25.0;
    color += texture(tex, (coord + vec2(-0.5,   1.5)) * res) * 12.5;
    
    color += texture(tex, (coord + vec2( 0.5,  -1.5)) * res) * 12.5;
    color += texture(tex, (coord + vec2( 0.5,  -0.5)) * res) * 25.0;
    color += texture(tex, (coord + vec2( 0.5,   0.5)) * res) * 25.0;
    color += texture(tex, (coord + vec2( 0.5,   1.5)) * res) * 12.5;
    
    color += texture(tex, (coord + vec2( 1.5,  -1.5)) * res) * 6.25;
    color += texture(tex, (coord + vec2( 1.5,  -0.5)) * res) * 12.5;
    color += texture(tex, (coord + vec2( 1.5,   0.5)) * res) * 12.5;
    color += texture(tex, (coord + vec2( 1.5,   1.5)) * res) * 6.25;
    
    //return color after weight inverse is multiplied
	return color * 0.00390625;
}
void main()
{
	//get blur image
	vec4 col = guassianBlur(uTex, gl_FragCoord.xy, 1.0 / uResolution);
	
	//output
	rtFragColor = col;
}