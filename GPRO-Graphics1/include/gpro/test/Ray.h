#pragma once
#ifndef RAY_H
#define RAY_H
#include "math.h"
#include "gpro/gpro-math/gproVector.h"

typedef vec3 ray[2]; //stores two vec3's point3(origin) and vec3(direction)
typedef vec3* rayp;			// generic float vector (pointer)
typedef vec3 const* raykp;	// generic constant float vector (pointer)

floatv ray_len(vec3 temp, float t, ray r) {
//int* arr = new int[size];
    return vec3sum(temp, r[0], vec3multiD(t, r[1]));
}

/*
class ray {
public:
    ray() {}
    ray(const point3& origin, const vec3& direction)
        : orig(origin), dir(direction)
    {}

    point3 origin() const { return orig; }
    vec3 direction() const { return dir; }

    point3 at(double t) const {
        return orig + t * dir;
    }

public:
    point3 orig;
    vec3 dir;
};
*/
#endif