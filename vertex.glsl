#version 450

// MAIN DUTY: PROCESS ATTRIBUTES
// e.g. 3D position in space
// e.g. normal
// e.g. 2D uv: texture coordinate
layout (location = 0) in vec4 aPosition;
layout (location = 1) in vec3 aNormal;
//in vec4 aPosition;

// e.g. 2D uv: textuure coordinate
//Texture Space

layout (location = 2) in vec4 aTexcoord;

// TRANSFORM UNIFORMS
uniform mat4 uModelMat;
uniform mat4 uViewMat;
uniform mat4 uProjMat;
uniform mat4 uViewProjMat;

//DATA STRUCTURES
//data structure for light
struct pointLight {
	vec4 center; 	 // center point of light
    vec4 color;		 // color of light
    float intensity; // intensity of light
};


//VARRYING

//PER-Vertex: send final color
out vec4 vColor;

//PER-FRAGMENT: send stuff to the FS to calc final color
out vec4 vPosition; 

out vec4 vNormal; 

out vec4 vCamPos; 

out vec4 vTexcoord;

out pointLight[3] lights;

void main(){
	//vPosition = aPosition;
	
	// REQUIRED: set this value:
	// problem: gl_positionin in "clip-sapce"
	// problem: aPositin is in "object-space"
	//gl_Position = aPosition;
	
	//position in world-space (wrong)
	vec4 pos_world = uModelMat * aPosition;
	vPosition = pos_world;
	
	//gl_Position = pos_world;
	
	// position camera-space (also wrong))
	//vec4 pos_camera = uViewMat * uModelMat * aPosion;
	//vec4 pos_camera = uViewMat * pos_world;
	//gl_Position = pos_camera;
	
	//Position in clip space
	//vec4 pos_clip = uViewProjMat * pos_world;
	//vec4 pos_clip = uViewProjMat * uViewMat * uModelMat * aPosition;
	//vec4 pos_clip = uViewProjMat * pos_camera;
	//gl_Position = pos_clip;
	
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
	mat4 atlastMat = mat4( 0.5, 0.0, 0.0, 0.0,
						   0.0, 0.5, 0.0, 0.0,
						   0.0, 0.0, 1.0, 0.0,
						   0.25, 0.25, 0.0, 1.0);
	vec4 uv_atlas = atlastMat * aTexcoord;
	
	//PER-VERTEX: pass things that FS need to calc
	vNormal = vec4(norm_camera, 0.0);
	
	
	
	// --------------------------------------------------------
	// CALC LIGHT
	// --------------------------------------------------------
	lights[0].center 	= pos_world + vec4(0.0, 1.0, 0.5, 1.0);
	lights[0].color 	= vec4(0.0, 1.0, 1.0, 1.0);
	lights[0].intensity = 7.0;
	
	lights[1].center 	= pos_world + vec4(-0.5, -1.0, 1.0, 1.0);
	lights[1].color 	= vec4(0.0, 1.0, 0.0, 1.0);
	lights[1].intensity = 4.0;
	
	lights[2].center 	= pos_world + vec4(1.0, -1.0, 0.0, 1.0);
	lights[2].color 	= vec4(1.0, 0.0, 1.0, 1.0);
	lights[2].intensity = 3.0;
	
	
	vec3 color = vec3(0.0);
	/*
	
	vec3 lightForNorm;
	lightForNorm = norm_camera;
	//lightForNorm = aNormal;
	
	
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
	    
	    vec3 V = normalize(pos_camera.xyz - aPosition.xyz);//aPosition.xyz; // View Vector
	   	vec3 R = reflect(L, lightForNorm);
	    
	    //vec3 V = aPosition.xyz; // View Vector
	    //vec3 R = reflect(-L, lightForNorm);
	    
	    specularCo = max(0.0, dot(V, R));
	            
	    //calc specular intensity
	    specularIn = specularCo * specularCo;
	    specularIn *= specularIn; //^4
	    specularIn *= specularIn; //^8
	    specularIn *= specularIn; //^16
	    specularIn *= specularIn; //^32
		
		color += vec3(diffCo * attenIn * lights[i].color + specularIn);
	}
	
	vColor = vec4(color,1.0);
	vNormal = vec4(aNormal, 1.0);
	*/
	
	//Optional: set varyings
	//vColor = vec4 (1.0, 0.5, 0.0, 1.0);
	//vColor = aPosition * 0.5 + 0.5;
	
	vTexcoord = aTexcoord;
	
	gl_Position = pos_clip;
}