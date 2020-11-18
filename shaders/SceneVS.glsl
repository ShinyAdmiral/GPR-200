#version 450

layout (location = 0) in vec4 aPosition;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec4 aTexcoord;

uniform mat4 uModelMat, uViewMat, uProjMat;

//------------------------------------------
//DATA STRUCTURES
//------------------------------------------

//data structure for light
struct pointLight {
	vec4 center; 	 // center point of light
    vec4 color;		 // color of light
    float intensity; // intensity of light
};

//varraying
//out vec4 vPosClip;
out vec3 vNormal;
out vec4 vTexcoord;
out vec4 vPosition;
out vec4 vCamPos;
out pointLight light[3];

void main(){    
    //Clip
    //PERSPECTIVE
    vPosition = uModelMat * aPosition;
    
    vCamPos = uViewMat * uModelMat * aPosition;
    
    gl_Position = uProjMat * vCamPos;
    
    // NORMAL PIPELINE
	//mat3 normalMat = transpose(inverse(mat3(uViewMat * uModelMat)));
	vNormal = (uModelMat * vec4(aNormal,0)).xyz;															
	
    //vPosClip = gl_Position;
    
    vTexcoord = aTexcoord;
	
	light[0].center = uModelMat * vec4(10.0, 10.0, 0.0, 1.0);
	light[0].color = vec4(1.0, 1.0, 0.0, 1.0);
	light[0].intensity = 100000.0;
	
	light[1].center = uModelMat * vec4(-10.0, -10.0, 10.0, 1.0);
	light[1].color = vec4(1.0, 0.0, 1.0, 1.0);
	light[1].intensity = 1000.0;
	
	light[2].center = uModelMat * vec4(-10.0, 10.0, -10.0, 1.0);
	light[2].color = vec4(1.0);
	light[2].intensity = 1000.0;
}