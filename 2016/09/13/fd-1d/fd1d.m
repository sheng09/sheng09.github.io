% Matlab
    clear;close all; clc
    nx = 1000;   dx  = 10; x = (0:nx-1) * dx;
    nt = 500;   dt  = 1.0e-2;
    v  = 1000.0; rho = 1500;

    f_wave = 0.5*2.0 * pi ;
    n_stop = floor( 2.0 * pi / f_wave   / dt );
    src= [ sin( (0:n_stop)*dt*f_wave) zeros(1,nt) ]; %source

    p  = zeros(2,nx); q  = zeros(2,nx-1); %initial conditions
    new = 1; old = 2;
    c_q = -1.0*dt/rho/dx; c_p = -1.0*rho*v*v*dt/dx;
    figure
    for it = 1:nt
        %  1   2   3   4   5  ...
        %--q---q---q---q---q--...
        %p---p---p---p---p---p...
        %1   2   3   4   5   6...
        p(old,501) = src(it)+p(old,501);
        for ix = 1:nx-1
            q(new,ix) = q(old,ix) + c_q * ( p(old,ix+1) - p(old,ix) );
        end
        for ix = 2:nx-1
            p(new,ix) = p(old,ix) + c_p * ( q(new,ix) - q(new,ix-1) );
        end

        p(new,nx) = p(new,nx-1); % free boundary
        p(new,1)  = p(new,2);
        %p(new,nx) = 0.0; % rigid boundary
        %p(new,1)  = 0.0;
        plot(x,p(old,:));
        axis( [0 nx*dx -1.5 1.5] );
        
        %frame = getframe;
        %im = frame2im(frame);
        %[I,map] = rgb2ind(im,256);
                
        nn = it / 20.0;
        if nn == fix(nn)
            %nn = fix(nn)
            %if nn == 1
            %    imwrite(I,map,'wave.gif','gif','Loopcount',0,'DelayTime',0.1);
            %else
            %    imwrite(I,map,'wave.gif','gif','WriteMode','append','DelayTime',0.1);
            %end
            file = sprintf('%05d.jpg',nn);
            saveas(gcf,file,'jpg');
        end

        pause(0.001);
        tmp = old; old = new; new = tmp;
    end