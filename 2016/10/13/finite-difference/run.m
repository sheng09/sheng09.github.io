clear;
clc;
close all;

dx = 0.1;
N  = 40;
x  = (0:N)*dx;
y  = sin(x);
z1 = cos(x); %1st order derivative
z2 =-sin(x); %2nd order devivative

s2 = x.*0;
s4 = x.*0;
s6 = x.*0;

t2 = x.*0;
t4 = x.*0;
t6 = x.*0;

c21 =  1.0/2;
c41 =  4.0/6;
c42 = -1.0/12;
c61 = 3.0/4;
c62 = -3.0/20;
c63 = 1.0/60;

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

subplot(311),plot(x,z1);
grid on
hold on;
subplot(311),plot(x,s2,'r')
subplot(311),plot(x,s4,'k')
subplot(311),plot(x,s6,'g')
axis([ 0.5 3.5 -1 1])
legend('real','2','4','6')
title('First Order Derivative');


subplot(312),plot(x,s2-z1,'r');
title('Error')
grid on
axis([0.5 3.5 -0.01 0.01])
subplot(313),plot(x,s4-z1,'k');
grid on
hold on
subplot(313),plot(x,s6-z1,'g');
axis([0.5 3.5 -0.00001 0.00001])
title('Error')
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

figure
subplot(311),plot(x,z2);
grid on
hold on;
subplot(311),plot(x,t2,'r')
subplot(311),plot(x,t4,'k')
subplot(311),plot(x,t6,'g')
axis([ 0.5 3.5 -1 1])
legend('real','2','4','6')
title('Second Order Derivative');

subplot(312),plot(x,t2-z2,'r');
title('Error')
grid on
axis([0.5 3.5 -0.001 0.001])
subplot(313),plot(x,t4-z2,'k');
grid on
hold on
subplot(313),plot(x,t6-z2,'g');
axis([0.5 3.5 -0.000001 0.000001])
title('Error')

