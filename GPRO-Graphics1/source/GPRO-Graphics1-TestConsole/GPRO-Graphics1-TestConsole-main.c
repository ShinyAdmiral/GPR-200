/*
   Copyright 2020 Daniel S. Buckstein

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

/*
	GPRO-Graphics1-TestConsole-main.c/.cpp
	Main entry point source file for a Windows console application.

	Modified by: ____________
	Modified because: ____________
*/

#include <stdio.h>
#include <stdlib.h>
#include "gpro/test/Ray.h"

using namespace std;

void draw_color(FILE* fout, vec3 pixelColor) {
	int ir = static_cast<int>(255.999 * pixelColor[0]);
	int ig = static_cast<int>(255.999 * pixelColor[1]);
	int ib = static_cast<int>(255.999 * pixelColor[2]);

	fprintf(fout, "%d ", ir);
	fprintf(fout, "%d ", ig);
	fprintf(fout, "%d\n", ib);
}

float hit_sphere(vec3 center, float radius, ray const r) {
	vec3 oc;
	vec3diff(oc, r[0], center);

	float a = dot(r[1], r[1]);
	float b = 2.0f * dot(oc, r[1]);
	float c = dot(oc, oc) - radius * radius;
	float discriminant = (b * b) - 4.0f * a * c;

	if (discriminant < 0) {
		return -1.0f;
	}
	else {
		return (-b - sqrt(discriminant)) / (2.0f * a);
	}
}

floatv ray_color(vec3 temp, ray r){// vec3 *circlePos, float *circleRadius, int iterLength) {
	vec3 point3;
	float t;
	point3[0] = 0.0f;
	point3[1] = 0.0f;
	point3[2] = -1.0f;
	t = hit_sphere(point3, 0.5f, r);

	if (t > 0.0f) {
		//vec3 red = { 1.0f, 0.0f, 0.0f };
		//return vec3copy(temp, red);

		vec3 subVec = {0.0f, 0.0f, -1.0f};

		vec3 N;
		ray_len(N, t, r);
		vec3sub(N, subVec);
		unit_vector(N);

		vec3 color = {N[0] + 1.0f, N[1] + 1.0f, N[2] + 1.0f };
		vec3multiD(0.5f, color);


		return vec3copy(temp, color);
	}

	point3[0] = 0.0f;
	point3[1] = -100.0f;
	point3[2] = -1.0f;
	t = hit_sphere(point3, 97.0f, r);

	if (t > 0.0f) {
		//vec3 red = { 1.0f, 0.0f, 0.0f };
		//return vec3copy(temp, red);

		//vec3 subVec = { 0.0f, 0.0f, -1.0f };

		//vec3 N;
		//ray_len(N, t, r);
		//vec3sub(N, subVec);
		//unit_vector(N);

		vec3 color = { 36.0f / 255.0f, 169.0f / 255.0f, 57.0f / 255.0f };
		//vec3multiD(0.5f, color);


		return vec3copy(temp, color);
	}

	//this returns the color red whenever a ray hits part of the sphere
	/*vec3 point3 = { 0.0f, 0.0f, -1.0f };
	if (hit_sphere(point3, 0.5f, r)) {
		vec3 red = {1.0f, 0.0f, 0.0f};
		return vec3copy(temp, red);
	}*/



	vec3 unit_direction;
	vec3copy(unit_direction, r[1]);
	unit_vector(unit_direction);

	//cout << "\n unit" << unit_direction[0] << " " << unit_direction[1] << " " << unit_direction[2];
	//system("pause");

	t = 0.5f * (unit_direction[1] + 1.0f);

	vec3 color1 = { 1.0f, 1.0f, 1.0f };
	vec3 color2 = { 0.5f, 0.7f, 1.0f };

	return vec3sum(temp, vec3multiD(1.0f-t, color1), vec3multiD(t, color2));
}

int main(int const argc, char const* const argv[])
{
	// Image
	const float aspect_ratio = 16.0f / 9.0f;
	const int image_width = 400;
	const int image_height = static_cast<int>(image_width / aspect_ratio);

	// Camera
	float viewport_height = 2.0f;
	float viewport_width = aspect_ratio * viewport_height;
	float focal_length = 1.0f;


	vec3 origin = { 0.0f, 0.0f, 0.0f };

	vec3 horizontal = { viewport_width, 0.0f, 0.0f };
	vec3 horcopy;
	vec3copy(horcopy, horizontal);

	vec3 vertical = { 0.0f, viewport_height, 0.0f };
	vec3 vercopy;
	vec3copy(vercopy, vertical);

	vec3 corner = { 0.0f, 0.0f, focal_length };

	vec3 lower_left_corner;

	vec3diff(lower_left_corner, origin, vec3div(horcopy, 2));
	vec3sub(lower_left_corner, vec3div(vercopy, 2));
	vec3sub(lower_left_corner, corner);

	// Render
	FILE* fout = fopen("image.ppm", "w");

	fprintf(fout, "P3\n");
	fprintf(fout, "%d ", image_width);
	fprintf(fout, "%d", image_height);
	fprintf(fout, "\n255\n");

	for (int j = image_height - 1; j >= 0; --j) {
		float percentage = 100.0f - ((float(j) / float(image_height - 1)) * 100.0f);

		printf("\rProgress: %f%%", percentage);

		for (int i = 0; i < image_width; ++i) {
			float u = float(i) / float(image_width - 1);
			float v = float(j) / float(image_height - 1);

			ray r;
			vec3copy(r[0], origin);
			
			vec3 temphor;
			vec3copy(temphor, horizontal);

			vec3 tempver;
			vec3copy(tempver, vertical);

			vec3 temp;

			vec3sum(temp, lower_left_corner, vec3multiD(u, temphor));
			vec3add(temp, vec3multiD(v, tempver));
			vec3sub(temp, origin);

			vec3copy(r[1], temp);

			vec3 theColor;
			ray_color(theColor, r);//, circleVec, circleRadius, numCircles);

			draw_color(fout, theColor);
		}
	}

	printf("\n");
	system("pause");
}
