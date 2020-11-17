#version 450

layout (location = 0) in vec4 aPosition;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec4 aTexcoord;

uniform mat4 uModelMat, uViewMat, uProjMat;

//varraying
//out vec4 vPosClip;
out vec3 vNormal;
out vec4 vTexcoord;
out vec4 vPosition;
out vec4 vCamPos;

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
    //vNormal = aNormal;
}