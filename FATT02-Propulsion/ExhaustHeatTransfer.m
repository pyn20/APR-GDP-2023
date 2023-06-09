clear
clc
close all

me = 30; %Mass flow rate of exhaust air (Same as air in, assumed, just change this if it's wrong)
T0e = 600+273; %Approximate temperature of exhaust
dExh = 0.54 ; %Diameter of exhaust region
lExh = 0.22; %Approximate length of exhaust region
CpExh = 1115 ; %Cp of air at exhaust temp
muExh = 3.846e-5; % Kinematic viscosity of air at exhaust
kExh = 0.06093; %W/mk conductivity of air at exhaust
Tpipes = 500+273;%Assumed because i dont really know how to do this part yet. WE just initialize it as this, it is solved in the loop
sBoltz = 5.6704e-8; %Stefan Boltzmann const
dPipes = 0.03; % Assume coolant pipe diameter 3cm
nLoops = floor(lExh/dPipes); %Number of loops we can make with the coolant pipes
APipes = nLoops*pi*dPipes*pi*dExh; %Exposed area of piping, equal to number of loops * circumference of exhaust * Circumference of piping



%Calculating heat flow from exhaust to the copper pipes (Convection +
%Radiation)
AExh = pi*(dExh/2)^2;% if you cannot figure this one out you may have brain damage
NuExh = 0.023*(((me*dExh)/(AExh*muExh))^0.8)*((CpExh*muExh)/(kExh))^0.3;% Noooooselt nombre
hExh = NuExh*kExh/dExh;% h at the exhaust
emTit = 0.19; % Emissivity constant of titanium which im assuming exhaust is made of. May be wrong
qdotExhRad = emTit*sBoltz*(T0e^4-Tpipes^4); %It's an order of magnitude lower ... interesting
qdotExhConv = hExh*(T0e-Tpipes);
qExh = qdotExhConv + qdotExhRad; % q = Q/A, therefore Q = qExh*APipes (Total heat transferred to pipes per unit time)

%Calculating temperature of the coolant fluid due to heat flux from copper
%pipes
mcoolant = 2; %Mass flow rate of coolant, assume it's like 2kg/s or some shit like that
NuPipe = 4.36; %This is for laminar, if coolant fluid flow is turbulent, follow a slightly different but equally simple process
kEG = 0.254; %Thermal conductivity of ethelene glycol
TEG = 198 + 273; % Assume Ethylene glycol will heat up to it's boiling temperature of 198 C
hPipe = NuPipe*kEG/dPipes; %h of the pipes transferring heat to the laminar flowing coolant in the pipes
cEG = 3140; %J/kg, specific heat capacity of Ethylene glycol

qdotPipes1 = hPipe*(Tpipes-TEG); %We have a condition that qdotPipes must = qExh, we can find the equilibrium temperature of the pipes in the exhaust
%ah dumb qdotPipes is a rate! We can raise the temperature of EG to 198k
%IF it is flowing at exactly 1kg/s


%Convergence to find equilibrium temperature of copper pipes inside exhaust
while abs(qdotPipes-qExh) > 10
    Tpipes = Tpipes + 0.01;
    qdotExhConv = hExh*(T0e-Tpipes);
    qdotExhRad = emTit*sBoltz*(T0e^4-Tpipes^4);
    qExh = qdotExhConv + qdotExhRad;
    qdotPipes = hPipe*(Tpipes-TEG);
end

%For the system outside of the engine (The part where we heat up the
%ammonia pipe)
Tair = -35 + 273;