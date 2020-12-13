#version 450

layout (location = 0) in vec4 aPosition;
//layout (location = 2) in vec2 aTexcoord;

//varraying
out vec2 vTexcoord;

void main(){
	//pass position
    gl_Position = aPosition;
    
    //get proper ndc
    vTexcoord = aPosition.xy * 0.5f + 0.5f;
}