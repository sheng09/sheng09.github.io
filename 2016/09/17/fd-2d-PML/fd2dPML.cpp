typedef struct
{
	/* data */
	int nt, it;
	int nx, nz;
	int pml_left, pml_right, pml_top, pml_button;
	float **px, **pz;
	float **qx, **qz;
	float **cpx1, **cpx2;
	float **cpz1, **cpz2;
	float **cqx1, **cqx2;
	float **cqz1, **cqz2;
	float dx, dz, dt;
}GRID2D;

float *pml_abszP(int n, float dx, float R, int direction, float dt)
{
	int i;
	float x;
	float c;
	float *trace    = sf_floatalloc(n);
	float thickness = dx * n;
	thickness = thickness * thickness * thickness;
	c = logf(1.0/R) * 1.5 / thickness;

	if(direction == DX_INC)
	{
		for(i = 1; i <= n; ++i)
		{
			x = i * dx;
			trace[i] = c * x * x * dt;
		}
	}
	else if(direction == DX_DEC)
	{
		for(i = 0; i < n; ++i)
		{
			x = (n-i) * dx;
			trace[i] = c * x * x * dt;
		}
	}
	return trace;
}

float *pml_abszQ(int n, float dx, float R, int direction, float dt)
{
	int i;
	float x;
	float c;
	float *trace    = sf_floatalloc(n);
	float thickness = dx * n;
	float dd = dx * 0.5;
	thickness = thickness * thickness * thickness;
	c = logf(1.0/R) * 1.5 / thickness;

	if(direction == DX_INC)
	{
		for(i = 1; i <= n; ++i)
		{
			x = i * dx - dx;
			trace[i] = c * x * x;
		}
	}
	else if(direction == DX_DEC)
	{
		for(i = 0; i < n; ++i)
		{
			x = (n-i) * dx - dx;
			trace[i] = c * x * x;
		}
	}
	return trace;
}
int coef(GRID2D *grid)
{
	float **cpx1 = grid->cpx1;
	float **cpx2 = grid->cpx2;
	float **cpz1 = grid->cpz1;
	float **cpz2 = grid->cpz2;
	float **cqx1 = grid->cqx1;
	float **cqx2 = grid->cqx2;
	float **cqz1 = grid->cqz1;
	float **cqz2 = grid->cqz2;
	int nx = grid->nx;
	int nz = grid->nz;
	int pml_left   = grid->pml_left   ;
	int pml_right  = grid->pml_right  ;
	int pml_top    = grid->pml_top    ;
	int pml_button = grid->pml_button ;
	float dx = grid->dx;
	float dz = grid->dz;
	float dt = grid->dt;

	float *d_pxLeft   = pml_abszp(n_pmlLeft,   dx, 0.001,  DX_DEC);
	float *d_pxright  = pml_abszp(n_pmlRight,  dx, 0.001,  DX_INC);
	float *d_pzButton = pml_abszp(n_pmlButton, dz, 0.001,  DX_INC);
	float *d_pzTop    = pml_abszp(n_pmlTop,    dz, 0.001,  DX_DEC);
	float *d_qxLeft   = pml_abszq(n_pmlLeft,   dx, 0.001,  DX_DEC);
	float *d_qxright  = pml_abszq(n_pmlRight,  dx, 0.001,  DX_INC);
	float *d_qzButton = pml_abszq(n_pmlButton, dz, 0.001,  DX_INC);
	float *d_qzTop    = pml_abszq(n_pmlTop,    dz, 0.001,  DX_DEC);

	int ix, iz;

	/*
	        *---*------------*---*
	        | 1 |      2     | 3 |
	        *---*------------*---*
	        |   |            |   |
	        |   |            |   |
	        | 4 |      5     | 6 |
	        |   |            |   |
	        |   |            |   |
	        *---*------------*---*
	        | 7 |      8     | 9 |
	        *---*------------*---*
	 */
	//P in area 1
	for(iz = 0; iz < n_pmlTop; ++iz)
	{
		for(ix = 0; ix < n_pmlLeft; ++ix)
		{
			cpx1 = 
			cpx2 = 
		}
	}
}
int move1(GRID2D *grid)
{
	int ix, iz;
	float **px   = grid->px;
	float **px   = grid->pz;
	float **px   = grid->qx;
	float **px   = grid->qz;
	float **cpx1 = grid->cpx1;
	float **cpx2 = grid->cpx2;
	float **cpz1 = grid->cpz1;
	float **cpz2 = grid->cpz2;
	float **cqx1 = grid->cqx1;
	float **cqx2 = grid->cqx2;
	float **cqz1 = grid->cqz1;
	float **cqz2 = grid->cqz2;
	int nx = grid->nx;
	int nz = grid->nz;
	//Q
	for(iz = 0; iz < nz; ++iz)
	{
		for(ix = 0; ix < nx-1; ++ix)
		{
			qx[iz][ix] = cqx1[iz][ix] * qx[iz][ix] + cqx2 * ( p[iz][ix+1] - p[iz][ix] );
		}
	}
	for(iz = 0; iz < nz-1; ++iz)
	{
		for(ix = 0; ix < nx; ++ix)
		{
			qz[iz][ix] = cqz1[iz][ix] * qz[iz][ix] + cqz2 * ( p[iz+1][ix] - p[iz][ix] );
		}
	}
	//P
	for(iz = 1; iz < nz-1; ++iz)
	{
		for(ix = 1; ix < nx-1; ++ix)
		{
			px[iz][ix] += cpx1[iz][ix] * px[iz][ix] + cpx2 * ( qx[iz][ix] - qx[iz][ix-1] );
			pz[iz][ix] += cpz1[iz][ix] * pz[iz][ix] + cpz2 * ( qz[iz][ix] - qz[iz-1][ix] );
			p[ iz][ix] += px[iz][ix] + pz[iz][ix];
		}
	}
	++(grid-->it);
	return 1;
}

