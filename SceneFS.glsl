#version 450

layout (location = 0) out vec4 rtFragColor;

//------------------------------------------
//DATA STRUCTURES
//------------------------------------------

//data structure for light
struct pointLight {
	vec4 center; 	 // center point of light
    vec4 color;		 // color of light
    float intensity; // intensity of light
};

//in vec4 vPosClip;
in vec3 vNormal;
in vec4 vPosition;
in vec4 vTexcoord;
in vec4 vCamPos;

uniform sampler2D uTextureMap;

void main()
{
	vec4 color = texture(uTextureMap, vTexcoord.xy);
	
	pointLight light;
	light.center = vec4(4.0, 4.0, 2.0, 1.0);
	light.color = vec4(1.0);
	light.intensity = 1000.0;
	
	
	//calc Light diffuse and normalize it
    vec3 l = normalize(light.center.xyz - vPosition.xyz);
		
	//calculate the light diffuse coefficient 
	float diffCo = max(0.0, dot(vNormal.xyz, l));
	
	//calc Attenuation
	float d = distance(light.center.xyz, vPosition.xyz);
	
	float attenIn = 1.0/(1.0 + d / light.intensity + (d * d)/ (light.intensity * light.intensity));
	
	rtFragColor = vec4(diffCo * attenIn);
	
	
	//calculate phong reflectance
    float specularCo, specularIn;   
    
    vec3 L = normalize(light.center.xyz - vPosition.xyz); // Light Vector
    
	vec3 V = normalize(normalize(vPosition.xyz) + 0.5);//aPosition.xyz; // View Vector
	vec3 R = reflect(-L, vNormal.xyz);

    
    specularCo = max(0.0, dot(V, R));
            
    //calc specular intensity
    specularIn = specularCo * specularCo;
    specularIn *= specularIn; //^4
	
	
	
	//calc color with light
	color *= vec4(diffCo * attenIn * light.color + specularIn) * 1.5;
	
	rtFragColor = color;
	//rtFragColor = vec4(1.0);
}