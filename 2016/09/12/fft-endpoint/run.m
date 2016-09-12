%
clear;
clc;
close all;


T  = 1.0;
nt = 10;
dt = T/nt;
t  = linspace(0,T-dt,nt);         % without end point
y  = sin(2.0*pi*t);
fy = fft(y);

t_wrong = linspace(0,T,nt);       % with end point
y_wrong = sin(2.0*pi*t_wrong);
fy_wrong = fft(y_wrong);

nf = nt;
df = 1.0 / T;
fmax = 1.0/dt;
f  = linspace(0,fmax - df,nf);


t_dash  = linspace(0,T,40);
y_dash  = sin(2.0*pi*t_dash);
subplot(221),stem(t,y,'r'),hold on,plot(t_dash,y_dash,':');
xlabel('t'),ylabel('y');
subplot(223),stem(t_wrong,y_wrong,'r'), hold on,plot(t_dash,y_dash,':');
xlabel('t'),ylabel('y');


subplot(222),stem(f,abs(fy),'r');
xlabel('Hz');
ylabel('Amplitude');
axis( [0,fmax/2.0, 0, max(abs(fy))* 1.2 ] );
grid on;

subplot(224),stem(f,abs(fy_wrong),'r');
xlabel('Hz');
ylabel('Amplitude');
axis( [0,fmax/2.0, 0, max(abs(fy_wrong))* 1.2 ] );
grid on;

figure;
subplot(121),stem(t_wrong,y_wrong,'r'),hold on,plot(t_dash,y_dash,':');
xlabel('t'),ylabel('y');
subplot(122),stem(f,abs(fy_wrong),'r');
xlabel('Hz');
ylabel('Amplitude');
axis( [0,fmax/2.0, 0, max(abs(fy))* 1.2 ] );
grid on;


figure;
stem([t_wrong t_wrong+T+dt],[y_wrong y_wrong],'r');
hold on;
plot(t_dash,y_dash,':');
plot(t_dash+T+dt,y_dash,':');
xlabel('t'),ylabel('y');


figure;
stem([t t+T],[y y],'r');
hold on;
plot(t_dash,y_dash,':');
plot(t_dash+T,y_dash,':');
xlabel('t'),ylabel('y');
