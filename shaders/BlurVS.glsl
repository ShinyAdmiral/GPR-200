#version 450

//input
layout (location = 0) in vec4 aPosition;

//uniform
uniform mat4 uModelMat, uViewMat, uProjMat;

void main(){    
    //pass position
    gl_Position = aPosition;
}