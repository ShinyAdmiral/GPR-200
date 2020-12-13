#version 450

//output and input
layout (location = 0) out vec4 rtFragColor;
layout (location = 1) in vec4 gl_FragCoord;

uniform vec2 uResolution;
uniform float uTime;
uniform sampler2D uInput;

layout (binding = 0) buffer ubInput{
	vec4 keyInputs;
};

float timeRangeS(float time, float ratioFlux, float ratioClamp){
	return sin(time) * ratioFlux + ratioClamp;
}

float timeRangeC(float time, float ratioFlux, float ratioClamp){
	return cos(time) * ratioFlux + ratioClamp;
}

//random 2D
float rand(in vec2 coord, vec2 inp){
	vec2 vec2Seed = vec2(13.0 + inp.x, 
						 89.0 + inp.y);
						 
	float random = fract(sin(dot(coord, vec2Seed))* 10000.0f);
	
	return random;
}

float noise(out float ratioChange, out vec2 uvChange,in float ratio, in vec2 uv, in mat2 matrixOctave, in vec2 inp){
	vec2 posInt		= floor(uv);
	vec2 posFract	= fract(uv);
	
	//grab corners of the 2D tile
	float BL = rand (posInt, inp);
	float BR = rand (posInt + vec2(1.0, 0.0), inp);
	float TL = rand (posInt + vec2(0.0, 1.0), inp);
	float TR = rand (posInt + vec2(1.0, 1.0), inp);
	
	//smooth interpolation
	//Source: https://thebookofshaders.com/11/
	vec2 newUV = posFract * posFract * (3.0 - 2.0 * posFract);
	float noiseValue = mix(BL, BR, newUV.x) + 
			   		   	  (TL - BL) * newUV.y * (1.0 - newUV.x) +
			   			  (TR - BR) * newUV.x * newUV.y;
	
	//edit ratios and uv's since we need to change them
	uvChange = matrixOctave * uv;
	ratioChange = ratio * ratio;   
	   	     	     	  
	return noiseValue * ratio;
}

void main(){
	float fractalNoise = 0.0;
	vec2 uv = gl_FragCoord.xy / uResolution;
	
	//grab input from keyboard
	vec2 inputOffset = keyInputs.xy;
	
	float scale = 4.0;
	float ratio = 0.5;
	mat2 matrixOctave = mat2(1.3 , 0.7,
							 -0.7, 1.3);
	
	vec2 scalePos = uv * scale + inputOffset;
	fractalNoise += noise(ratio, scalePos, ratio, scalePos, matrixOctave, keyInputs.zw);
	fractalNoise += noise(ratio, scalePos, ratio, scalePos, matrixOctave, keyInputs.zw);
	fractalNoise += noise(ratio, scalePos, ratio, scalePos, matrixOctave, keyInputs.zw);
	fractalNoise += noise(ratio, scalePos, ratio, scalePos, matrixOctave, keyInputs.zw);
	
	rtFragColor = vec4(vec3(fractalNoise), 1.0);
	
	//edge detection
	if (uv.x > 0.999 || uv.y > 0.999 || uv.x < 0.001 || uv.y < 0.001){
		rtFragColor = vec4(0.0);
	}
}
