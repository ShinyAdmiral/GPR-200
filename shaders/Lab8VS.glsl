#version 450

layout (location = 0) in vec4 aPosition;

uniform mat4 uModelMat, uViewMat, uProjMat, uOrthMat;

//varraying
out vec4 vPosClip;

void main(){
	//Object
	//gl_Position = aPosition * vec4(0.5, 0.5, 0.5, 1.0);
	//w = 1 because point
	
	//World
	//gl_Position = uModelMat * aPosition;
	//w = 1 because point
	
	//View
	//gl_Position = uViewMat * uModelMat * aPosition;
	//w = 1 because point
	
	//Clip
	//PERSPECTIVE
	//order of matrices matter
	gl_Position = uProjMat * uViewMat * uModelMat * aPosition;
	//w = 1 because point IF we have Orthographic
	//else w = distasnce from viewer
	
	//NOT PART OF VERTEX SHADER
	//NDC = CLIP / CLIP.W
	//w = 1
	//visible region is contained within [-1, +1] range
	
	vPosClip = gl_Position;
}