int move2(GRID2D *grid,int nstep)
{
	int i;
	for(i = 0; i < nstep; ++i)
		move1(grid);
}

#include "rsf.h"
#include <stdio.h>
#include <math.h>

#define DX_INC 0
#define DX_DEC 1

float *pml_abszp(int n, float dx, float R, int direction);
float *pml_abszq(int n, float dx, float R, int direction);
float* rickerSrc(int n, float dt, float t0, float fc, float amplitude);
int main(int argc, char *argv[])
{
	//grid
	int ix, iz, it;
	int nx, nz, nt;
	float dx, dz, dt, rho;
	float **vel;
	//source
	float *src;
	int ox, oz;
	float fc;
	//pml and coefficients
	int    n_pmlLeft, n_pmlRight, n_pmlTop, n_pmlButton;
	float *d_pxLeft, *d_pxright, *d_pzTop, *d_pzButton;
	float *d_qxLeft, *d_qxright, *d_qzTop, *d_qzButton;
	float **cpx1, **cpx2, **cpz1, **cpz2, **cqx1, **cqx2, **cqz1, **cqz2;
	//p: pressure; q:velocity
	float **px, **pz, **p, **qx, **qz;
	//receivers
	float **trace = NULL;
	int zrec, isnap;
	//output file for receivers and snap
	sf_file ofile=NULL, snap=NULL;

	//
	sf_init(argc, argv);
	ofile = sf_output("wavefield");
	snap  = sf_output("snap");

	sf_getint("pmlLeft",     &n_pmlLeft);
	sf_getint("pmlRight",    &n_pmlRight);
	sf_getint("pmlTop",      &n_pmlTop);
	sf_getint("n_pmlButton", &n_pmlButton);

	sf_getint("nx",   &nx);
	sf_getint("nz",   &nz);
	sf_getint("ox",   &ox);
	sf_getint("oz",   &oz);
	sf_getint("nt",   &nt);
	sf_getint("zrec",&zrec);
	sf_getint("isnap",&isnap);

	sf_getfloat("dt",&dt);
	sf_getfloat("dx",&dx);
	sf_getfloat("dz",&dz);
	sf_getfloat("rho",&rho);
	//sf_getfloat("vel",&vel);
	sf_getfloat("fc",&fc);

	nx = nx + n_pmlLeft + n_pmlRight;
	nz = nz + n_pmlTop + n_pmlButton;

	sf_putint(  ofile, "n1",nt);
	sf_putint(  ofile, "n2",nx);
	sf_putfloat(ofile, "d1",dt);
	sf_putfloat(ofile, "d2",dx);
	sf_putint(  snap,  "n1",nx);
	sf_putint(  snap,  "n2",nz);
	sf_putfloat(snap,  "d1",dx);
	sf_putfloat(snap,  "d2",dz);

	d_pxLeft   = pml_abszp(n_pmlLeft,   dx, 0.001,  DX_DEC);
	d_pxright  = pml_abszp(n_pmlRight,  dx, 0.001,  DX_INC);
	d_pzButton = pml_abszp(n_pmlButton, dz, 0.001,  DX_INC);
	d_pzTop    = pml_abszp(n_pmlTop,    dz, 0.001,  DX_DEC);
	d_qxLeft   = pml_abszq(n_pmlLeft,   dx, 0.001,  DX_DEC);
	d_qxright  = pml_abszq(n_pmlRight,  dx, 0.001,  DX_INC);
	d_qzButton = pml_abszq(n_pmlButton, dz, 0.001,  DX_INC);
	d_qzTop    = pml_abszq(n_pmlTop,    dz, 0.001,  DX_DEC);
	//printf("nx= %d nz= %d ox= %d oz= %d isnap=%d\n",nx,nz,ox,oz,isnap );
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
	cpx1  = sf_floatalloc2( nx, nz);
	cpx2  = sf_floatalloc2( nx, nz);
	cpz1  = sf_floatalloc2( nx, nz);
	cpz2  = sf_floatalloc2( nx, nz);
	cqx1  = sf_floatalloc2( nx, nz);
	cqx2  = sf_floatalloc2( nx, nz);
	cqz1  = sf_floatalloc2( nx, nz);
	cqz2  = sf_floatalloc2( nx, nz);
	trace = sf_floatalloc2( nt, nx);



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



float **pml_cqx1(int nx, int nz, int nLeft, int nRight, int n)