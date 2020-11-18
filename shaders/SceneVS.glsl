#version 450

//inputs
layout (location = 0) in vec4 aPosition;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec4 aTexcoord;

//uniforms
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
out vec3 vNormal;
out vec4 vTexcoord;
out vec4 vPosition;
out vec4 vCamPos;
out pointLight light[3];

void main(){    
    //World Space
    vPosition = uModelMat * aPosition;
    
    //Clip
    //PERSPECTIVE
    vCamPos = uViewMat * vPosition;
    
    //vertex position pass
    gl_Position = uProjMat * vCamPos;
    
    // NORMAL PIPELINE
	vNormal = (uModelMat * vec4(aNormal,0)).xyz;															
	
    //texture coordinate pass
    vTexcoord = aTexcoord;
	
	//declare each light
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