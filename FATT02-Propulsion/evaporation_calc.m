%housekeeping
clear
clc
close all


%%%evaporative cooling calculator


%a whole bunch of coefficients

rhoA = 1.225;
v = 15;
L = 3;
mu = 1.789e-5;
kA = 0.02785;
prA = 0.705;
AA = 7*28; %guessed an average wing perimeter of 7, 28 is the length of both wings combined
T1 = 50;

kAl = 121; %for AL2024 alloy
tAl = 0.003; %thickness of the skin
AAl = 5*26; %total contact surface area of air and ammonia

rhoNH = 684.015;
bNH = 0.00245;
g = 9.81;
kNH = 0.671;
cpNH = 80.8;
dvNH = 266e-6;
g = 9.81;
T4 = -33.5;

HV = 23370;
GFMNH = 17;


%calculate nusselt number for air

re = rhoA*v*L/mu;

nuA = 0.0296*re^0.8*prA*(1/3);


%calculate heat transfer coefficient for air to the skin

h = nuA*kA/L;


%solve simultaneous equations


syms T2 T3 Qdot

[solQdot, solT2, solT3] = solve(Qdot == h*AA*(T1-T2), Qdot == kAl*AAl/tAl*(T2-T3), Qdot == 0.52*kNH/L*(rhoNH^2*cpNH*bNH*(T3-T4)*g/(dvNH*kNH))^0.2*AAl*(T3-T4));

disp(double(solQdot))
disp(double(solT2))
disp(double(solT3))

T3new = 0.0171;
asdf = double(rhoNH^2*cpNH*bNH*(T3new-T4)*g/(dvNH*kNH));
NuAmmonia = 0.52*asdf^0.2;
hAmmonia = NuAmmonia*kNH/L;

%calculate equivalent evaporative mass

molsec = double(solQdot(1))/HV;
totalM = molsec*0.17*3600;
