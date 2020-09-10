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

#ifndef _GPRO_VECTOR_H_
#define _GPRO_VECTOR_H_


#ifdef __cplusplus
// DB: link C++ symbols as if they are C where possible
extern "C" {
#else	// !__cplusplus
// DB: forward declare C types... why?
//	-> in C++ you would instantiate one of these like so: 
//		vec3 someVector;
//	-> in C you do it like this: 
//		union vec3 someVector;
//	-> this forward declaration makes the first way possible in both languages!
typedef union vec3 vec3;
#endif	// __cplusplus


// DB: declare shorthand types

typedef float vec3[3];		// 3 floats form the basis of a float vector
typedef float* floatv;			// generic float vector (pointer)
typedef float const* floatkv;	// generic constant float vector (pointer)

// DB: declare 3D vector
//	-> why union? all data in the union uses the same address... in this case: 
//		'v' and 'struct...' share the same address
//	-> this means you can have multiple names for the same stuff!

// vec3
//	A 3D vector data structure.
//		member v: array (pointer) version of data
//		members x, y, z: named components of vector
union vec3C
{
	vec3 v;
	struct { float x, y, z; };

#ifdef __cplusplus
	// DB: in C++ we can have convenient member functions
	//	-> e.g. constructors, operators

	explicit vec3C();	// default ctor
	explicit vec3C(float const xc, float const yc = 0.0f, float const zc = 0.0f);	// init ctor w one or more floats
	explicit vec3C(vec3 const vc);	// copy ctor w generic array of floats
	vec3C(vec3C const& rh);	// copy ctor

	vec3C& operator =(vec3C const& rh);	// assignment operator (copy other to this)

	vec3C& operator +=(vec3C const& rh);	// addition assignment operator (add other to this)

	vec3C const operator +(vec3C const& rh) const;	// addition operator (get sum of this and another)

#endif	// __cplusplus
};

// DB: declare C functions (all equivalents of above C++ functions are here)
//	-> return pointers so you can chain operations (they just take pointers)

floatv vec3default(vec3 v_out);	// default init
floatv vec3init(vec3 v_out, float const xc, float const yc, float const zc);	// init w floats
floatv vec3copy(vec3 v_out, vec3 const v_rh);	// init w array of floats (same as assign and both copy ctors)

floatv vec3add(vec3 v_lh_sum, vec3 const v_rh);	// add other to lh vector

floatv vec3sum(vec3 v_sum, vec3 const v_lh, vec3 const v_rh);	// get sum of lh and rh vector

floatv vec3sub(vec3 v_lh, vec3 const v_rh);

floatv vec3mul(vec3 v_lh, vec3 const v_rh);

floatv vec3multiD(float t, vec3 const v_rh);

floatv vec3div(vec3 const v_rh, float t);

floatv unit_vector(vec3 v);

float length(vec3 const temp);

float length_squared(vec3 const temp);

float dot(vec3 const u, vec3 const v);

floatv cross(vec3 temp, vec3 const u, vec3 const v);

//leaving out dot, cross, and the last * operator functions


#ifdef __cplusplus
// DB: end C linkage for C++ symbols
}
#endif	// __cplusplus


// DB: include inline definitions for this interface
#include "_inl/gproVector.inl"


#endif	// !_GPRO_VECTOR_H_