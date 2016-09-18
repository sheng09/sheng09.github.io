close all;
clear;
clc;

n_pml = 10;
nx = 320;
nz = 320;
dx = 5.0;
dz = 5.0;
x  = (-n_pml:nx-1-n_pml) *dx; %(1:11) and (310:320) are PML zone
z  = (-n_pml:nx-1-n_pml) *dz;

dt = 1.0e-3;
nt = 2000;
t  = (0:nt-1)*dt;

v = zeros(nx,nz) + 800.0;

%for i = 51:100
%    v(i,:) = 1000.0;
%end
%
%for i = 101:320
%    v(i,:) = 1200.0;
%end
v2 = v.^2;

rho = 1000.0;

R = 0.001; delta = n_pml * dx; d_const = (3.0/2.0/delta)*log(1.0/R) /(delta*delta);
d_pxLeft  = ( (-n_pml:0)*dx ).^2 * d_const;
d_pxRight = ( (0:n_pml)*dx  ).^2 * d_const;
d_qxLeft  = ( (-n_pml:-1)*dx +dx/2 ).^2 * d_const;
d_qxRight = ( (1:n_pml)*dx   -dx/2 ).^2 * d_const;
d_px      = [d_pxLeft zeros(1,nx-2*n_pml-2) d_pxRight];
d_qx      = [d_qxLeft zeros(1,nx-2*n_pml-1) d_qxRight];

d_pzLeft  = ( (-n_pml:0)*dz ) .^2 * d_const;
d_pzRight = ( (0:n_pml)*dz  ) .^2 * d_const;
d_qzLeft  = ( (-n_pml:-1)*dz +dz/2 ) .^2 *  d_const;
d_qzRight = ( (1:n_pml)*dz   -dz/2 ) .^2 *  d_const;
d_pz      = [d_pzLeft zeros(1,nx-2*n_pml-2) d_pzRight];
d_qz      = [d_qzLeft zeros(1,nx-2*n_pml-1) d_qzRight];

p   = zeros(nx,nz);
p_x = zeros(nx,nz);
p_z = zeros(nx,nz);
q_x = zeros(nx-1,nz);
q_z = zeros(nx,nz-1);

rec = zeros(nt,nx);
trace=zeros(nt,9);
trace(:,1) = -4;
trace(:,2) = -3;
trace(:,3) = -2;
trace(:,4) = -1;
trace(:,5) =  0;
trace(:,6) =  1;
trace(:,7) =  2;
trace(:,8) =  3;
trace(:,9) =  4;

trace_fill = trace;



src = [ 2.0*mexihat(-5,5,200) zeros(1,nt)];
ix_src = 161;
iz_src = 161;

figure
for it = 1:nt
	%
	%     1   2   3   4   5
	%   --q---q---q---q---q--...
	%   p---p---p---p---p---p...
	%   1   2   3   4   5   6
	%

	p_x(ix_src, iz_src) = p_x(ix_src,iz_src) + src(it)/2.0;
	p_z(ix_src, iz_src) = p_z(ix_src,iz_src) + src(it)/2.0;
	p(  ix_src, iz_src) = p(  ix_src,iz_src) + src(it)/2.0;
	%q_x
	for ix = 1:nx-1
		for iz = 1:nz
			deno  = (2.0 + dt * d_qx(ix)*v(ix,iz));
			c_qx1 = (2.0 - dt * d_qx(ix)*v(ix,iz) ) / deno;
			c_qx2 = -2.0*dt / rho / dx / deno;
			q_x(ix,iz) = c_qx1 * q_x(ix,iz) + c_qx2 *( p(ix+1,iz) - p(ix,iz) );
		end
	end
	%q_z
	for iz = 1:nz-1
		for ix = 1:nx
			deno  = (2.0 + dt * d_qz(iz)*v(ix,iz) );
			c_qz1 = (2.0 - dt * d_qz(iz)*v(ix,iz) )/ deno;
			c_qz2 = -2.0*dt/rho/ dz / deno;
			q_z(ix,iz) = c_qz1 * q_z(ix,iz) + c_qz2 *( p(ix,iz+1) - p(ix,iz) );
		end
	end

	%p_x
	for ix = 2:nx-1
		for iz = 2:nz-1
			deno  =  (2.0 + dt * d_px(ix)*v(ix,iz) );
			c_px1 =  (2.0 - dt * d_px(ix)*v(ix,iz) ) / deno;
			c_px2 = -2.0*rho*v2(ix,iz)*dt/dx / deno;
			deno  =  (2.0 + dt * d_pz(iz)*v(ix,iz) );
			c_pz1 =  (2.0 - dt * d_pz(iz)*v(ix,iz) ) / deno;
			c_pz2 = -2.0*rho*v2(ix,iz)*dt/dz /deno;
			p_x(ix,iz) = c_px1 * p_x(ix,iz) + c_px2 * ( q_x(ix,iz) - q_x(ix-1,iz) );
			p_z(ix,iz) = c_pz1 * p_z(ix,iz) + c_pz2 * ( q_z(ix,iz) - q_z(ix,iz-1) );
			p(ix,iz)   = p_x(ix,iz) + p_z(ix,iz);
		end
	end
	p(1,:)    = p(2,:);
	p_x(1,:)  = p_x(2,:);
	p_z(1,:)  = p_z(2,:);

	rec(it,:)   = p(1,:);
	p_trace = 20.0* [p(1,30) p(1,60) p(1,90) p(1,120) p(1,149) p(1,180) p(1,210) p(1,240) p(1,270)];
	trace(it,:) = trace(it,:) + p_trace;
	trace_fill(it,:) = trace_fill(it,:) + 0.5*(p_trace + abs(p_trace) );
	pmax = max(max( abs(p) ));

	imagesc(x, z, p/pmax );
    colormap('gray');
    axis square;

    pause(0.001);
end

