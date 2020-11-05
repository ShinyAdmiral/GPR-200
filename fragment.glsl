#version 450

//Lighting Code by: Andrew Hunt and Aiden Wright
//GPR-200-02
//Assignment: Lab 7
//Due Date: 5 November 2020

//Sources Used: GLSL STARTER CODE BY DANIEL S. BUCKSTEIN
//How it was Used: To get us started

#define Verte
#define Cel
#define Texture
#define ViewSpac

layout (location = 0) out vec4 rtFragColor;

//------------------------------------------
//Uniforms
//------------------------------------------

uniform sampler2D uTextureMap;

//------------------------------------------
//DATA STRUCTURES
//------------------------------------------

//data structure for light
struct pointLight {
	vec4 center; 	 // center point of light
    vec4 color;		 // color of light
    float intensity; // intensity of light
};

//------------------------------------------
//VARRYING
//------------------------------------------

//PER-Vertex: recieve the final color
in vec4 vColor;

//PER-FRAGMENT: receive stuff, used, fro final, color
in vec4 vNormal;

in vec4 vPosition;

in vec4 vCamPos; 

//in vec2 vTexcoord;
in vec4 vTexcoord;

in pointLight[3] lights;

void main(){
	// --------------------------------------------------------
	// CALC LIGHT
	// --------------------------------------------------------
	
	vec3 color = vec3(0.0);
	
	for (int i = 0; i < 3; i ++){
	
		//calc Light diffuse and normalize it
	    vec3 l = normalize(lights[i].center.xyz - vPosition.xyz);
			
		//calculate the light diffuse coefficient 
		float diffCo = max(0.0, dot(vNormal.xyz, l));
		
		//calc Attenuation
		float d = distance(lights[i].center.xyz, vPosition.xyz);
		
		float attenIn = 1.0/(1.0 + d / lights[i].intensity + (d * d)/ (lights[i].intensity * lights[i].intensity));
		
		rtFragColor = vec4(diffCo * attenIn);
		
		
		//calculate phong reflectance
	    float specularCo, specularIn;   
	    
	    vec3 L = normalize(lights[i].center.xyz - vPosition.xyz); // Light Vector
	    
	    #ifdef ViewSpace
	    	vec3 V = normalize(vCamPos.xyz - vPosition.xyz);//aPosition.xyz; // View Vector
	    	vec3 R = reflect(L, vNormal.xyz);
	    
	    #else
	    	vec3 V = vPosition.xyz; // View Vector
	    	vec3 R = reflect(-L, vNormal.xyz);
	    #endif
	    
	    specularCo = max(0.0, dot(V, R));
	            
	    //calc specular intensity
	    specularIn = specularCo * specularCo;
	    specularIn *= specularIn; //^4
	    specularIn *= specularIn; //^8
	    specularIn *= specularIn; //^16
	    
	    //calc color with light
		color += vec3(diffCo * attenIn * lights[i].color + specularIn);
	}
	
	#ifdef Cell
	vec4 lightColor = vec4(color,1.0);
	float cells = 6.0;
	float cellColor = lightColor.x * cells;
	
	rtFragColor = vec4(0.0, floor(cellColor)/cells, floor(cellColor)/-cells + 1.0, 1.0);
	#else
		rtFragColor = vec4(color,1.0);
	#endif
	
	#ifdef Vertex
	//PER-VERTEX: Input is just final color
	rtFragColor = vColor;
	#endif
	
	#ifdef Texture
		rtFragColor *= texture(uTextureMap, vec2(1., -1.) * vTexcoord.xy);
	#endif
}