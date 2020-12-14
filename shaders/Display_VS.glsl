#version 450
//Code by: Andrew Hunt and Rhys Sullivan

//attribute
layout (location = 0) in vec4 aPosition;

void main(){
	//pass position
    gl_Position = aPosition;
}