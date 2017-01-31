#include <cmath>
#include "m.hh"
PT2& perturb(PT2 & p1, PT2 & p2, PT2 & p3, float v) {
    float x1 = p1.x, x3 = p3.x;
    float z1 = p1.z, z3 = p3.z;
    
    float xmid = 0.5*(x1+x3);
    float zmid = 0.5*(z1+z3);
    float dx   = x3-x1;
    float dz   = z3-z1;
    float L2   = (SQ(dx)+SQ(dz));
    float L    = sqrtf(L2);
    float dvx  = getDvx(xmid, zmid);
    float dvz  = getDvz(xmid, zmid);
    float nL   = dx*dvx+dz*dvz;
    float nx   = dvx - nL*dx/L2;
    float nz   = dvz - nL*dz/L2;

    float nl   = sqrtf(SQ(nx)+SQ(nz));
	nx          = nx /nl;
	nz          = nz /nl;

    float l    = (SQ(x3-xmid)+SQ(z3-zmid));
    float c    = 0.5/getV(x1,z1)+0.5/getV(x3,z3) ;
    float Vm   = getV(xmid,zmid) ;
    float ra   = SQ(0.25*(c*Vm+1)/c/(nx*dvx+nz*dvz));
    float rb   = 0.5*l/c/Vm;
    float Rc   = -0.25*(c*Vm+1)/(c*(nx*dvx+nz*dvz))+sqrt(ra+rb);
    
    float xnew = xmid + nx * Rc;
    float znew = zmid + nz * Rc;

    p2.x = v*(xnew - p2.x) +p2.x;
    p2.z = v*(znew - p2.z) +p2.z;
    return p2;
}



