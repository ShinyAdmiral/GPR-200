#version 450
//Code by: Andrew Hunt and Rhys Sullivan

//attributes
layout (location = 0) out vec4 rtFragColor;
layout (location = 1) in vec4 gl_FragCoord;

//uniforms
uniform vec2 uResolution;
uniform sampler2D uRT_world;
uniform float uTime;

vec3 rand(in vec2 coord, in float seed, out float Oseed, float multiplyer){
	//base random seed
	vec2 vec2Seed = vec2(-4534.0  + multiplyer, 
						 -3387.0 + multiplyer);
	
	//add to seed and get random red value
	vec2Seed += seed;
	float random1 = fract(sin(dot(coord, vec2Seed)) * 300);
	seed += 0.4232;
	
	//add to seed and get random Green value
	vec2Seed += seed;
	float random2 = fract(sin(dot(coord, vec2Seed)) * 100);
	seed += 0.2465;
	
	//add to seed and get random Blue value
	vec2Seed += seed;
	float random3 = fract(sin(dot(coord, vec2Seed)) * 30);
	seed += 0.230;
	
	//output new seed
	Oseed = seed;
	
	//return random
	return vec3(random1, random2, random3);
}

vec4 getColor(vec2 pos, vec2 res){
	

	//get uvs
	vec2 uv = pos * res;
	
	//get color
	vec4 color = texture(uRT_world, uv);

	return color;
}

float newPos (vec2 pos , vec2 res , float time){
	float shift = 50;
	float rate = 60.0;
	float split = mod (time * rate, res.y * 2);
	float glitch = split + 30;
	
	float wave = 0.5;
	float height = 15;
	
	float shiftRatio = shift * split/uResolution.y;

	//shift everything if under split
	if (pos.y > split && pos.y < glitch ){
		pos.x += sin(gl_FragCoord.y * wave) * height;
	}
	else if (pos.y < split){
		pos.x += shift;
	}
	
	//else slowly move it back
	return pos.x + shift - shiftRatio;
}

void main(){
	//set starting seed
	float seed = 32.343;

	//get UVs
	vec2 invRes = 1.0 / uResolution;
	
	//declare and initilize each position
	vec2 pos = gl_FragCoord.xy;
	
	//VHS shift
	float shift = 50;
	float rate = 60.0;
	float split = mod (uTime * rate, uResolution.y * 2);
	float glitch = split + 30;
	
	float wave = 0.5;
	float height = 15;
	
	float shiftRatio = shift * split/uResolution.y;
	
	pos.x = newPos(pos, uResolution, uTime);
	
	//bend edges for a more retro look
	wave = 0.5;
	height = 2.5;
	
	pos.x += sin(gl_FragCoord.y * wave) * height;
	
	//gradient for washing grain
	float soften = 0.8;
	
	//sample ratio
	float sampleRatio = 6.0;
		
	//get color with ratio wights
	vec3 color1 = sampleRatio * (getColor(pos, invRes).xyz + 0.15 + 0.4 * rand(pos, seed, seed, uTime).zxy * soften);
	
	//divide by control to prevent white out
	color1 /= sampleRatio * 1.65;
	
	//return color with extra noise
	rtFragColor = vec4(color1, 1.0) + rand(pos, seed, seed, uTime).x * 0.15;
}