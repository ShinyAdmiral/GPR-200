#version 450

layout (location = 0) out vec4 rtFragColor;
layout (location = 1) in vec4 gl_FragCoord;

uniform vec2 uResolution;
uniform sampler2D uTexture;

out vec2 vTexcoord;

void main(){
	
	//get uvs
	vec2 uv = gl_FragCoord.xy / uResolution;
	
	//warp uvs
	vec2 disp = uv - vec2(.5, .5);
	disp *= sqrt(length(disp));
	disp *= sqrt(length(disp));
	disp *= sqrt(length(disp));
	uv += disp * 0.25;
	
	float aberration = 0.013;

	//chromatically aberrate texture
	vec4 color = 	   (texture(uTexture, uv ) +                   
						texture(uTexture, uv * (1.0 - aberration)) * vec4(vec3(1.0, 0.0, 1.0), 1.0) +
						texture(uTexture, uv * (1.0 + aberration)) * vec4(vec3(0.0, 1.0, 1.0), 1.0)) *
						vec4(0.5, 0.5, 0.33, 0.33);  
		
	//clamp texture	
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		color = vec4(0.0);
	}
	
	rtFragColor = color;
}
