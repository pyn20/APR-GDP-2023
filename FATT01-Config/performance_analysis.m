clear;
clc;

%Paramters
T_W = 0.29;%thrust_to_weight_ratio
W_S = 5300;%wing loading
AR = 8.5;
g = 9.81;
e = 0.7827;%corrected oswald efficiency
Vs = 44.9;%use airfoil clmax
miu = 0.03;%friction coefficient in dry concrete,ground roll resistance
S = 71.2965;
M0 =38519.01; %
W0 =M0*g;
BPR = 5 ;%by pass ratio
Tmax = 64.5*10^3; %maximum thrust(N)
rho_t = 1.225;
bhp = ;%engine brake horsepower
Dp = ;%propeller diameter(ft)

%Aerodynamic Parameter
CL_G = 1.488; %calculated based on AoA of aircraft seats on the ground
CD0 = 0.017;
CD_to = 0.1391;
CLclimb = 2.1058;%clmax 
L_D = CLclimb/CD_to ; %for climbing
CLmax_clean = 1.3649;
% DOEI =0.362*0.5*rho_t*S*Vs^2;%drag???  use VLOF for velocity??
DOEI =0.1430*0.5*rho_t*S*(1.2*Vs)^2;
CD0_l =0.12836;%CD0 during at breaking distance

%TAKE OFF
hobs = 35; %FAR 25 obstacle height(in ft)
hobs = hobs * 0.3048; %change to meter
%ground roll
VLOF = 1.1* Vs;%min. final velocity for ground roll
KT = T_W - miu;
KA = rho_t / (2*W_S) * (miu*CL_G - CD0 - CL_G^2/(pi*AR*e));
SG = 1/(2*g*KA) * log((KT+KA*VLOF^2)/(KT)); %ground roll distance

%rotation
dtheta_dt = 3;%degree/s from errikos
aLOF_aG = 3; %from errikos
SR = (aLOF_aG/dtheta_dt) * VLOF;

%transition,approximated as circular arc
n = 1.2;%raymer
VTR = 1.15*Vs;%average velocity during transition
R = VTR^2/((n-1)*g);
gamma_CL = asin(T_W - 1/L_D);%in radian
hTR = R*(1-cos(gamma_CL));
if hobs >= hTR
    STR = R * sin(gamma_CL);
    SCL = (hobs - hTR)/tan(gamma_CL);
elseif hobs < hTR %If the obstacle height is cleared before the end of the transition segment,
    STR = sqrt(R^2 - (R-hobs)^2);
    SCL = 0;
end

STO = 1.15 * (SG + SR +SCL + STR); %take off distance required by FAR 25
disp(["ground roll distance", SG])
disp(["rotation", SR])
disp(["transition", STR])
disp(["climb", SCL])
fprintf(['Take off distance is %f m' ...
    '' ...
    ' \n'],STO)
%% BFL,page704
%All calculated in ft, changed to m at last.
%engine fail at velocity lower than VR
rho_SL = %desired sea-level condition
sigma = rho_t/rho_SL;
Ne = 2; %number of engine
gamma_min = 0.024; %for 2 engine (in radian)
Kp = 5.75;%5.75 for variable pitch,4.6 for fixed pitch
U = 0.01 * CLmax_clean + 0.02;
gamma_CL1 = asin((Ne-1)/Ne * T_W - DOEI / W0);%T_W is T_W0, DOEI should be evaluate at 1.2Vs
T_bar = Kp*bhp*((rho_t/rho_SL*Ne*Dp^2)/bhp)^(1/3);%for prop, need bhp and Dp
G = gamma_CL1 - gamma_min;
%remember convert every unit to fps
% rho_t1 = rho_t/	16.02;
% g1 = g/0.3048;
hobs1 = 35;%ft
% W_S1 = W_S*0.020885434273039;
% W_S1 = (W_S/4.448)*9.290 *10^-2;
BFL = 0.863/ (1+2.3*G) * (W_S/(rho_t*g*CLclimb) + hobs1)*(1/(T_bar/W0 - U) + 2.7) + 655/sqrt(sigma);%in ft
BFL = 0.3048*BFL;%change from feet to meter
fprintf('BFL is %f \n',BFL)
if BFL <= STO/1.15
    disp("BFL is smaller than STO/1.15")
else
end
%% Landing Analysis

%calculate landing distance required
W_landing = 35784*g;

%Approach and flare
gamma_a = 3; %max.approach angle for transport ac in degree
n_l = 1.2;
hobs_l = 50; %ft,obstacle clearance
hobs_l = hobs_l* 0.3048;%m
VF = 1.23*Vs;%average speed during flare
R_l = VF^2/((n_l-1)*g);
hF = R_l*(1-cosd(gamma_a));%flare height

Sa = (hobs_l - hF)/tand(gamma_a);%approach distance
SF = R_l* sind(gamma_a);%flare distance

%touch down
tFR = 3; %usually 1-3s, assumed delay
VTD = 1.15*Vs;%touch down speed
SFR = tFR * VTD;
miu_l = 0.5;%resistance for hard runway for civil ac 
CL_l = 0;
%thrust reverse
Trev_Tmax = -0.6; %reversed thrust for turboprop
Trev = Trev_Tmax*Tmax;
%idling engine
Tidle_Tmax = 0.125; %0.10-0.15
Tidle = Tidle_Tmax*Tmax;

%for idling engine
KT_l = Tidle/W_landing - miu_l;
KA_l = rho_t/(2*W_S) * (miu_l * CL_l - CD0_l - CL_l^2/(pi*AR*e));
SB = 1/(2*g*KA_l) * log(KT_l/(KT_l + KA_l * VTD^2));
ALD = Sa + SF + SFR +SB;
LDR = ALD *1.666; %1.666 is safety factor,FAA requries
%LDA for airport is 1815m,ref
fprintf('Sa: %f m \n',Sa)
fprintf('SF: %f m\n',SF)
fprintf('SFR: %f m\n',SFR)
fprintf('SB: %f m\n',SB)
% disp('LDR is')
fprintf('LDR is %f m \n',LDR)

%% Mission Performance



%% Point Performance



%% Flight Envelope - SEP plot
