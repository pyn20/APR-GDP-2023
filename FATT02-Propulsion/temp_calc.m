%housekeeping
clear
clc
close all



%%%INPUT PARAMETERS



FAR = 1; %Fuel to Air ratio by mass

mNH3 = 17; %GFM of Ammonia
mH2 = 2; %GFM of Hydrogen
mN2 = 28; %GFM of Nitrogen
mO2 = 32; %GFM of Oxygen
mH2O = 18; %GFM of Water

MNH3 = 0.3784; %Mass percentage of Ammonia in fuel mixture
MN2 = 0.4595; %Mass percentage of Nitrogen in fuel mixture
MH2 = 0.1622; %Mass percentage of Hydrogen in fuel mixture
MAIR = (MNH3+MN2+MH2)/FAR; %NOTE THAT THIS SHOULD JUST BE EQUAL TO 1/FAR

nRAIR = 3.73; %Molar ratio of Nitrogen to Oxygen in Air
MRAIR = 3.73*mN2/mO2; %Mass ratio of Nitrogen to Oxygen in Air


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

disp(nN2)
disp(nN2AIR)
disp(nN2AIR/nN2)