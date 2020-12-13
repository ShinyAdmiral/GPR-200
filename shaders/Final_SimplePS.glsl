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
    //Taken from Lab 4
    // LAMBERTIAN REFLECTANCE
    vec3 lightVector = lightpos.xyz - position.xyz; // get vector of position to the light
	float lightLength = length(lightVector); // get length of light vector
    lightVector = lightVector / lightLength; // normalizes vector
   
    float diffuseCoefficient = max(0.0, dot(lightVector, normal)); // get coefficient
   
    float intensityRatio = lightLength/lightintense; // simplifying attenuation equation by doing this once
    float attenuation = 1.0 / (1.0 + intensityRatio +
                             (intensityRatio * intensityRatio)); // get attenuation
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
   //return vec4(specularCoefficient);
    vec4 ambient = vec4(0.3,0.3,0.3,0.0);
        
    return ambient * 0.15 + (Lambertian + specular) * lightcolor; //Phong color
}



void main() 
{
	if(bWater.x > 0)
	{
		outColor = vec4(0,.4,.8,1);
		return;
	}
	outColor = texture(colorTex, vec2(1-noiseInfo-.20, 0.) * .8);
}