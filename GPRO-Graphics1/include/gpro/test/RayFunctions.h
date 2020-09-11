/*Author: Anrdew Hunt
Class : GPR-200-02
Assignment : Lab 1: Hello Modern Graphics!
Date Assigned : 9/3/2020
Due Date : 9/11/2020
Description : Functions declarations for ray functions.

Sources Used: https://raytracing.github.io/books/RayTracingInOneWeekend.html
 */

#pragma once
#ifndef RAY_H
#define RAY_H
#include "math.h"
#include "gpro/gpro-math/gproVector.h"
#include <stdio.h>
#include <stdlib.h>

typedef vec3 ray[2];		//stores two vec3's point3(origin) and vec3(direction)
typedef vec3* rayp;			// generic float vector (pointer)
typedef vec3 const* raykp;	// generic constant float vector (pointer)

floatv ray_len(vec3 temp, float t, ray r);					//Return the sum of the first index of the ray with the quotient of the length and vec3 of the second ray index 

float hit_sphere(vec3 center, float radius, ray const r);	//test to see if it hits a sphere (and check the normals)

floatv ray_color(vec3 temp, ray r);							//set the ray color

void draw_color(FILE* fout, vec3 pixel_color);				//darw the color of the pixel to the screen
#endif