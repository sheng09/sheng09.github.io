clear;
clc;
close all;

dx = 0.1;
N  = 80;
x  = (0:N)*dx;
y  = sin(x);
z1 = cos(x); %1st order derivative
z2 =-sin(x); %2nd order devivative

s2 = x.*0;
s4 = x.*0;
s6 = x.*0;
s8 = x.*0;
s10 = x.*0;
s12 = x.*0;

t2 = x.*0;
t4 = x.*0;
t6 = x.*0;
t8 = x.*0;
t10 = x.*0;
t12 = x.*0;

c21 =  1.0/2;
c41 =  4.0/6;
c42 = -1.0/12;
c61 = 3.0/4;
c62 = -3.0/20;
c63 = 1.0/60;

c81 =    4.0/5;
c82 =   -1.0/5;
c83 =    4.0/105;
c84 =   -1.0/280;
f81 =      8.0/5;
f82 =     -1.0/5;
f83 =      8.0/315;
f84 =     -1.0/560;


c101 =    5.0/6;
c102 =   -5.0/21;
c103 =    5.0/84;
c104 =   -5.0/504;
c105 =    1.0/1260;
f101=       5.0/3;
f102=      -5.0/21;
f103=       5.0/126;
f104=      -5.0/1008;
f105=       1.0/3150;

c121 =    6.0/7;
c122 =  -15.0/56;
c123 =    5.0/63;
c124 =   -1.0/56;
c125 =    1.0/385;
c126 =   -1.0/5544;
f121 =      12.0/7;
f122 =     -15.0/56;
f123 =      10.0/189;
f124 =      -1.0/112;
f125 =       2.0/1925;
f126 =      -1.0/16632;


f21 = 1.0;
f41 = 4.0/3;
f42 = -1.0/12;
f61 = 3.0/2;
f62 = -3.0/20;
f63 = 1.0/90;

for i = 2:N-1
    s2(i) = c21*( y(i+1) - y(i-1) );
end
s2 = s2./dx;
for i = 3:N-2
    s4(i) = c41*( y(i+1) - y(i-1) ) + c42*( y(i+2) - y(i-2) );
end
s4 = s4./dx;
for i = 4:N-3
    s6(i) = c61*( y(i+1) - y(i-1) ) + c62*( y(i+2) - y(i-2) ) + c63*( y(i+3) - y(i-3) );
end
s6 = s6./dx;
for i = 5:N-4
    s8(i) = c81*( y(i+1) - y(i-1) ) + c82*( y(i+2) - y(i-2) ) + c83*( y(i+3) - y(i-3) ) + c84*( y(i+4) - y(i-4) );
end
s8 = s8./dx;
for i = 6:N-5
    s10(i) = c101*( y(i+1) - y(i-1) ) + c102*( y(i+2) - y(i-2) ) + c103*( y(i+3) - y(i-3) ) + c104*( y(i+4) - y(i-4) ) + c105*( y(i+5) - y(i-5) );
end
s10 = s10./dx;
for i = 7:N-6
    s12(i) = c121*( y(i+1) - y(i-1) ) + c122*( y(i+2) - y(i-2) ) + c123*( y(i+3) - y(i-3) ) + c124*( y(i+4) - y(i-4) ) + c125*( y(i+5) - y(i-5) ) + c126*( y(i+6) - y(i-6) );
end
s12 = s12./dx;

figure
subplot(411),plot(x,z1,x,s2,x,s4,x,s6,x,s8,x,s10,x,s12,'LineWidth',2);
grid on
axis([ 1 7 -1 1])
legend('real','2','4','6','8','10','12')
title('First Order Derivative');
subplot(423),plot(x, s2-z1,'r','LineWidth',2); axis([ 1 7 -0.01               0.01              ]); grid on; title('  2nd order error');
subplot(424),plot(x, s4-z1,'r','LineWidth',2); axis([ 1 7 -0.00001            0.00001           ]); grid on; title('  4th order error');
subplot(425),plot(x, s6-z1,'r','LineWidth',2); axis([ 1 7 -0.00000001         0.00000001        ]); grid on; title('  6th order error');
subplot(426),plot(x, s8-z1,'r','LineWidth',2); axis([ 1 7 -0.0000000001       0.0000000001      ]); grid on; title('  8th order error');
subplot(427),plot(x,s10-z1,'r','LineWidth',2); axis([ 1 7 -0.0000000000001    0.0000000000001   ]); grid on; title(' 10th order error');
subplot(428),plot(x,s12-z1,'r','LineWidth',2); axis([ 1 7 -0.00000000000001   0.00000000000001  ]); grid on; title(' 12th order error');

