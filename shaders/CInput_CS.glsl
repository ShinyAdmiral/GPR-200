#version 450


layout (local_size_x = 1, 
		local_size_y = 1,
		local_size_z = 1) in;

layout (binding = 0) buffer bInput{
	vec4 keyInputs;
};

layout (binding = 0) uniform sampler2D uKeyboard;
uniform float uDelta;

const int KEY_FORWARD 		= 87;	//W key
const int KEY_BACKWARD 		= 83;	//S key

const int KEY_LEFT 			= 68;	//D key
const int KEY_RIGHT 		= 65;	//A key

const int KEY_UP 			= 73;	//I key
const int KEY_DOWN 			= 74;	//K key

const int KEY_RIGHT_ARROW 	= 75;	//J key
const int KEY_LEFT_ARROW	= 76;	//L key

const int SPACE 			= 32;	//Space

void main(){
	float speed = 5.0;
	float seedSpeed = 0.0001;

    //gather x input
    keyInputs.x -= texelFetch(uKeyboard, ivec2(KEY_RIGHT	, 0), 0).x * uDelta * speed;
    keyInputs.x += texelFetch(uKeyboard, ivec2(KEY_LEFT		, 0), 0).x * uDelta * speed;
    
    //gather y input
    keyInputs.y -= texelFetch(uKeyboard, ivec2(KEY_BACKWARD	, 0), 0).x * uDelta * speed;
    keyInputs.y += texelFetch(uKeyboard, ivec2(KEY_FORWARD	, 0), 0).x * uDelta * speed;
    
    //gather input for z
    keyInputs.z += texelFetch(uKeyboard, ivec2(KEY_UP		, 0), 0).x * uDelta * seedSpeed;
    keyInputs.z -= texelFetch(uKeyboard, ivec2(KEY_DOWN		, 0), 0).x * uDelta * seedSpeed;
    
    //gather input for w
    keyInputs.w += texelFetch(uKeyboard,ivec2(KEY_RIGHT_ARROW,0), 0).x * uDelta * seedSpeed;
    keyInputs.w -= texelFetch(uKeyboard, ivec2(KEY_LEFT_ARROW,0), 0).x * uDelta * seedSpeed;
    
    //gather input from space
    float reset  = texelFetch(uKeyboard, ivec2(SPACE		, 0), 0).x;
    reset = 1 - reset;
    
    keyInputs   *= reset;
}