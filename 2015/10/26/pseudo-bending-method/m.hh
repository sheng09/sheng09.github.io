#include <cmath>
#include <iostream>
#include <vector>

#ifndef RAYTRACING
#define RAYTRACING

#define SQ(x) ((x)*(x))
#define MID(x,y) ( ((x) + (y)) * 0.5 )
#define MAXPTS 200

class PT2 {
public:
    //typedef float (*FUN_PT2)();
    PT2() {}
    PT2(float _x, float _z) : x(_x), z(_z) {}
    //PT2(float _x, float _z, FUN_PT2 _v, FUN_PT2 _dvx, FUN_PT2 _dvz) :
    //    x(_x), z(_z), getVel(_v), getDVelX(_dvx), getDVelZ(_dvz) {}
    ~PT2() {}

public:
    PT2& operator=(PT2 & p2) {
        x = p2.x;
        z = p2.z;
        return *this;
    }
public:
    float x;
    float z;
    //FUN_PT2 getVel;
    //FUN_PT2 getDVelX;
    //FUN_PT2 getDVelZ;
};


inline float getV(PT2 & p)   { return 0.6 * p.z + 3.0; }
inline float getDvx(PT2 & p) { return 0.0; }
inline float getDvz(PT2 & p) { return 0.6; }
inline float getV(float x, float z) { return 0.6*z + 3.0; }
inline float getDvx(float x, float z) {return 0.0;}
inline float getDvz(float x, float z) {return 0.6;}
inline float distance(PT2 & p1, PT2 & p2)   { return sqrtf( SQ(p1.x-p2.x) + SQ(p1.z-p2.z) ); }
inline float slow_ave(PT2 & p1, PT2 & p2)   { return 0.5*(1.0/getV(p1) + 1.0/getV(p2)); }
inline float vel_ave(PT2 & p1, PT2 & p2)    { return 1.0 / slow_ave(p1, p2); }
inline float seg_traveltime(PT2 & p1, PT2 & p2) { return distance(p1, p2) * slow_ave(p1, p2); }
inline PT2& midPoint(  PT2 & p1,  PT2 & p2, PT2 & mid_p) {
    mid_p.x = MID( p1.x, p2.x );
    mid_p.z = MID( p2.z, p2.z );
    return mid_p;
}
PT2& perturb(PT2 & p1, PT2 & p2, PT2 & p3, float v = 1.0);

class RAY {
public:
    float traveltime() {
        float t = 0;
        for(int i =1 ; i < npts; ++i)
            t += seg_traveltime( (*ray)[i-1], (*ray)[i] );
        return t;
    }
    float doublePath() {
        int i = 1, j = 0;
        for( ; i < npts; ++i, ++j) {
            (*otherRay)[j].x = (*ray)[i-1].x;
            (*otherRay)[j].z = (*ray)[i-1].z;
            ++j;
            (*otherRay)[j].x = MID( (*ray)[i-1].x, (*ray)[i].x  );
            (*otherRay)[j].z = MID( (*ray)[i-1].z, (*ray)[i].z  );
        }
        (*otherRay)[j].x = (*ray)[i-1].x;
        (*otherRay)[j].z = (*ray)[i-1].z;
        npts = npts*2 -1;
        std::vector<PT2> *tmp;
        tmp = ray;
        ray = otherRay;
        otherRay = tmp;
    }
    void perturbRay(float v = 0.0) {
        int i = 2;
        std::vector<PT2>::iterator it = ray->begin() + 2;
        for( ; i<npts; ++i, ++it)
            perturb( *(it-2), *(it-1), *it );
    }
    float rt(int maxiter, float thred_t, float weight=0) {
        float t0, t1, t2;
        do {
            int niter = 0;
            do {
                if(niter++ >= maxiter) break;
                t0 = traveltime();
                perturbRay(weight);
                static int count = 0;
                output( std::cout, ++count);
                t1 = traveltime();
            } while(fabsf(t0 - t1) > thred_t );
            if(npts*2-1 >= maxiter) break;
            doublePath();
            t2 = traveltime();
        } while(fabsf(t2-t1) > thred_t );
    }
    void output(std::ostream &o, int i) {
        o << "\n> " << i << "  "<< npts << "\n";
        for(int i = 0; i < npts; ++i) {
            o << (*ray)[i].x << ", " << (*ray)[i].z << "\n";
        }
    }
    RAY(PT2 & o, PT2 & s, int maxnpts = MAXPTS) : ray_1(maxnpts), ray_2(maxnpts) {
        ray_1[0] = o;
        ray_1[2] = s;
        midPoint(o, s, ray_1[1]);
        ray = &ray_1;
        otherRay = &ray_2;
        npts = 3;
    }
    RAY() = delete;
    ~RAY() { ray_1.clear(); ray_2.clear(); }
public:
    std::vector<PT2> *ray; // the Ray !!!
    std::vector<PT2> *otherRay;
    std::vector<PT2> ray_1;
    std::vector<PT2> ray_2;
    //float t;
    int npts;
};
#endif