%legend('real','2','4','6','8','10','12')


for i=2:N-1
    t2(i) = f21 * ( y(i+1) + y(i-1) -2.0*y(i) );
end
t2 = t2/dx/dx;
for i = 3:N-2
    t4(i) = f41 * ( y(i+1) + y(i-1) - 2.0*y(i) ) + f42 *( y(i+2) + y(i-2) - 2.0*y(i) );
end
t4 = t4/dx/dx;

for i = 4:N-3
    t6(i) = f61 * ( y(i+1) +y(i-1) - 2.0*y(i) ) + f62 *( y(i+2) + y(i-2) - 2.0*y(i) ) + f63*( y(i+3) + y(i-3) - 2.0*y(i) );
end
t6 = t6/dx/dx;

for i = 5:N-4
    t8(i) = f81 * ( y(i+1) +y(i-1) - 2.0*y(i) ) + f82 *( y(i+2) + y(i-2) - 2.0*y(i) ) + f83*( y(i+3) + y(i-3) - 2.0*y(i) ) + f84*( y(i+4) + y(i-4) - 2.0*y(i) );
end
t8 = t8/dx/dx;

for i = 6:N-5
    t10(i) = f101 * ( y(i+1) +y(i-1) - 2.0*y(i) ) + f102 *( y(i+2) + y(i-2) - 2.0*y(i) ) + f103*( y(i+3) + y(i-3) - 2.0*y(i) ) + f104*( y(i+4) + y(i-4) - 2.0*y(i) ) + f105*( y(i+5) + y(i-5) - 2.0*y(i) );
end
t10 = t10/dx/dx;


for i = 7:N-6
    t12(i) = f121 * ( y(i+1) +y(i-1) - 2.0*y(i) ) + f122 *( y(i+2) + y(i-2) - 2.0*y(i) ) + f123*( y(i+3) + y(i-3) - 2.0*y(i) ) + f124*( y(i+4) + y(i-4) - 2.0*y(i) ) + f125*( y(i+5) + y(i-5) - 2.0*y(i) ) + f126*( y(i+6) + y(i-6) - 2.0*y(i) );
end
t12 = t12/dx/dx;

figure
subplot(411),plot(x,z2, x,t2, x,t4, x,t6, x,t8, x,t10, x,t12,'LineWidth',2);
grid on
axis([ 1 7 -1 1])
legend('real','2','4','6','8','10','12')
title('Second Order Derivative');
subplot(423),plot(x, t2-z2,'LineWidth',2); axis([ 1 7 -0.001              0.001            ]); grid on; title('  2nd order error');
subplot(424),plot(x, t4-z2,'LineWidth',2); axis([ 1 7 -0.00001            0.00001          ]); grid on; title('  4th order error');
subplot(425),plot(x, t6-z2,'LineWidth',2); axis([ 1 7 -0.00000001         0.00000001       ]); grid on; title('  6th order error');
subplot(426),plot(x, t8-z2,'LineWidth',2); axis([ 1 7 -0.00000000001      0.00000000001    ]); grid on; title('  8th order error');
subplot(427),plot(x,t10-z2,'LineWidth',2); axis([ 1 7 -0.000000000001     0.000000000001   ]); grid on; title(' 10th order error');
subplot(428),plot(x,t12-z2,'LineWidth',2); axis([ 1 7 -0.000000000001     0.000000000001   ]); grid on; title(' 12th order error');
