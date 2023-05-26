%housekeeping
clear
clc
close all

%mixture properties

mr = 0.7; %ratio of ammonia in an ammonia/hydrogen mixture
%this mixture ratio mimics the combustion of diesel


%ammonia combustion properties

aLHV = 18.6; %the lower heating value of ammonia in MJ/kg
aHHV = 22.5; %the higher heating value of ammonia in MJ/lg
aAFT = 2073.15; %the adiabatic flame temperature of ammonia in Kelvin (1800 celsius)
aMLBV = 0.07; %the maximum laminar burning velocity of ammonia in m/s
aMAIT = 923.15; %the minimum auto ignition temperature of ammonia in kelvin (650 celsius)


%hydrogen combustion properties

hLHV = 120;
hHHV = 141.7;
hAFT = 2400;
hMLBV = 3;
hMAIT = 858;


%combustion properties of mixture

LHV = mr*aLHV + (1-mr)*hLHV;
HHV = mr*aHHV + (1-mr)*hHHV;
AFT = mr*aAFT + (1-mr)*hAFT;
MLBV = mr*aMLBV + (1-mr)*hMLBV;
MAIT = mr*aMAIT + (1-mr)*hMAIT;

disp("Lower heating value of mixture:")
disp(LHV)

disp("Higher heating value of mixture:")
disp(HHV)

disp("Adiabatic flame temperature of mixture:")
disp(AFT)

disp("Maximmum laminar burning velocity of mixture:")
disp(MLBV)

disp("Minimum auto ignition temperature of mixture:")
disp(MAIT)









