/*Author: Anrdew Hunt
Class : GPR-200-02
Assignment : Lab 1: Hello Modern Graphics!
Date Assigned : 9/3/2020
Due Date : 9/11/2020
Description : Functions definitions of ray manipulations, coloring, and pixel rendering

Sources Used: https://raytracing.github.io/books/RayTracingInOneWeekend.html
How it was Used: Read his rendering pipeline and built it based on principles learned from him
 */

#include "gpro/test/RayFunctions.h"

floatv ray_len(vec3 temp, float t, ray r) {
	//Return the sum of the first index of the ray with the quotient of the length and vec3 of the second ray index
	return vec3sum(temp, r[0], vec3multiD(t, r[1]));
}

floatv ray_color(vec3 temp, ray r) {
	vec3 point3;//point3 for circle position
	float t;//t will be used for multiple calculations

	//initialize circles position and radius and check for ray hit on the circle
	point3[0] = 0.0f;
	point3[1] = 0.0f;
	point3[2] = -1.0f;
	t = hit_sphere(point3, 0.5f, r);

	//change color to normals if hit
	if (t > 0.0f) {

		//calculations for normal colors
		vec3 subVec = { 0.0f, 0.0f, -1.0f };
		vec3 N;
		ray_len(N, t, r);
		vec3sub(N, subVec);
		unit_vector(N);

		//create normal colors
		vec3 color = { N[0] + 1.0f, N[1] + 1.0f, N[2] + 1.0f };
		vec3multiD(0.5f, color);
		return vec3copy(temp, color);
	}

	//initialize circles position and radius and check for ray hit on the circle
	point3[0] = 0.0f;
	point3[1] = -100.0f;
	point3[2] = -1.0f;
	t = hit_sphere(point3, 97.0f, r);

	//change color to green if hit
	if (t > 0.0f) {
		//create ground color
		//vec3 color = { 36.0f / 255.0f, 169.0f / 255.0f, 57.0f / 255.0f };
		//return vec3copy(temp, color);
		//calculations for normal colors
		vec3 subVec = { 0.0f, 0.0f, -1.0f };
		vec3 N;
		ray_len(N, t, r);
		vec3sub(N, subVec);
		unit_vector(N);

		//create normal colors
		vec3 color = { N[0] + 1.0f, N[1] + 1.0f, N[2] + 1.0f };
		vec3multiD(0.5f, color);
		return vec3copy(temp, color);
	}

	//if the rays have not hit a single target calculate sky blue color for the background
	vec3 unit_direction;
	vec3copy(unit_direction, r[1]);
	unit_vector(unit_direction);
	t = 0.5f * (unit_direction[1] + 1.0f);
	vec3 color1 = { 1.0f, 1.0f, 1.0f };
	vec3 color2 = { 0.5f, 0.7f, 1.0f };
	return vec3sum(temp, vec3multiD(1.0f - t, color1), vec3multiD(t, color2));
}

float hit_sphere(vec3 center, float radius, ray const r) {
	vec3 oc; //create an empty vec 3 and prepare the vector test
	vec3diff(oc, r[0], center);

	//gather each ray collision data (the position of inpact along the ray)
	float a = dot(r[1], r[1]);
	float b = 2.0f * dot(oc, r[1]);
	float c = dot(oc, oc) - radius * radius;
	float discriminant = (b * b) - 4.0f * a * c;

	//return a negative value 
	if (discriminant < 0) {
		return -1.0f;
	}
	else {
		//return the ray length
		float discriminant_result = -b - ((float)sqrt(discriminant));
		return discriminant_result / (2.0f * a);
	}
}

void draw_color(FILE* fout, vec3 pixel_color) {
	int ir = (int)(255.999 * pixel_color[0]); //the red channel value calculation
	int ig = (int)(255.999 * pixel_color[1]); //the green channel value calculation
	int ib = (int)(255.999 * pixel_color[2]); //the blue channel value calculation

	//print out each value on a line
	fprintf(fout, "%d ", ir);
	fprintf(fout, "%d ", ig);
	fprintf(fout, "%d\n", ib);
}