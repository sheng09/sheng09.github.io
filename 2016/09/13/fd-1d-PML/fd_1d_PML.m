   % Matlab
    clear;close all; clc
    n_pml = 10;
    nx = 1020; dx  = 10; x = (-n_pml:nx-1-n_pml) * dx; %(1:11) and (1010:1020) are PML zone
    nt = 700;  dt  = 1.0e-2;
    v  = 1000.0; rho = 1500;
    R = 0.001; delta = n_pml * dx; d_const = (3.0*v/2.0/delta)*log(1.0/R) /(delta*delta);

    d_pLeft  = ( (-n_pml:0)*dx ) .^2 * d_const;
    d_pRight = ( (0:n_pml)*dx  ) .^2 * d_const;
    d_qLeft  = ( (-n_pml:-1)*dx +dx/2 ) .^2 * d_const;
    d_qRight = ( (1:n_pml)*dx -dx/2   ) .^2 * d_const;
    d_p      = [d_pLeft zeros(1,nx-2*n_pml-2) d_pRight];
    d_q      = [d_qLeft zeros(1,nx-2*n_pml-1) d_qRight];

    c1       = (2.0-dt*d_p)./(2.0+dt*d_p);
    c2       = (-2.0*rho*v*v*dt)./dx./(2.0+dt*d_p);

    f1       = (2.0-dt*d_q)./(2.0+dt*d_q);
    f2       = ( (-2.0*dt)./rho./dx) ./ (2.0+dt.*d_q);


    f_wave = 0.5*2.0 * pi ;
    n_stop = floor( 2.0 * pi / f_wave   / dt );
    src= [ sin( (0:n_stop)*dt*f_wave) zeros(1,nt) ]; %source

    p  = zeros(2,nx); q  = zeros(2,nx-1); %initial conditions
    new = 1; old = 2;
    figure
    xmin = min(x); xmax = max(x);
    for it = 1:nt
        %  1   2   3   4   5  ...
        %--q---q---q---q---q--...
        %p---p---p---p---p---p...
        %1   2   3   4   5   6...
        p(old,511) = src(it)+p(old,511);
        for ix = 1:nx-1
            q(new,ix) = f1(ix)* q(old,ix) + f2(ix) * ( p(old,ix+1) - p(old,ix) );
        end
        for ix = 2:nx-1
            p(new,ix) = c1(ix)* p(old,ix) + c2(ix) * ( q(new,ix) - q(new,ix-1) );
        end

        %p(new,nx) = p(new,nx-1); % free boundary
        %p(new,1)  = p(new,2);
        p(new,nx) = 0.0; % rigid boundary
        p(new,1)  = 0.0;
        plot(x,p(old,:));
        axis( [xmin xmax -1.5 1.5] );
        pause(0.001);
        tmp = old; old = new; new = tmp;
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


    end
