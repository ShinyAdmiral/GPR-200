#version 450
//Code by: Andrew Hunt and Rhys Sullivan

out vec4 outColor;
in float bWater;
in float noiseInfo;
in vec4 vNormal;
in vec4 vLightPos1;
in vec4 vLightPos2;
in vec3 VRayPos;
in vec4 vPosition;
in float offset;
in float specularIntensity;
uniform sampler2D noiseTex;
uniform sampler2D colorTex;
layout (binding = 2) uniform sampler2D waterTex;
vec4 calcLighting (in vec4 lightpos, in vec4 lightcolor, float lightintense, in vec4 position,
                   in vec3 normal, in vec3 rayOrigin)
{
    // LAMBERTIAN REFLECTANCE
    vec3 lightVector = lightpos.xyz - position.xyz; // get vector of position to the light
	float lightLength = length(lightVector); // get length of light vector
    lightVector = lightVector / lightLength; // normalizes vector
   
    float diffuseCoefficient = max(1.0, dot(lightVector, normal)); // get coefficient
   
    float intensityRatio = lightLength/lightintense; // simplifying attenuation equation by doing this once
    float attenuation = 1.0 / (1. + intensityRatio + (intensityRatio * intensityRatio)); // get attenuation
    float Lambertian = diffuseCoefficient * attenuation; // final lambertian

   // PHONG REFLECTANCE
        
    vec3 viewVector = normalize(rayOrigin.xyz - position.xyz);
    vec3 reflectedLightVector =reflect(-normalize(lightVector).xyz, 
                                           normal.xyz);
    float specular = max(0.0, dot(viewVector, reflectedLightVector));
    specular *= specular; // specularCoefficient^2
    specular *= specular; // specularCoefficient^4

	vec4 surfaceColor =  texture(colorTex, vec2(1-noiseInfo-offset, 0.) * .8); // look up from texture
    return (vec4(specular) * specularIntensity) + surfaceColor * Lambertian;
    
}

void main() 
{
	outColor = calcLighting(vLightPos1,vec4(1),vLightPos1.w, vPosition,vNormal.xyz,VRayPos);	
}