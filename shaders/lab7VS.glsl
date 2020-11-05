#version 450

//Lighting Code by: Andrew Hunt and Aiden Wright
//GPR-200-02
//Assignment: Lab 7
//Due Date: 5 November 2020

//Sources Used: GLSL STARTER CODE BY DANIEL S. BUCKSTEIN,
//http://web.engr.oregonstate.edu/~mjb/cs557/Handouts/morph.1pp.pdf
//How it was Used: To get us started, and warping vertexs in a box shape.

//for presentation
#define ViewSpac

#define War

#define Textur


//------------------------------------------
// MAIN DUTY: PROCESS ATTRIBUTES
//------------------------------------------

//3D position in space
layout (location = 0) in vec4 aPosition;

//normal
layout (location = 1) in vec3 aNormal;

//Texture Space
layout (location = 2) in vec4 aTexcoord;

//------------------------------------------
// TRANSFORM UNIFORMS
//------------------------------------------

uniform mat4 uModelMat;
uniform mat4 uViewMat;
uniform mat4 uProjMat;
uniform mat4 uViewProjMat;
uniform sampler2D uTextureMap;
uniform float iTime;

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

//PER-Vertex: send final color
out vec4 vColor;

//PER-FRAGMENT: send stuff to the FS to calc final color
out vec4 vPosition; 

out vec4 vNormal; 

out vec4 vCamPos; 

out vec4 vTexcoord;

out pointLight[3] lights;

void main(){
	//position in world-space
	vec4 pos_world = uModelMat * aPosition;
	vPosition = pos_world;
	
	// POSITION PIPELINE
	mat4 modelViewMat = uViewMat * uModelMat;
	vec4 pos_camera = modelViewMat * aPosition;
	vCamPos = pos_camera;
	vec4 pos_clip = uProjMat * pos_camera;
	
	// NORMAL PIPELINE
	mat3 normalMat = transpose(inverse(mat3(modelViewMat)));
	vec3 norm_camera = normalMat * aNormal;															
	//vec3 norm_camera = mat3(modelViewMat) * aNormal;
	
	//TEXCOORD PIPELINE
	//for drawing parts of the texture                                          
	mat4 atlastMat = mat4(0.5, 0.0, 0.0, 0.0,
						 0.0, 0.5, 0.0, 0.0,
						 0.0, 0.0, 1.0, 0.0,
						 0.25,0.25,0.0,1.0);
	vec4 uv_atlas = atlastMat * aTexcoord;
	
	//PER-VERTEX: pass things that FS need to calc
	vNormal = vec4(norm_camera, 0.0);
	
	// --------------------------------------------------------
	// CALC LIGHT
	// --------------------------------------------------------
	lights[0].center 	= pos_world + vec4(0.0, 1.0, 0.5, 1.0);
	lights[0].color 	= vec4(1.0);
	lights[0].intensity = 7.0;
	
	lights[1].center 	= pos_world + vec4(-0.5, -1.0, 1.0, 1.0);
	lights[1].color 	= vec4(1.0);
	lights[1].intensity = 4.0;
	
	lights[2].center 	= pos_world + vec4(1.0, -1.0, 0.0, 1.0);
	lights[2].color 	= vec4(1.0);
	lights[2].intensity = 3.0;
	
	//starting color
	vec3 color = vec3(0.0);
	
	//determine normal
	#ifdef ViewSpace
	vec3 lightForNorm = norm_camera;
	
	#else
	vec3 lightForNorm = aNormal;
	#endif
	
	for (int i = 0; i < 3; i ++){
	
		//calc Light diffuse and normalize it
	    vec3 l = normalize(lights[i].center.xyz - aPosition.xyz);
			
		//calculate the light diffuse coefficient 
		float diffCo = max(0.0, dot(lightForNorm, l));
		
		//calc Attenuation
		float d = distance(lights[i].center.xyz, aPosition.xyz);
		
		float attenIn = 1.0/(1.0 + d / lights[i].intensity + (d * d)/ (lights[i].intensity * lights[i].intensity));
		
		//calculate phong reflectance
	    float specularCo, specularIn;   
	    
	    vec3 L = normalize(lights[i].center.xyz - aPosition.xyz); // Light Vector
	    
	    #ifdef ViewSpace
	    vec3 V = normalize(pos_camera.xyz - aPosition.xyz);// View Vector
	   	vec3 R = reflect(L, lightForNorm);
	    
	    #else
	    vec3 V = aPosition.xyz; // View Vector
	    vec3 R = reflect(-L, lightForNorm);
	    #endif
	    
	    specularCo = max(0.0, dot(V, R));
	            
	    //calc specular intensity
	    specularIn = specularCo * specularCo;
	    specularIn *= specularIn; //^4
	    specularIn *= specularIn; //^8
	    specularIn *= specularIn; //^16
	    specularIn *= specularIn; //^32
		
		color += vec3(diffCo * attenIn * lights[i].color + specularIn);
	}
	
	#ifdef Texture
		vColor = vec4(color,1.0) * texture(uTextureMap, aTexcoord.xy);

	
	#else
		vColor = vec4(color,1.0);
	
	#endif
	
	#ifdef ViewSpace
	vNormal = vec4(norm_camera, 1.0);
	
	#else
	vNormal = vec4(aNormal, 1.0);
	#endif
	
	//texture coord
	vTexcoord = aTexcoord;
	
	#ifdef Warp
	//Credit: http://web.engr.oregonstate.edu/~mjb/cs557/Handouts/morph.1pp.pdf
	
	//get side count in relation to time
	float side = sin(iTime) * 0.5 + 2.0;
	
	//start with object in clip space
	vec4 vertex = pos_clip;
	
	//box it 
	vertex.xyz *= 4. / length(vertex.xyz);
	vertex.xyz = clamp( vertex.xyz, -side, side);
	
	gl_Position = vertex;//pos_clip * mod(iTime, 10.0);
	
	#else
	
	vTexcoord = aTexcoord;
	
	gl_Position = pos_clip;
	
	#endif
}