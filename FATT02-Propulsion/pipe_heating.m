%housekeeping
clear
clc
close all


%%%pipe & fin sizing calculator


%data import

tableRho = readtable('C:\Users\Joseph\Desktop\Work stuff probably\Gross Domestic Product\nh3_density.csv');
tempRho = tableRho{:,1};
Rho = tableRho{:,2};

tableMu = readtable('C:\Users\Joseph\Desktop\Work stuff probably\Gross Domestic Product\visc_temp.csv');
tempMu = tableMu{:,1};
Mu = tableMu{:,2};


%fitting functions to table data

pRho = polyfit(tempRho,Rho,5);

tempRhoNew = linspace(-35,400);
RhoNew = polyval(pRho,tempRhoNew);

figure('Name','Ammonia Density vs Position')

plot(tempRhoNew,RhoNew)

pMu = polyfit(tempMu,Mu,5);

tempMuNew = linspace(-35,400);
MuNew = polyval(pMu,tempMuNew);

figure('Name','Dynamic Viscosity vs Position')

plot(tempMuNew,MuNew)


%a whole bunch of coefficients

Rho1 = RhoNew(1);
mdot = 0.514;
R1 = 0.05;
A1 = pi*R1^2;
u1 = mdot/(A1*Rho1);


%the big equation for duct area

ductLength = linspace(0,1);
xi = ductLength(2)-ductLength(1);

A = zeros(size(ductLength));
A(1) = A1;
sqrtArea(1) = sqrt(A1);

a = zeros(size(ductLength));
b = zeros(size(ductLength));

for i = 1:length(ductLength)-1
    a(i) = mdot^2/(RhoNew(i)*A(i))*RhoNew(i+1)+4*MuNew(i+1)*mdot*xi/pi;
    b(i) = -4*MuNew(i+1)*mdot*xi/pi;
    c = -mdot^2;

    sqrtArea(i+1) = (-b(i)+sqrt(b(i)^2-4*a(i)*c))/(2*a(i));
    A(i+1) = sqrtArea(i+1)^2;
end

Area = sqrtArea.^2;
R = sqrt(Area./pi);

figure('Name','Area vs Position')

plot(ductLength,Area)

figure('Name','Radius vs Position')

plot(ductLength,R)


%velocity shenanegans

Vel = mdot./(RhoNew.*Area);

figure('Name','Velocity vs Position')

plot(ductLength,Vel)

