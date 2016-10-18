#include <stdio.h>
#include <stdlib.h>
int main(int argc, char const *argv[])
{
	int nx = 10;
	int nz = 10;
	float **p;
	float **qz, **qx, **velp, **velq;
	//p = sf_floatalloc2( nx,nz );
	//qz = sf_floatalloc2( nx,nz );
	//qx = sf_floatalloc2( nx,nz );
	//velp = sf_floatalloc2( nx,nz );
	//velq = sf_floatalloc2( nx,nz );

	int nstep;
	float fdx_p, fdz_p;
	for(int it = 0; it < nstep; ++it)
	{
		for()
		// Dt[qx] = -Dx[p] / rho
		// Dt[qz] = -Dz[p] / rho
	}
 	return 0;
}