clear
clc
close all
mdot = 0.72;
fracCat = 0.77;
rhoSS = 8000; %Density of stainless steel
pipeLengthCat = 5;
pipeLengthDirect = 15;
tpipe = 5e-3; %Pipes are 5mm thick
mCatalyst = mdot*fracCat; %Mass flow rate through to catalyst
mDirect = mdot*(1-fracCat); %Mass flow rate of direct NH3 supply 
targetv = 100;
T1 = 15; %reference temperature for calculating ammonia density
T2Cat = 400; % Reference temperature of heated ammonia (Catalyst Pipeline)
T2Direct = -10; %Reference temperature of ammonia with direct feed

rhoAmmoniaCat = 0.73*((T1+273.15)/(T2Cat+273.15));
volFlowCat = 0.5*mCatalyst/rhoAmmoniaCat; % volume flow rate per pipe
TargetAreaCat = volFlowCat/targetv;
diameterPipeCat = 2*sqrt(TargetAreaCat/pi)
weightPipeCat = pi*diameterPipeCat*tpipe*pipeLengthCat*rhoSS

rhoAmmoniaDirect = 0.73*((T1+273.15)/(T2Direct+273.15));
volFlowDirect = 0.5*mDirect/rhoAmmoniaDirect;
TargetAreaDirect = volFlowDirect/targetv;
diameterPipeDirect = 2*sqrt(TargetAreaDirect/pi)
weightPipeDirect = pi*diameterPipeDirect*tpipe*pipeLengthDirect*rhoSS

totalPipingWeight = weightPipeDirect+weightPipeCat
