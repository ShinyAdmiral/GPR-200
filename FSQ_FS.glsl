#version 450

layout (location = 0) in vec4 aPosition;
layout (location = 2) in vec2 aTexcoord;

uniform mat4 uModelMat, uViewMat, uProjMat;
uniform vec2 uResolution;

void main(){    
    //Clip
    //PERSPECTIVE
    
    vec2 scale = 1.0 / uResolution;
    
    gl_Position = aPosition;// * vec4(scale.x, scale.y, 1.0, 1.);
}