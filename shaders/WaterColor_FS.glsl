#version 450
#define PI 3.14159265358979
#define SAMP_NUM 200

//credit: https://www.shadertoy.com/view/ltyGRV

layout (location = 0) out vec4 rtFragColor;
layout (location = 1) in vec4 gl_FragCoord;

uniform vec2 uResolution;
uniform sampler2D uRT_world;

vec3 rand(in vec2 coord, in float seed, out float Oseed){
	
	//base random seed
	vec2 vec2Seed = vec2(42.0, 
						 130.0);
	
	//add to seed and get random red value
	vec2Seed += seed;
	float random1 = fract(sin(dot(coord, vec2Seed)) * 300);
	seed += 0.42;
	
	//add to seed and get random Green value
	vec2Seed += seed;
	float random2 = fract(sin(dot(coord, vec2Seed)) * 200);
	seed += 0.2465;
	
	//add to seed and get random Blue value
	vec2Seed += seed;
	float random3 = fract(sin(dot(coord, vec2Seed)) * 200);
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

vec2 grad(vec2 pos, vec2 delta, vec2 res){
	
	//soften coefficient 
	vec3 soften = vec3(0);
	
	//get gradient by sampling colors around the fragment
	//get gradient form top and bottom
	vec4 rigColor = getColor(pos + delta.xy, res);
	vec4 lefColor = getColor(pos - delta.xy, res);
	
	vec4 topColor = getColor(pos + delta.yx, res);
	vec4 botColor = getColor(pos - delta.yx, res);
	
	//blend colors together
	return vec2(dot((rigColor - lefColor).xyz, soften),
				dot((topColor - botColor).xyz, soften));
				;
}

void main(){
	//set starting seed
	float seed = 32.343;

	//get UVs
	vec2 invRes = 1.0 / uResolution;
	
	//declare and initilize each position
	vec2[2] pos;
	pos[0] = gl_FragCoord.xy;
	pos[1] = gl_FragCoord.xy;

	
	//start each color to gradient
	vec3 color1 = vec3(0);
	vec3 color2 = vec3(0);
	
	float control = 0.0;
	
	//sample for a number of times
	for (int i = 0; i < SAMP_NUM; i++){
		//gradient for wash
		vec2 gradient1 = grad(pos[0], vec2(2.0, 0.0), invRes) + 0.0001 * (rand(pos[0], seed, seed).xy-0.4);
		vec2 gradient2 = grad(pos[1], vec2(2.0, 0.0), invRes) + 0.0001 * (rand(pos[1], seed, seed).xy-0.4);
		
		//loose color over distance	
		float soften = 0.7;
		
		pos[0] += 0.25  * normalize(gradient1) + 0.5 * (rand(pos[0], seed, seed).xy - 0.5);
		pos[1] += 0.5   * normalize(gradient2) + 0.5 * (rand(pos[0], seed, seed).xy - 0.5);
		
		//get loop - sample ratio
		float fact = 1.0 - float(i)/float(SAMP_NUM);
		float f1 = 3.0 * fact;
		float f2 = 4.0 * (0.7 - fact);
		
		//get color
		color1 += f1 * (getColor(pos[0], invRes).xyz + 0.4 * rand(pos[0], seed, seed) * soften);
		color1 += f2 * (getColor(pos[1], invRes).xyz + 0.4 * rand(pos[1], seed, seed) * soften);
		
		//add invers ratio for later control
		control += f1 + f2;
	}
	
	//divide by control to prevent white out
	color1 /= control*1.65;
	
	//rtFragColor = texture(uRT_world, gl_FragCoord.xy/uResolution);
	
	rtFragColor= vec4(color1, 1.0);
}