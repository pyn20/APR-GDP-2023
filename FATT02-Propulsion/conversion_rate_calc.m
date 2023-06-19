%housekeeping
clear
clc
close all


%catalytic conversion rates to catalyst mass


%parameters

cr = 52.8; %cataytic conversion rate in mmol/min/g

aLHV = 18.6; %in MJ/kg
hLHV = 120; %in MJ/kg

GFM = 2; %gfm of hydrogen
EFF = 0.36; %efficiency

maxP = 6692; %max power required in kW for all engines

T1 = 15; %reference temperature for calculating ammonia density
T2Cat = 400; % Reference temperature of heated ammonia (Catalyst Pipeline)

aRho = 12410; %density of the active material
sRho = 2500; %density of the support material
amRho = 0.73*((T1+273.15)/(T2Cat+273.15)); %density of ammonia in gas state
cRho = 7500; %density of the casing

aP = 0.05; %weight percentage of the active material in the catalyst
sP = 1-aP; %weight percentage of the support material in the catalyst

WHSV = 60000; %volume flow rate per unit mass of catalyst (mL/g/h)

cL = 0.5; %the length of the catalyst
cT = 0.005; %thickness of the casing

cVel = 5; %velocity of ammonia in the catalyst (m/s)

mPE = 0.517; %maximum mass flow rate per engine
mdot = mPE*2*0.15; %mass flow rate from configuration
fracCat = 0.777; %fraction of ammonia going into catalyst
mCatalyst = mdot*fracCat; %mass flow rate through catalyst



%unit conversion

cr_si = cr/1000/60*GFM; %conversion rate in kg/s/kg

cr_power = cr_si*120*1000*EFF;
disp("Power output per kilogram of catalyst in kW:")
disp(cr_power)

WHSV_SI = WHSV/3600/1000; %conversion to m^3/s/kg


%volume calculation


VFR = mCatalyst/amRho; %volume flow rate of ammonia
MFR = mCatalyst; %mass flow rate of catalyst
sVFR = VFR/2; %volume flow rate per catalyst (for two engines)
aCSA = sVFR/cVel; %cross sectional area of ammonia flow in the catalyst
aVol = aCSA*cL; %volume of the ammonia flow section in the catalyst

catM = sVFR/WHSV_SI;

cRho = aRho*aP+sRho*sP; %overall density of the catalyst
cVol = catM/cRho; %volume of the catalyst
cCSA = cVol/cL; %cross sectional area of the catalyst

disp("The total cross sectional area is (m^2):")
CSA = cCSA+aCSA;
disp(CSA)

disp("The radius of the sectional area is (m):")
R = sqrt(CSA/pi);
disp(R)

disp("The total volume of each catalyst is (m^3):")
Vol = cVol + aVol;
disp(Vol)


%total power output

totalPower = 18600*(mPE*2-MFR)*EFF+catM*cr_power;


%casing calculation

tR = R+cT; %radius of the catalytic converter including the casing thickness
casCSA = pi*(tR^2-R^2); %the cross sectional area of the outer casing
casVol = casCSA*cL+2*cT*pi*tR^2; %total volume of the outer casing
casM = cRho*casVol; %the mass of the outer casing

disp("The volume of the outer casing is:")
disp(casVol)
disp("The mass of the outer casing is:")
disp(casM)
disp("The total mass of a singular catalytic converter is:")
disp(casM+catM)
