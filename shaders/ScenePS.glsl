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

void main()
{
	vec4 color = texture(uTextureMap, vTexcoord.xy);
	
	pointLight light;
	light.center = uModelMat * uViewMat * vec4(-4.0, -4.0, -2.0, 1.0);
	light.color = vec4(1.0);
	light.intensity = 1000.0;
	
	vec3 amb = vec3(0.01);
	
	//calc Light diffuse and normalize it
	//space mismatch (object space position needs fix)
    vec3 lightNormal = normalize(light.center.xyz - vPosition.xyz);
	vec3 normal = normalize(vNormal);
	
	//calculate the light diffuse coefficient 
	float diffCo = max(0.0, dot(-lightNormal, normal));
	
	vec3 diffuse = vec3(1.0) *  diffCo;

	//calc Attenuation
	//redundant
	float d = distance(light.center.xyz, vPosition.xyz);
	
	float attenIn = 1.0/(1.0 + d / light.intensity + (d * d)/ (light.intensity * light.intensity));
	
	
	//calculate phong reflectance
    float specularCo, specularIn;   
    
	vec3 viewNormal = normalize(vCamPos.xyz - vPosition.xyz);//aPosition.xyz; // View Vector
	vec3 reflection = reflect(-lightNormal, normal);

    
    specularCo = max(0.0, dot(viewNormal, reflection));
            
    //calc specular intensity
    specularIn = specularCo * specularCo;
    specularIn *= specularIn; //^4
    specularIn *= specularIn; //^8
    specularIn *= specularIn; //^16
    
    vec3 specular = vec3(specularIn) * diffuse; 
	
	//calc color with light
	vec3 lightColor = diffuse * attenIn + amb * light.color.xyz;
	color *= vec4(lightColor, 1.0);
	color += vec4(specular,1.0);
	
	rtFragColor = color;
}