#version 450

//input
layout (location = 0) in vec4 aPosition;

void main(){    
    //pass position
    gl_Position = aPosition;
}