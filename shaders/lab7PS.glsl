#version 450

#ifdef GL_ES
precision highp float;
#endif

layout (location = 0) out vec4 rtFragColor;
//out vec4 rtFragColor;


//DATA STRUCTURES
//data structure for light
struct pointLight {
	vec4 center; 	 // center point of light
    vec4 color;		 // color of light
    float intensity; // intensity of light
};

//VARRYING
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
	
	//PER-FRAGMENT: calculate final color here using inputs
	vec4 N = normalize (vNormal);
	vec4 normalColors = vec4(0.0, 0.0, 0.0, 1.0);//vec4(N.xyz * 0.5 + 0.5, 1.0);
	rtFragColor = normalColors;
	
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
	    
	    vec3 V = normalize(vCamPos.xyz - vPosition.xyz);//aPosition.xyz; // View Vector
	    vec3 R = reflect(L, vNormal.xyz);
	    
	    //vec3 V = vPosition.xyz; // View Vector
	    //vec3 R = reflect(-L, vNormal.xyz);
	    
	    specularCo = max(0.0, dot(V, R));
	            
	    //calc specular intensity
	    specularIn = specularCo * specularCo;
	    specularIn *= specularIn; //^4
	    specularIn *= specularIn; //^8
	    specularIn *= specularIn; //^16
		
		color += vec3(diffCo * attenIn * lights[i].color + specularIn);
		//color += vec3(specularIn);
	}
	
	rtFragColor = vec4(color,1.0);
	//rtFragColor = N;
	
	//PER-VERTEX: Input is just final color
	//rtFragColor = vColor;
	
	//rtFragColor = vec4(vTexcoord, 0.0, 1.0);
	//rtFragColor = vTexcoord;
}