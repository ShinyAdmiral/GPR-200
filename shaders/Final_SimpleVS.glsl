#version 450
//Code by: Andrew Hunt and Rhys Sullivan

uniform mat4 matView;
uniform mat4 matProj;
uniform mat4 matGeo;
uniform float matMaxHeight;
layout (binding = 0) uniform sampler2D noiseTex;
layout (binding = 1) uniform sampler2D colorTex;
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
out float bWater;
out float noiseInfo;
out float offset;
out float specularIntensity;
void doDisplacementFromMap(float maxHeight, sampler2D tex)
{
	vPosition = vec4(pos, 1.);  // take our original position
	vec2 lookUp = texCoord; // get the point of nosie to sample
	float origin = texture(tex, lookUp).r; // get the height we should be at
	vPosition.z += origin * maxHeight;
	noiseInfo = origin; // pass to fragment shader
	
	// calculate normals using rise over runs
	float dif = .1; 
	vec3 topOffset   = vec3(0.,dif, 0.);
	vec3 bottomOffset= vec3(0.,-dif, 0.) ;
	vec3 rightOffset =  vec3(-dif, 0., 0.);
	vec3 leftOffset  = vec3(dif, 0., 0.);
	topOffset.z =    texture(tex, lookUp + topOffset.xy).r;
	bottomOffset.z = texture(tex, lookUp + bottomOffset.xy).r;
	leftOffset.z =   texture(tex, lookUp + leftOffset.xy).r;
	rightOffset.z =  texture(tex, lookUp + rightOffset.xy).r;				
	
	vec3 deltaHoriz = topOffset-bottomOffset;
	vec3 deltaVertical = rightOffset-leftOffset;
	vNormal = vec4(cross(deltaHoriz, deltaVertical), 1.);
	vNormal = normalize(vNormal);
}

void main() 
{
	if(water)
	{
		offset = -.1;
		specularIntensity = 1.5;
		doDisplacementFromMap(0, waterTex);
	}
	else
	{
		offset = .2;
		specularIntensity = .4;
		doDisplacementFromMap(1, noiseTex);
	}
	mat4 modelViewMat = matProj * matView * matGeo;
	VRayPos = (modelViewMat*vec4(0.0)).xyz;
	vLightPos1 = vec4(1,3,2,13);
	gl_Position = modelViewMat * vPosition;	
}
