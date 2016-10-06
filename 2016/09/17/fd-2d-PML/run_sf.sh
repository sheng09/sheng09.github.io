gcc fd2d.c -L/opt/madagascar/lib -I/opt/madagascar/include -lrsf -lm --std=c99 -o fd2d
fd2d nx=201 nz=301 dx=5 dz=5 nt=2000 dt=0.001 ox=100 oz=1 rho=0.001 vel=800.0 fc=10 wavefield=out.rsf snap=s.rsf isnap=500 zrec=1
