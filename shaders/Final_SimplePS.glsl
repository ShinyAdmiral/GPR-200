#version 450

out vec4 outColor;
in vec2 bWater;
in float noiseInfo;
//PER-FRAGMENT: recieving stuff used for final color
in vec4 vNormal;
in vec4 vLightPos1;
in vec4 vLightPos2;
in vec3 VRayPos;
in vec4 vPosition;

uniform sampler2D noiseTex;
uniform sampler2D colorTex;

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
	vec4 surfaceColor =  texture(colorTex, vec2(1-noiseInfo-.20, 0.) * .8);
    float Lambertian = diffuseCoefficient * attenuation; // final lambertian

   // PHONG REFLECTANCE
        
    vec3 viewVector = normalize(rayOrigin.xyz - position.xyz);
    vec3 reflectedLightVector =reflect(-normalize(lightVector).xyz, 
                                           normal.xyz);
    float specular = max(0.0, dot(viewVector, reflectedLightVector));
    specular *= specular; // specularCoefficient^2
    specular *= specular; // specularCoefficient^4
    specular *= specular * specular * specular; // specularCoefficient^16
    specular *= specular * specular * specular; // specularCoefficient^64

	if(bWater.x > 0)
	{
		surfaceColor = vec4(0.,0.,1.,1);
		return (0.15 + (Lambertian + specular) * lightcolor) * surfaceColor; //Phong color
	}
    return 0.05 + Lambertian  * lightcolor* surfaceColor; //Phong color
    
}



void main() 
{
	outColor = calcLighting(vLightPos1,vec4(1.0),vLightPos1.w, vPosition,vNormal.xyz,VRayPos);	
}