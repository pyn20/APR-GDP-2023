%housekeeping
% clear
% clc
% close all




%calculates the mass of ammonia catalytically converted to hydrogen
%depending on the ammonia-hydrogen mixture ratio, as well as energy ratios 
%ratios in comparison to pure ammonia or pure hydrogen fuel
%all assumes 100% efficiency

% INPUT
% mr = 0.7; %ratio of ammonia in final fuel mixture
% aGFM = 17; %molar mass of ammonia molecule
% hGFM = 2; %molar mass of hydrogen molecule
% nhR = 1/3; %nitrogen to hydrogen molar ratio

% [mA_fuelmix, mN_fuelmix, mH_fuelmix,pA,pAR] = molarCalc(0.7,17,2,1/3);
% 
% disp("Percentage of original Ammonia which remains in final mixture:")
% disp(pA)
% disp("Percentage of original Ammonia which is catalytically converted to Hydrogen:")
% disp(pAR)
%  
% disp("Mass percentage of Ammonia in fuel mixture")
% disp(mA_fuelmix)
% disp("Mass percentage of Nitrogen in fuel mixture")
% disp(mN_fuelmix)
% disp("Mass percentage of Hydrogen in fuel mixture")
% disp(mH_fuelmix)


function [mA_fuelmix, mN_fuelmix, mH_fuelmix,mAU,mAR,pA,pAR] = molar_calculator(mr)

%constants

aGFM = 17; %molar mass of ammonia molecule
hGFM = 2; %molar mass of hydrogen molecule
nGFM = 28; %molar mass of nitrogen molecule
nhR = 1/3; %ratio of nitrogen to hydrogen
eff = 0.8; %efficiency

%molar calculation

mH = 1/(nGFM/hGFM*nhR+mr/(1-mr)+1); %mass of hydrogen as a fraction of 1
mA = mr/(1-mr)*mH; %mass of ammonia as a fraction of 1
mN = aGFM/hGFM*nhR*mH; %mass of nitrogen as a fraction of 1

nA = mA/aGFM; %the number of moles of ammonia in final fuel mixture;
nH = mH/hGFM; %the number of moles of hydrogen in final fuel mixture;
nN = mN/nGFM; %the number of moles of nitrogen in the final fuel mixture

%note that these calculations are just ratios, not indicative of the actual
%number of moles required. this will require the final power output

mAR = (mN+mH)/eff;
mAC = mAR - mN - mH;

nAR = mAR/aGFM;
%this is the number of moles of ammonia that is to be converted to obtain
%the required mass of hydrogen 
nAC = mAC/aGFM; % number of moles of ammonia that went unreacted through the catalyst

nAU = nA - nAC; %unreacted ammonia ratio
mAU = nAU*aGFM; %unreacted mass of ammonia



%ammonia percentage calculation

pA =  nAU/(nAU+nAR)*100; %percentage of ammonia which remains for combustion
pAR = nAR/(nAU+nAR)*100; %percentage catalytically converted


% Mass percentage of Ammonia in fuel mixture
mA_fuelmix = mA/(mA+mN+mH);

% Mass percentage of Nitrogen in fuel mixture
mN_fuelmix = mN/(mA+mN+mH);

% Mass percentage of Hydrogen in fuel mixture
mH_fuelmix = mH/(mA+mN+mH);


end


%reactant molar ratios


