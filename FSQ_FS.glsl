#version 450

//input and output
layout (location = 0) out vec4 rtFragColor;
layout (location = 1) in vec4 gl_FragCoord;

//varrying input
in vec2 vTexcoord;

//uniform vec2 uResolution;
uniform sampler2D uTex;
uniform float uTime;
uniform vec2 uResolution;

//------------------------------------------
//DATA STRUCTURES
//------------------------------------------

//data structure for sphere
struct sphere{
	vec4 center; //center point of sphere
    float radius;//radius of sphere
};

//data structure for light
struct pointLight {
	vec4 center; 	 // center point of light
    vec4 color;		 // color of light
    float intensity; // intensity of light
};

//------------------------------------------
// FUNCTIONS
//------------------------------------------

// calcViewport:   calculate the viewing plane (viewport) coordinate
//    viewport:       output viewing plane coordinate
//    ndc:            output normalized device coordinate
//    uv:             output screen-space coordinate
//    aspect:         output aspect ratio of screen
//    resolutionInv:  output reciprocal of resolution
//    viewportHeight: input height of viewing plane
//    fragCoord:      input coordinate of current fragment (in pixels)
//    resolution:     input resolution of screen (in pixels)
void calcViewport(out vec3 viewport, out vec2 ndc, out vec2 uv,
                  out float aspect, out vec2 resolutionInv,
                  in float viewportHeight, in float focalLength,
                  in vec2 fragCoord, in vec2 resolution){
    // inverse (reciprocal) resolution = 1 / resolution
    resolutionInv = 1.0 / resolution;
    
    // aspect ratio = screen width / screen height
    aspect = resolution.x * resolutionInv.y;

    // uv = screen-space coordinate = [0, 1) = coord / resolution
    uv = fragCoord * resolutionInv;

    // ndc = normalized device coordinate = [-1, +1) = uv*2 - 1
    ndc = uv * 2.0 - 1.0;

    // viewport: x = [-aspect*h/2, +aspect*h/2), y = [-h/2, +h/2), z = -f
    viewport = vec3(ndc * vec2(aspect, 1.0) * (viewportHeight * 0.5), -focalLength);
}

// calcRay: calculate the ray direction and origin for the current pixel
//    rayDirection: output direction of ray from origin
//    rayOrigin:    output origin point of ray
//    viewport:     input viewing plane coordinate (use above function to calculate)
//    focalLength:  input distance to viewing plane
void calcRay(out vec4 rayDirection, out vec4 rayOrigin,
             in vec3 eyePosition, in vec3 viewport){
    // ray origin relative to viewer is the origin
    // w = 1 because it represents a point; can ignore when using
    rayOrigin = vec4(eyePosition, 1.0);

    // ray direction relative to origin is based on viewing plane coordinate
    // w = 0 because it represents a direction; can ignore when using
    rayDirection = vec4(viewport - eyePosition, 0.0);
}

// calcColor: calculate the color of a pixel given a ray
//    rayDirection: input ray direction
//    rayOrigin:    input ray origin
//	  viewport: 	viewport of our imaginary camera
//	  obj:			different spheres to render
vec4 calcColor(in vec4 rayDirection, in vec4 rayOrigin, in vec3 viewport, sphere obj[5]){
	//setup
	vec3 dp;
	vec4 color = vec4(0.0);
	bool hit = false;
	
	//setup light
	pointLight light;
	light.center = vec4(-0.75, 0.5, 1.0, 1.0);
	light.color = vec4(1.0);
	light.intensity = 100.0;
	
	
	for (int i = 0; i < 5; i ++){
	    dp.xy = rayDirection.xy - obj[i].center.xy;
	    
	    //check if hitting surface
	    float lSq = dot(dp.xy, dp.xy),
	          rSq = obj[i].radius * obj[i].radius;
	    if (lSq <= rSq){
	    	//calc sphere
	        dp.z = rSq - lSq;
	        
	        //calc position and normalize it
	        vec3 position = obj[i].center.xyz + vec3(dp.x, dp.y, sqrt(dp.z));
	        vec3 N = (position - obj[i].center.xyz) / obj[i].radius;
	        
	        //calculate light
        	float diffCo, attenIn, d, diffIn;
        	
            //calc Light diffuse and normalize it
            vec3 L = normalize(light.center.xyz - dp);
        	
            //calculate the light diffuse coefficient 
        	diffCo = max(0.0, dot(N, L));
            
            //calc distance from light to surface
        	d = distance(dp, light.center.xyz);
            
            //calc Attenuation
        	attenIn = 1.0/(1.0 + d / light.intensity + (d * d)/ (light.intensity * light.intensity));
        	
            //calc diffuse intensity
        	diffIn = diffCo * attenIn;
        	
        	//calc color
        	vec3 lightcolor = diffIn * vec3(0.7, 1.0,1.0);
	        
	        //no phong since its a bit hard to see whith it being small
	        
	        //add color
	        color += vec4(lightcolor, 1.0);
	        hit = true;
	    }    
    }
    
    if (hit){
    	return color;
    }
    
    //return texture if not hit
	return texture(uTex, vTexcoord);
}

void main()
{
	//declare 5 objects
	sphere obj[5];
	
	//----------------------------------------------------
	// SPHERE DECLARATION
	//----------------------------------------------------
	
	// declare each objects position, radius, and animation
	obj[0].center = vec4(0.0);
	obj[0].radius = 0.025;
	obj[0].center.x += sin(uTime * 5)/7.0;
	obj[0].center.y = mod(obj[0].center.y + uTime, 2.2) - 1.0;
	
	obj[1].center = vec4(-0.25, 0.0, 0.0, 1.0);
	obj[1].radius = 0.035;
	obj[1].center.x += sin(uTime * 2)/7.0;
	obj[1].center.y = mod(obj[1].center.y + uTime * 0.5, 2.2) - 1.0;
	
	obj[2].center = vec4(0.25, 0.0, 0.0, 1.0);
	obj[2].radius = 0.020;
	obj[2].center.x += sin(uTime * 3)/7.0;
	obj[2].center.y = mod(obj[2].center.y + uTime * 1.2, 2.2) - 1.0;
	
	obj[3].center = vec4(-0.5, 0.0, 0.0, 1.0);
	obj[3].radius = 0.045;
	obj[3].center.x += sin(uTime * 6)/7.0;
	obj[3].center.y = mod(obj[3].center.y + uTime * 0.9, 2.2) - 1.0;
	
	obj[4].center = vec4(0.5, 0.0, 0.0, 1.0);
	obj[4].radius = 0.035;
	obj[4].center.x += sin(uTime * 4)/7.0;
	obj[4].center.y = mod(obj[4].center.y + uTime * 0.8, 2.2) - 1.0;
	
	//----------------------------------------------------
	// VIEWPORT AND COLOR
	//----------------------------------------------------
	
	// viewing plane (viewport) info
	vec3 viewport;
    vec2 ndc, uv, resolutionInv;
    float aspect;
    const float viewportHeight = 2.0, focalLength = 1.0;
    
	// ray
    vec4 rayDirection, rayOrigin;

    // setup
    vec4 color = vec4(0.0);
    
    calcViewport(viewport, ndc, uv, aspect, resolutionInv,
    	             viewportHeight, focalLength,
    	             gl_FragCoord.xy, uResolution.xy);
          
    calcRay(rayDirection, rayOrigin, vec3(0.0), viewport);
    
    //get color
    color += calcColor(rayDirection, rayOrigin, viewport, obj);
	
	//output
	rtFragColor = color;
}