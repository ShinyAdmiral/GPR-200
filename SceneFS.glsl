#version 450

//input consts
const int T = 84; //Texture
const int P = 80; //Phong
const int L = 76; //Light

//output
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

//uniforms and textures
uniform mat4 uModelMat, uViewMat, uProjMat;
uniform sampler2D uTextureMap;
uniform sampler2D uKeyboard;

//input from vertex
in vec3 vNormal;
in vec4 vPosition;
in vec4 vTexcoord;
in vec4 vCamPos;
in pointLight light[3];

void main()
{
	//gather input
	float toggleTexture = 1.0 - texelFetch(uKeyboard, ivec2(T	, 0), 0).x;
	float togglePhong 	= 1.0 - texelFetch(uKeyboard, ivec2(P	, 0), 0).x; 
	float toggleLight 	= 1.0 - texelFetch(uKeyboard, ivec2(L	, 0), 0).x; 
	
	//start with texture for color
	vec4 color = texture(uTextureMap, vTexcoord.xy) * toggleTexture;
	color += vec4(0.5) * (1.0 - toggleTexture);
	
	//start with black for light
	vec4 lightColor = vec4(0.0);
	
	//loop for each light
	for (int i = 2; i >= 0; --i){
		//calc Light diffuse and normalize it
	    vec3 lightNormal = normalize(light[i].center.xyz - vPosition.xyz);
		vec3 normal = normalize(vNormal);
		
		//calculate the light diffuse coefficient 
		float diffCo = max(0.0, dot(lightNormal, normal));
	
		//calc Attenuation
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
	    
	    //make sure specular does not go through
	    vec3 specular = vec3(specularIn) * diffCo * togglePhong; 
		
		//calc color with light
		vec3 lightResult = diffCo * attenIn * light[i].color.xyz * toggleLight + specular;
		lightColor += vec4(lightResult, 1.0);
	}
	
	//output final color
	rtFragColor = lightColor * color;
	rtFragColor += color * (1.0 - toggleLight);
}