clear clc
close all

ammonia_mm=17.03052;
n2_mm=28.01340;
o2_mm=32;
h2_mm=2;
h2o_mm=18.02;
no_mm= 30.0061;

% balanced equations 4NH3+5O2 -> 4NO + 6H2O
% 2H2 + 1O2 -> 2H2O
mNH3=70;
mH2=mNH3*3/7;


nN2Rat=3.768; % for each mole of O2 how many moles of N2 in air

nNH3=mNH3/ammonia_mm;
nH2=mH2/h2_mm;

nO2=5/4*nNH3+0.5*nH2;

m_A_ST= nO2*o2_mm + nO2*nN2Rat*n2_mm;
m_F_ST= mNH3+mH2; %g at 70-30 mass ratio for Ammonia - H2

% phi=1 FAR=0.057523;

FAR=0.01255;
AFR_ST=m_A_ST/m_F_ST;

AFR_ST_KE=(23*32+62.5*28.01)/(226.4412);

AFR=1/FAR;

lambda=AFR/AFR_ST;
phi=1/lambda;



% balanced equation 4NH3+6NO -> 5N2 + 6H2O
nNO=nNH3;

m_NO= nNO*no_mm;
AMMONIAMASS= 2/3*nNO*ammonia_mm;

WATERMASS=nNO*18.01528;
NITROGENMASS= 5/6*nNO* 28.0134;

fprintf('We will need %.4g grams of ammonia to reduce %.4g grams of NOx emissions\n',AMMONIAMASS,m_NO) 
fprintf('As a result we will obtain %.4g grams of water and %.4g grams of N2',WATERMASS,NITROGENMASS) %masses for reduction only not considering initial emissions
