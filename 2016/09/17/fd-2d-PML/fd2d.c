#include "rsf.h"
#include <stdio.h>
#include <math.h>

float* rickerSrc(int n, float dt, float t0, float fc, float amplitude);
int main(int argc, char *argv[])
{
	int ix, iz, it;
	int nx, nz;  //grid
	float dx, dz;
	int nt;
	float dt, rho;
	float *src; //source
	int ox, oz;
	float fc;
	float **trace = NULL;
	float **px, **pz, **p, **qx, **qz; //p: pressure; q:velocity
	double c_qx1, c_qx2, c_qz1, c_qz2, c_px1, c_px2, c_pz1, c_pz2;
	float cqx, cqz, cpx, cpz;
	float vel;
	int zrec, isnap;
	float **pvel;
	//int ix, iz, it;
	sf_file ofile=NULL, snap=NULL;

	sf_init(argc, argv);
	ofile = sf_output("wavefield");
	snap  = sf_output("snap");

	sf_getint("isnap",&isnap);
	sf_getint("nx",&nx);
	sf_getint("nz",&nz);
	sf_getint("ox",&ox);
	sf_getint("oz",&oz);
	sf_getint("nt",&nt);
	sf_getint("zrec",&zrec);
	sf_getfloat("dt",&dt);
	sf_getfloat("dx",&dx);
	sf_getfloat("dz",&dz);
	sf_getfloat("rho",&rho);
	sf_getfloat("vel",&vel);
	sf_getfloat("fc",&fc);


	sf_putint(ofile,"n1",nt);
	sf_putint(ofile,"n2",nx);
	sf_putfloat(ofile,"d1",dt);
	sf_putfloat(ofile,"d2",dx);
	sf_putint(snap,"n1",nx);
	sf_putint(snap,"n2",nz);
	sf_putfloat(snap,"d1",dx);
	sf_putfloat(snap,"d2",dz);
	printf("nx= %d nz= %d ox= %d oz= %d isnap=%d\n",nx,nz,ox,oz,isnap );
	cqx = -1.0 * dt / rho / dx;
	cqz = -1.0 * dt / rho / dz;
	cpx = -1.0 * rho *dt/dx;
	cpz = -1.0 * rho *dt/dz;

	pvel  = sf_floatalloc2( nx, nz);
	px    = sf_floatalloc2( nx, nz);
	pz    = sf_floatalloc2( nx, nz);
	p     = sf_floatalloc2( nx, nz);
	qx    = sf_floatalloc2( nx, nz);
	qz    = sf_floatalloc2( nx, nz);
	trace = sf_floatalloc2(nt, nx);
	src   = rickerSrc(nt, dt, 1.0/fc, fc, 0.5);

	for(ix = 0; ix < nx; ++ix)
		for(iz = 0; iz< 30; ++iz)
			pvel[iz][ix] = 800.0*800.0;
	for(ix = 0; ix < nx; ++ix)
		for(iz = 30; iz< nz ; ++iz)
			pvel[iz][ix] = 1200.0*1200.0;

	printf("%f\n", dt/rho/dx );
	printf("cqx=%f cqz=%f cpx=%f cpz=%f\n", cqx, cqz, cpx, cpz);

	// Initialization
	for (ix = 0; ix < nx; ++ix)
		for ( iz = 0; iz < nz; ++iz)
		{
			p[ iz][ix]  = 0.0;
			px[iz][ix]  = 0.0;
			pz[iz][ix]  = 0.0;
			qx[iz][ix]  = 0.0;
			qz[iz][ix]  = 0.0;
		}

	for ( it = 0; it < nt; ++it)
	{
		px[oz][ox] += src[it];
		pz[oz][ox] += src[it];
		p[ oz][ox]  = px[oz][ox] + pz[ox][oz];
		for( ix = 0; ix < nx; ++ix)
		{
			trace[ix][it] = p[zrec][ix];
		}
		//qx
		for ( ix = 0; ix < nx-1; ++ix)
		{
			for ( iz = 0; iz < nz; ++iz)
			{
				c_qx1 = 1.0;
				c_qx2 = cqx;
				qx[iz][ix] = c_qx1 * qx[iz][ix] + c_qx2 * ( p[iz][ix+1]-p[iz][ix] );
			}
		}
		//printf("qx done\n");
		//qz
		for ( ix = 0; ix < nx; ++ix)
		{
			for ( iz = 0; iz < nz-1; ++iz)
			{
				c_qz1 = 1.0;
				c_qz2 = cqz;
				qz[iz][ix] = c_qz1 * qz[iz][ix] + c_qz2 * ( p[iz+1][ix]-p[iz][ix] );
			}
		}
		//printf("qz done\n");
		//px and pz
		for( ix = 1; ix < nx-1; ++ix)
		{
			for( iz = 1; iz < nz-1; ++iz)
			{
				c_px1 = 1.0;
				c_px2 = cpx;
				c_pz1 = 1.0;
				c_pz2 = cpz;
				//printf("%f\n", pvel[iz][ix]);
				px[iz][ix] = c_px1 * px[iz][ix] + c_px2 * pvel[iz][ix] * ( qx[iz][ix] - qx[iz][ix-1] );
				pz[iz][ix] = c_pz1 * pz[iz][ix] + c_pz2 * pvel[iz][ix] * ( qz[iz][ix] - qz[iz-1][ix] );
				p[iz][ix]  = px[iz][ix] + pz[iz][ix];
			}
		}
		for(int ix = 0; ix < nx; ++ix)
		{
			px[0][ix]     = px[1][ix];
			px[nz-1][ix]  = px[nz-2][ix];
			pz[0][ix]     = pz[1][ix];
			pz[nz-1][ix]  = pz[nz-2][ix];
		}
		for(int iz = 0; iz < nz; ++iz)
		{
			px[iz][0]    = px[iz][1];
			px[iz][nx-1] = px[iz][nx-2];
			pz[iz][0]    = pz[iz][1];
			pz[iz][nx-1] = pz[iz][nx-2];
		}
		if(it == isnap)
		{
			sf_floatwrite( p[0], nx*nz, snap );
		}
	}
	printf("Finished\n");
	//pt2dwrite2(ofile, (pt2d**)trace, nx, nz, -1);
	sf_floatwrite( trace[0] ,nx*nt,ofile);
	free(px);
	free(pz);
	free(p);
	free(qx);
	free(qz);
	free(trace);
	free(src);
	sf_close();
	return 0;
}

float* rickerSrc(int n, float dt, float t0, float fc, float amplitude)
{
	float *src = sf_floatalloc(n);
	int it;
	float fc2 = fc*fc;
	float pi2 = 3.1415926535*3.1415926535;
	float fc2pi2 = -fc2*pi2;
	float dt2;
	for(it = 0; it < n; ++it)
	{
		dt2 = it*dt - t0;
		dt2 = dt2*dt2* fc2pi2;
		src[it] = amplitude * (1.0 + 2.0*dt2) * exp( dt2 );
	}

	return src;
}