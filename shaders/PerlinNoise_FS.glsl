#version 450
//Code by: Andrew Hunt and Rhys Sullivan

//attributes
layout (location = 0) out vec4 rtFragColor;
layout (location = 1) in vec4 gl_FragCoord;

//uniforms
uniform vec2 uResolution;
uniform float uTime;
layout (binding = 0)uniform sampler2D uEdge;

//buffer from compute shader
layout (binding = 0) buffer ubInput{
	vec4 keyInputs;
};

//return a manipulated sine of time
float timeRangeS(float time, float ratioFlux, float ratioClamp){
	return sin(time) * ratioFlux + ratioClamp;
}

//return a manipulated cosine of time
float timeRangeC(float time, float ratioFlux, float ratioClamp){
	return cos(time) * ratioFlux + ratioClamp;
}

//random 2D
float rand(in vec2 coord, vec2 inp){
	//base seed with input
	vec2 vec2Seed = vec2(13.0 + inp.x, 
						 89.0 + inp.y);
	
	//make random value based of of position
	float random = fract(sin(dot(coord, vec2Seed))* 10000.0f);
	
	//return random
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
	//make them less effective to get the cloudy look
	uvChange = matrixOctave * uv;
	ratioChange = ratio * ratio;   
	
	//return noise after ratio is placed in              	  
	return noiseValue * ratio;
}

void main(){
	//setup
	float fractalNoise = 0.0;
	vec2 uv = gl_FragCoord.xy / uResolution;
	
	//grab input from keyboard
	vec2 inputOffset = keyInputs.xy;
	
	//scale ratio and octave matrix of noise
	float scale = 4.0;
	float ratio = 0.5;
	mat2 matrixOctave = mat2(1.3 , 0.7,
							 -0.7, 1.3);
	
	//pass noise a few times making it weaker on each pass
	vec2 scalePos = uv * scale + inputOffset;
	fractalNoise += noise(ratio, scalePos, ratio, scalePos, matrixOctave, keyInputs.zw);
	fractalNoise += noise(ratio, scalePos, ratio, scalePos, matrixOctave, keyInputs.zw);
	fractalNoise += noise(ratio, scalePos, ratio, scalePos, matrixOctave, keyInputs.zw);
	fractalNoise += noise(ratio, scalePos, ratio, scalePos, matrixOctave, keyInputs.zw);
	
	//edge pass since we don't want the edges to be bumpy
	fractalNoise *= texture(uEdge, uv).x;
	
	//pass noise to texture
	rtFragColor = vec4(vec3(fractalNoise), 1.0);
}
