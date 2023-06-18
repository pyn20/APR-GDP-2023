%housekeeping
clear
clc
close all


%%%thrust loss from placing the catalyst in the exhaust


%whole bunch of constants

u = 366.1717;
t = 550+273.5;
r = 287;
gamma = 1.2;
Re = 9.1705e+06;
rho = 0.4786;
finA = 1.895;
rad = 0.55/2;
catA = 0.0190;

a = sqrt(gamma*r*t);


%new relevant velocity calculation

uNew = u*(pi*rad^2)/(pi*rad^2-catA);

M = uNew/a;


%Cf calculation

A = 0.0392; %constants for flat plate skin friction coefficient at mach 0.9
B = -0.16;

Cf = A*Re^B;


%wall shear stress calculation

tw = Cf*0.5*rho*uNew^2;


%frictional force calculation

frictionF = tw*finA;
powerL = frictionF*u;

