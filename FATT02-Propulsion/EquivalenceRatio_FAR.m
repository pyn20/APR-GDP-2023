clear
clc
close all

% Converting equivalence ratio to fuel:air ratio
% equivalence ratio = FAR_real / FAR_stoi;

% phi = 1;

% Calculating fuel:air ratio for complete combutsion by assuming negligible
% nitrogen in th e reactant

% {NH3 + 3/4*O2 -> 1/2*N2 + 3/2*H2O}     * 70%
% {H2 + 1/2*O2 -> H2O}    * 30%

% vN = 79/21*vO;
% mR = vN/vO*28/32;


mf_N = 14.01*0.7;
mf_H = 1.008*3*0.7 + 1.008*2*0.3;
mf = mf_N +mf_H;
mo = (3/4*0.7 + 1/2*0.3) *15.999*2;
ma = (100/21)*mo;

FAR_stoi = mf/ma; 

% FAR_real = phi* FAR_stoi;

%FAR_real = 0.0162;
FAR_real = 0.012546;
phi = FAR_real / FAR_stoi