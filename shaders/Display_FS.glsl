#version 450
//Code by: Andrew Hunt and Rhys Sullivan

//attributes
layout (location = 0) out vec4 rtFragColor;
layout (location = 1) in vec4 gl_FragCoord;

//uniforms
uniform vec2 uResolution;
uniform sampler2D uTexture;
layout (binding = 1)uniform sampler2D uTV;
layout (binding = 2)uniform sampler2D uWood;

void main(){
	
	//get uvs
	vec2 uv = gl_FragCoord.xy / uResolution;
	
	//warp uvs
	vec2 disp = uv - vec2(.5, .5);
	disp *= length(disp);
	disp *= length(disp);
	uv += disp * 0.8;
	
	float aberration = 0.013;

	//chromatically aberrate texture
	vec4 color = 	   (texture(uTexture, uv ) +                   
						texture(uTexture, uv * (1.0 - aberration)) * vec4(vec3(1.0, 0.0, 1.0), 1.0) +
						texture(uTexture, uv * (1.0 + aberration)) * vec4(vec3(0.0, 1.0, 1.0), 1.0)) *
						vec4(0.5, 0.5, 0.33, 0.33);  
	
	//scan lines
	//credit: https://www.shadertoy.com/view/Ms23zG
	float scanLines = clamp(0.35 + 0.35 * cos(uv.y * uResolution.y * 1.5), 0.0, 1.0);//credit: https://www.shadertoy.com/view/Ms23zG
	
	//saturate lines and add it to the image
	scanLines *= scanLines;
	color *= vec4(vec3(0.6 + 1.5 * scanLines), 1.0);
	
	//clamp texture
	//get checks
	float uvCheckX = 1 - abs( floor (uv.x) );
	float uvCheckY = 1 - abs( floor (uv.y) );
	
	//get rid of screen if out of fram
	color *= uvCheckX;
	color *= uvCheckY;
	
	//put frame in if out of frame
	vec4 edge_color = texture(uTV, uv) * vec4 (0.4, 0.32, 0.25, 1.0) * texture(uWood, uv);
	color += edge_color - edge_color * uvCheckX * uvCheckY;
	
	//return color
	rtFragColor = color;
}
