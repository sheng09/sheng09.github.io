#include "rsf.h"
#include <stdio.h>
#include <math.h>
int **fun(int nx, int nz);

int main(int argc, char *argv[])
{
	int ix, iz;
	int nx=5, nz = 3;
	int **v = fun(nx,nz);
	for(iz = 0; iz< nz; ++iz)
	{
		for(ix = 0; ix< nx; ++ix)
		{
			printf("a[%d][%d] =%5d %p \n", iz, ix, v[iz][ix], &(v[iz][ix]));
		}
	}

	printf(" a @ %p\n", &v);
	printf("     |\n");
	printf("     |\n");
	printf("     V\n");
	for(iz = 0; iz < nz; ++iz)
	{
		printf("     a[%d] @ %p --> ", iz, &(v[iz]));
		for(ix = 0; ix < nx; ++ix)
		{
			printf("%p ", &(v[iz][ix]));
		}
		printf("\n");
	}
	return 0;
}

int **fun(int nx, int nz)
{
	int ix,  iz;
	int **data = sf_intalloc2(nx,nz);
	for(ix = 0; ix< nx; ++ix)
	{
		for(iz = 0; iz< nz; ++iz)
		{
			data[iz][ix] = ix + iz * 100;
		}
	}
	return data;
}