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

	Modified by: Andrew Hunt
	Modified because: Get main to render a circle in an enviroment

	Sources Used: https://raytracing.github.io/books/RayTracingInOneWeekend.html
*/

#include <stdio.h>
#include <stdlib.h>
#include "gpro/test/RayFunctions.h"

int main()
{
	// Image
	const float aspect_ratio	= 16.0f / 9.0f;						 // Apsect ratio of canvas
	const int image_width		= 400;								 // Canvas width
	const int image_height		= (int)(image_width / aspect_ratio); // Canvas height

	// Camera
	float viewport_height	= 2.0f;
	float viewport_width	= aspect_ratio * viewport_height;
	float focal_length		= 1.0f;

	//calculate vec3 of cameras
	vec3 origin		= { 0.0f, 0.0f, 0.0f };				//origin point of camera

	vec3 horizontal = { viewport_width, 0.0f, 0.0f };	//furthest right point of camera
	vec3 horcopy;
	vec3copy(horcopy, horizontal);

	vec3 vertical	= { 0.0f, viewport_height, 0.0f };	//furthest top point of camera
	vec3 vercopy;
	vec3copy(vercopy, vertical);

	//calculate lower left corner
	vec3 corner		= { 0.0f, 0.0f, focal_length };		//Focal point for lower left corner calculations
	vec3 lower_left_corner;
	vec3diff(lower_left_corner, origin, vec3div(horcopy, 2));
	vec3sub(lower_left_corner, vec3div(vercopy, 2));
	vec3sub(lower_left_corner, corner);

	// Render------------------------------------------------------------------------
	
	//create file (if file exists, overwrite it) No need to open it due to it only outputting
	FILE* fout = fopen("image.ppm", "w");

	//output file informtion before each pixel
	fprintf(fout, "P3\n");
	fprintf(fout, "%d ", image_width);
	fprintf(fout, "%d", image_height);
	fprintf(fout, "\n255\n");

	//this loop is for every verticle row of pixels
	for (int j = image_height - 1; j >= 0; --j) {
		//calc and print progress to the console
		float percentage = 100.0f - (((float) j / (float)(image_height - 1)) * 100.0f);
		printf("\rProgress: %f%%", percentage);

		//loop for every pixel in specified row
		for (int i = 0; i < image_width; ++i) {
			//calculate verticle and horizontal position of a targetted pixel
			float u = (float)i / (float)(image_width - 1);
			float v = (float)j / (float)(image_height - 1);

			//create a ray from the origin of the camera
			ray r;
			vec3copy(r[0], origin);
			
			//create temporary horizontal and verticle positions
			vec3 temphor;
			vec3copy(temphor, horizontal);
			vec3 tempver;
			vec3copy(tempver, vertical);

			//calculate the direction of the ray
			vec3 temp;
			vec3sum(temp, lower_left_corner, vec3multiD(u, temphor));
			vec3add(temp, vec3multiD(v, tempver));
			vec3sub(temp, origin);
			vec3copy(r[1], temp);

			//calc color of pixel ray is colliding into
			vec3 the_color;
			ray_color(the_color, r);

			//draw color to pixel
			draw_color(fout, the_color);
		}
	}

	//print a pause
	printf("\n");
	system("pause");
}
