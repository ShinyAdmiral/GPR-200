#version 450

layout (location = 0) out vec4 rtFragColor;

in vec4 vPosClip;

void main(){
	//rtFragColor = vec4(1.0);
	
	//rtFragColor = vPosClip;
	
	//MANUAL PERSPECTIVE DIVIDE
	vec4 posNDC = vPosClip / vPosClip.w;
	rtFragColor = posNDC;
	// [-1, +1] constraints visible space
	
	// SCREEN - SPACE
	vec4 posScreen =- posNDC * 0.5 + 0.5;
	rtFragColor = posScreen;
	// [-1, +1]  -> [0, 1]
	
	rtFragColor.b = 0.0;
}