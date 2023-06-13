clear
clc
close all

me = 30; %Mass flow rate of Burner air (Same as air in, assumed, just change this if it's wrong)
T0b = 1200+273; %Approximate temperature of Burner
dBurner = 0.54 ; %Diameter of Exhaust region
lBurner = 0.22; %Approximate length of Burner region
CpBurner = 1204 ; %Cp of air at Burner temp
muBurner = 3.846e-5; % Kinematic viscosity of air at Burner
kBurner = 0.06093; %W/mk conductivity of air at Burner
sBoltz = 5.6704e-8; %Stefan Boltzmann const
SABurner = pi*dBurner*lBurner; %Surface area of the burner
tBurner = 5e-3; %Thickness of burner
emTit = 0.19;%Emmisivity of titanium
kTit = 11.4; %thermal conductivity of titanium
Tw = 600 + 273; %Temp at the inner wall of burner, take to be max svc temp of titanium.


%Calculating heat flow from Burneraust to the copper pipes (Convection +
%Radiation)
ABurner = pi*(dBurner/2)^2;% if you cannot figure this one out you may have brain damage
NuBurner = 0.023*(((me*dBurner)/(ABurner*muBurner))^0.8)*((CpBurner*muBurner)/(kBurner))^0.3;% Noooooselt nombre
hBurner = NuBurner*kBurner/dBurner;% h at the Burner
qdot = hBurner*(T0b - Tw);
power = qdot*SABurner;
Tw2 = Tw - qdot*tBurner/kTit; %Temperature of the outer wall of the burner
qdotRad = emTit*sBoltz*(Tw2^4-273^4);
powerRad = qdotRad*SABurner;
qdotTotal = qdot + qdotRad;
powerTotal = power + powerRad;