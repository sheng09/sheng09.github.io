close all;
clear;
clc;

nx = 300;
nz = 300;
dx = 5.0;
dz = 5.0;
x  = (0:nx-1) *dx;
z  = (0:nz-1) *dz;

dt = 1.0e-3;
nt = 2000;
t  = (0:nt-1)*dt;

v = zeros(300,300) + 800.0;

for i = 101:200
    v(i,:) = 1500.0;
end

for i = 201:300
    v(i,:) = 2000.0;
end
v2 = v.^2;

rho = 1000.0;
a_qx= dt/dx/rho;
a_qz= dt/dz/rho;
a_px= dt*rho/dx;
a_pz= dt*rho/dz;

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
ix_src = 1;
iz_src = 150;

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
			q_x(ix,iz) = q_x(ix,iz) - a_qx *( p(ix+1,iz) - p(ix,iz) );
		end
	end
	%q_z
	for iz = 1:nz-1
		for ix = 1:nx
			q_z(ix,iz) = q_z(ix,iz) - a_qz *( p(ix,iz+1) - p(ix,iz) );
		end
	end

	%p_x
	for ix = 2:nx-1
		for iz = 2:nz-1
			p_x(ix,iz) = p_x(ix,iz) - a_px *v2(ix,iz)*( q_x(ix,iz) - q_x(ix-1,iz) );
			p_z(ix,iz) = p_z(ix,iz) - a_pz *v2(ix,iz)*( q_z(ix,iz) - q_z(ix,iz-1) );
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

	subplot(221),imagesc(x, z, p/pmax );
    colormap('gray');
    axis square;

    w_max = max(max( abs(rec) ));
    subplot(122),imagesc(x,t,rec./w_max);
    colormap('gray');

    subplot(223),fill(t, trace_fill ,'r');
	hold on;
	subplot(223),plot(t,trace,'k');
	hold off;
    pause(0.001);
end

