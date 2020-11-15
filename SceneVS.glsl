#version 450

layout (location = 0) in vec4 aPosition;
layout (location = 1) in vec3 aNormal;

uniform mat4 uModelMat, uViewMat, uProjMat;

//varraying
//out vec4 vPosClip;
out vec3 vNormal;

void main(){    
    //Clip
    //PERSPECTIVE
    gl_Position = uProjMat * uViewMat * uModelMat * aPosition;
    
    // NORMAL PIPELINE
	//mat3 normalMat = transpose(inverse(mat3(uViewMat * uModelMat)));
	//vNormal = normalMat * aNormal;															
	
    //vPosClip = gl_Position;
    
    vNormal = aNormal;
}