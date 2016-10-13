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

c21 =  1.0/2;
c41 =  4.0/6;
c42 = -1.0/12;
c61 = 1.0/4;
c62 = -3.0/20;
c63 = 1.0/60;

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

plot(x,z1);
hold on;
plot(x,s2,'r')
plot(x,s4,'k')
plot(x,s6,'g')



