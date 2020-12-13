#version 450

uniform mat4 matView;
uniform mat4 matProj;
uniform mat4 matGeo;
uniform float matMaxHeight;
uniform sampler2D noiseTex;
uniform sampler2D colorTex;
layout (binding = 2) uniform sampler2D waterTex;
uniform float iTime;
uniform bool water;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec2 texCoord;

out vec4 vNormal;
out vec4 vLightPos1;
out vec4 vLightPos2;
out vec3 VRayPos;
out vec4 vPosition;
out vec2 bWater;
out float noiseInfo;

void doDisplacementFromMap(float maxHeight, sampler2D tex)
{
	vPosition = vec4(pos, 1.);
	vec2 lookUp = texCoord;
	float origin = texture(tex, lookUp).r;
	noiseInfo = origin;
	float dif = 1./10.; 
	vec3 topOffset   = vec3(0.,dif, 0.);
	vec3 bottomOffset= vec3(0.,-dif, 0.) ;
	vec3 rightOffset =  vec3(-dif, 0., 0.);
	vec3 leftOffset  = vec3(dif, 0., 0.);
	topOffset.z =    texture(tex, lookUp + topOffset.xy).r;
	bottomOffset.z = texture(tex, lookUp + bottomOffset.xy).r;
	leftOffset.z =   texture(tex, lookUp + leftOffset.xy).r;
	rightOffset.z =  texture(tex, lookUp + rightOffset.xy).r;			
	vPosition.x += origin * maxHeight;
	
	// uv & sample
	vec3 deltaHoriz = topOffset-bottomOffset;
	vec3 deltaVertical = rightOffset-leftOffset;
	vNormal = vec4(cross(deltaHoriz, deltaVertical), 1.);
	vNormal = normalize(vNormal);
}

void main() 
{
	float maxHeight;
	if(water)
	{
		bWater = vec2(1.,1.);
		maxHeight = 0;
		doDisplacementFromMap(1, waterTex);
	}
	else
	{
		bWater = vec2(0.,0.);
		maxHeight = 3.5;
		doDisplacementFromMap(1., noiseTex);
	}
	
	
	//POSITION PIPELINE
	mat4 modelViewMat = matProj * matView * matGeo;
	
	VRayPos = (modelViewMat*vec4(0.0)).xyz;
	vLightPos1 = vec4(0,100,0,1000);


	gl_Position = modelViewMat * vPosition;	
	vPosition = vec4(vPosition.xyz, 0.);
}
