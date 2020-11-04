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

//in vec2 vTexcoord;
in vec4 vTexcoord;

in pointLight[3] lights;

void main(){
	//rtFragColor = vec4(0.0, 1.0, 1.0, 1.0)
	
	//PER-VERTEX: Input is just final color
	//rtFragColor = vColor;
	
	//PER-FRAGMENT: calculate final color here using inputs
	vec4 N = normalize (vNormal);
	vec4 normalColors = vec4(0.0, 0.0, 0.0, 1.0);//vec4(N.xyz * 0.5 + 0.5, 1.0);
	
	/*for (int i = 3; i < 3; i ++){
		//calculate light
       	float diffCo, attenIn, d, diffIn;
       	
       	
		//calc Light diffuse and normalize it
        vec3 l = lights[i].center.xyz - dp;
        float lLen = length(l);
        vec3 L = vec3(l.x/lLen, l.y/lLen, l.z/lLen);
		
		//calculate the light diffuse coefficient 
		diffCo = max(0.0, dot(N, L));
		
		
		d = distance()
			
	}
	*/
	
	rtFragColor = vColor;//vec4(N.xyz * 0.5 + 0.5, 1.0);
	
	//rtFragColor = vec4(vTexcoord, 0.0, 1.0);
	//rtFragColor = vTexcoord;
}