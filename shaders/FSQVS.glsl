#version 450

layout (location = 0) in vec4 aPosition;
layout (location = 2) in vec2 aTexcoord;

uniform mat4 uModelMat, uViewMat, uProjMat;

//varraying
//out vec4 vPosClip;
//out vec3 vNormal;
out vec2 vTexcoord;

void main(){    
    //Clip
    //PERSPECTIVE
    gl_Position = aPosition;
    vTexcoord = aPosition.xy * 0.5f + 0.5f;
    // NORMAL PIPELINE
	//mat3 normalMat = transpose(inverse(mat3(uViewMat * uModelMat)));
	//vNormal = normalMat * aNormal;															
	
    //vPosClip = gl_Position;
}
