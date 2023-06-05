%housekeeping
clear
clc
close all



%%%INPUT PARAMETERS



FAR = 0.067; %Fuel to Air ratio by mass

mNH3 = 17; %GFM of Ammonia
mH2 = 2; %GFM of Hydrogen
mN2 = 28; %GFM of Nitrogen
mO2 = 32; %GFM of Oxygen
mH2O = 18; %GFM of Water

MNH3 = 0.3784; %Mass percentage of Ammonia in fuel mixture
MN2 = 0.4595; %Mass percentage of Nitrogen in fuel mixture
MH2 = 0.1622; %Mass percentage of Hydrogen in fuel mixture
MAIR = (MNH3+MN2+MH2)/FAR; %NOTE THAT THIS SHOULD JUST BE EQUAL TO 1/FAR

nRAIR = 3.73; %Molar ratio  of Nitrogen to Oxygen in Air
MRAIR = 3.73*mN2/mO2; %Mass ratio of Nitrogen to Oxygen in Air

aLHV = 18.6; %Lower heating value of Ammonia
hLHV = 120; %Lower heating value of Hydrogen

cN2 = 1.275*1000; %Heat capacity at 1800C
cH2O = 2.756*1000; %Heat capacity at 1800C
cO2 = 1.166*1000; %Heat capacity at 1800C

AVG = 6.02214e23;
hN2 = 941000;
hO2 = 495000;


%%%MOLAR SUMMATION


%COMBUSTION SPECIES
nNH3 = MNH3/mNH3; %Number of moles of Ammonia that is being combusted
nH2 = MH2/mH2; %Number of Moles of Hydrogen that is being combusted


%ABSORPTION SPECIES
nN2AIR = MAIR*MRAIR/(MRAIR+1)/mN2; %Number of moles of Nitrogen in air
nN2 = MN2/mN2 + nNH3/2 + nN2AIR; %Number of moles of Nitrogen that's heated up on the product side

nH2O = nH2; %Number of moles of Water

nO2AIR = MAIR/(MRAIR+1)/mO2; %Number of moles of Oxygen in Air
nO2WATER = nH2O/2; %Number of moles of Oxygen used in Water
nO2 = nO2AIR - nO2WATER; %Number of moles of Oxygen in excess that's heated up on the product side

%ENERGY CALCULATION

eNH3 = mNH3*aLHV;
eH2 = mH2*hLHV;

E = (eNH3 + eH2)*1e6; %total energy produced from combustion in Joules

deltaT = E/(cN2*nN2*mN2+cH2O*nH2O*mH2O+cO2*nO2*mO2)/1000;


%NOX EMISSIONS
hsN2 = hN2/AVG; %bond enthalpy per molecule of N2
msN2 = mN2/AVG/1000; %mass of single N2 molecule
vN2 = sqrt(2*hsN2/msN2); %velocity of N2 molecule required to crack

[vpN2, vavgN2, vrmsN2, KEN2, psN2] = MaxwellBoltzmann(2000,mN2,vN2,100000,1);


hsO2 = hO2/AVG; %bond enthalpy per molecule of O2
msO2 = mO2/AVG/1000; %mass of single O2 molecule
vO2 = sqrt(2*hsO2/msO2); %velocity of O2 molecule required to crack

[vpO2, vavgO2, vrmsO2, KEO2, psO2] = MaxwellBoltzmann(2000,mO2,vO2,100000,2);



disp(nN2)
disp(nN2AIR)
disp(nN2AIR/nN2)