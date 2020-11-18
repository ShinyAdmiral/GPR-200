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

uniform mat4 uModelMat, uViewMat, uProjMat;
uniform sampler2D uTextureMap;

//in vec4 vPosClip;
in vec3 vNormal;
in vec4 vPosition;
in vec4 vTexcoord;
in vec4 vCamPos;
in pointLight light[3];

void main()
{
	vec4 color = texture(uTextureMap, vTexcoord.xy);
	
	vec4 lightColor = vec4(0.0);
	
	for (int i = 0; i < 3; i++){
		//calc Light diffuse and normalize it
		//space mismatch (object space position needs fix)
	    vec3 lightNormal = normalize(light[i].center.xyz - vPosition.xyz);
		vec3 normal = normalize(vNormal);
		
		//calculate the light diffuse coefficient 
		float diffCo = max(0.0, dot(lightNormal, normal));
		
		vec3 diffuse = vec3(1.0) *  diffCo;
	
		//calc Attenuation
		//redundant
		float d = distance(light[i].center.xyz, vPosition.xyz);
		
		float attenIn = 1.0/(1.0 + d / light[i].intensity + (d * d)/ (light[i].intensity * light[i].intensity));
		
		//calculate phong reflectance
	    float specularCo, specularIn;   
	    
		vec3 reflection = reflect(lightNormal, normal);
	
	    
	    specularCo = max(0.0, dot(-lightNormal, reflection));
	            
	    //calc specular intensity
	    specularIn = specularCo * specularCo;
	    specularIn *= specularIn; //^4
	    specularIn *= specularIn; //^8
	    specularIn *= specularIn; //^16
	    
	    vec3 specular = vec3(specularIn) * diffuse; 
		
		//calc color with light
		vec3 lightResult = diffuse * attenIn * light[i].color.xyz + specular;
		lightColor += vec4(lightResult, 1.0);
	}
	
	rtFragColor = lightColor * color;
}