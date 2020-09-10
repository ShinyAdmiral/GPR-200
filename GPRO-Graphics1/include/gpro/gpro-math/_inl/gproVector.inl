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
	gproVector.h
	Interface for vectors. Sets an example for C and C++ compatible headers.

	Modified by: ____________
	Modified because: ____________
*/

#ifdef _GPRO_VECTOR_H_
#ifndef _GPRO_VECTOR_INL_
#define _GPRO_VECTOR_INL_

#include <math.h>

#ifdef __cplusplus

inline vec3C::vec3C()
	: x(0.0f), y(0.0f), z(0.0f)
{
}
inline vec3C::vec3C(float const xc, float const yc, float const zc)
	: x(xc), y(yc), z(zc)
{
}
inline vec3C::vec3C(vec3 const vc)
	: x(vc[0]), y(vc[1]), z(vc[2])
{
}
inline vec3C::vec3C(vec3C const& rh)
	: x(rh.x), y(rh.y), z(rh.z)
{
}

inline vec3C& vec3C::operator =(vec3C const& rh)
{
	x = rh.x;
	y = rh.y;
	z = rh.z;
	return *this;
}

inline vec3C& vec3C::operator +=(vec3C const& rh)
{
	x += rh.x;
	y += rh.y;
	z += rh.z;
	return *this;
}

inline vec3C const vec3C::operator +(vec3C const& rh) const
{
	return vec3C((x + rh.x), (y + rh.y), (z + rh.z));
}

#endif	// __cplusplus


///c language


inline floatv vec3default(vec3 v_out)
{
	v_out[0] = v_out[1] = v_out[2] = 0.0f;
	return v_out;
}
inline floatv vec3init(vec3 v_out, float const xc, float const yc, float const zc)
{
	v_out[0] = xc;
	v_out[1] = yc;
	v_out[2] = zc;
	return v_out;
}
inline floatv vec3copy(vec3 v_out, vec3 const v_rh)
{
	v_out[0] = v_rh[0];
	v_out[1] = v_rh[1];
	v_out[2] = v_rh[2];
	return v_out;
}

inline floatv vec3add(vec3 v_lh_sum, vec3 const v_rh)
{
	v_lh_sum[0] += v_rh[0];
	v_lh_sum[1] += v_rh[1];
	v_lh_sum[2] += v_rh[2];
	return v_lh_sum;
}

inline floatv vec3sum(vec3 v_sum, vec3 const v_lh, vec3 const v_rh)
{
	return vec3init(v_sum, (v_lh[0] + v_rh[0]), (v_lh[1] + v_rh[1]), (v_lh[2] + v_rh[2]));
}

inline floatv vec3sub(vec3 v_lh, vec3 const v_rh) {
	v_lh[0] -= v_rh[0];
	v_lh[1] -= v_rh[1];
	v_lh[2] -= v_rh[2];
	return v_lh;
}

inline floatv vec3diff(vec3 diff, vec3 const v_lh, vec3 const v_rh){
	return vec3init(diff, (v_lh[0] - v_rh[0]), (v_lh[1] - v_rh[1]), (v_lh[2] - v_rh[2]));
}

inline floatv vec3mul(vec3 v_lh, vec3 const v_rh) {
	return vec3init(v_lh, v_lh[0] * v_rh[0], v_lh[1] * v_rh[1], v_lh[2] * v_rh[2]);
}

inline floatv vec3multiD(float t, vec3 v_rh) {
	return vec3init(v_rh, v_rh[0] * t, v_rh[1] * t, v_rh[2] * t);
}

inline floatv vec3div(vec3 v_rh, float t) {
	return vec3multiD((1 / t), v_rh);
}

inline float dot(vec3 const u, vec3 const v) {
	return u[0] * v[0]
		+  u[1] * v[1]
		+  u[2] * v[2];
}

inline floatv cross(vec3 temp, vec3  u, vec3 const v) {
	float part1 = u[1] * v[2] - v[2] * u[1];
	float part2 = u[2] * v[0] - v[0] * u[2];
	float part3 = u[0] * v[1] - v[1] * u[0];

	temp[0] = part1;
	temp[1] = part2;
	temp[2] = part3;

	return temp;
}

/*
inline floatv vec3qout(vec3 temp, vec3 v_rh, float t) {

	return vec3multiD((1 / t), v_rh);
}
*/

inline floatv unit_vector(vec3 temp) {
	return vec3div(temp, length(temp));
}

inline float length(vec3 const temp) {
	return sqrt(length_squared(temp));
}

inline float length_squared(vec3 const temp) {
	return (temp[0] * temp[0]) + (temp[1] * temp[1]) + (temp[2] * temp[2]);
}

#endif	// !_GPRO_VECTOR_INL_
#endif	// _GPRO_VECTOR_H_