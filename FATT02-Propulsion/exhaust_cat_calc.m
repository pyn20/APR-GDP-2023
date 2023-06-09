%housekeeping
clear
clc
close all

%%%CALCULATING EXHAUST FINS SIZING



%whole bunch of coefficients

Qdot = 160000;

finNo = 40;

mflow = 0.517;
faRatio = 0.0455;

rhoN = 0.493;
rhoW = 0.02455;
rhoO = 0.4809;
rhoS = 7500;

prN = 0.708;
prW = 0.9132;
prO = 0.726;

muN = 36.59e-6;
muW = 30e-6;
muO = 43.15e-6;

L = 0.5;
R = 0.0778;

eR = 0.55/2;

kN = 0.05669;
kW = 0.07281;
kO = 0.0481;


%mass flow calculation

mdot = mflow/faRatio + mflow;


%exhaust species ratio calculation

[mA, mN, mH, mAU, mAR, pA, pAR] = molar_calculator(0.7);

mAir = 1/faRatio;

maN = mAir*0.79*28;
maO = mAir*0.21*32;

mrN = maN/(maN+maO);

meN = mN + mAir*mrN + mA*14/17;
meW = (mA*3/17 + mH)*9;
meO = mAir*(1-mrN) - meW*8/9;

erN = meN/(meN + meW + meO);
erW = meW/(meN + meW + meO);
erO = meO/(meN + meW + meO);


%exhaust velocity calculation

rho = rhoN*erN + rhoW*erW + rhoO*erO;

vdot = mdot/rho;
v = vdot/(pi*eR^2);
vNew = v*(pi*eR^2)/(pi*eR^2-pi*R^2);


%reynolds number calculation

mu = muN*erN + muW*erW + muO*erO;

re = rho*vNew*L/mu; %for flat plate


%nusselt number calculation

pr = prN*erN + prW*erW + prO*erO;

nu = 0.023*re^0.8*pr^0.3; %flat plate nusselt number


%thermal conductivity calculation

k = kN*erN + kW*erN + kO*erO;

%heat transfer coefficient calculation

h = nu*k/L;

%heat calculations

A = Qdot/(550-400)/h;

finH = A/(finNo*2*L);

volume = pi*(R+0.01)^2*0.005*2+pi*((R+0.01)^2-R^2)*0.5+A*0.001*0.5;
mass = volume*rhoS+11.5698;





