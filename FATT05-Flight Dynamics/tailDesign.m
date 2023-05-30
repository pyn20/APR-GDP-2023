% Housekeeping
clear
clc
close all

%% Parameter Definition
% Sizing
c_HT            = 1; % jet transport - Raymer
c_VT            = 0.09; % jet transport - Raymer
fuselage_length = 30; % DUMMY
L_HT            = 0.5 * fuselage_length; % 50-55 % - Raymer
L_VT            = 0.5 * fuselage_length; % 50-55 % - Raymer
S_W             = 90; % Wing area - Aero Team DUMMY
b_W             = 25; % Wing span? - Aero Team DUMMY
CBar_W          = 3.5; % MAC - Aero Team DUMMY

% Geometry
lambda_VT   = 0.4; % Raymer
lambda_HT   = 0.4; % Raymer
AR_VT       = 1.6; % Raymer
AR_HT       = 4; % Raymer

% Aerofoil - NACA 0012  (Abbott and Von Doenhoff)
a       = 5.73; % rad^-1
L_Dmax  = 100;
C_D0    = 0.0055;

% Control surfaces
Ce_C    = 0.25; % Raymer
Cr_C    = 0.32; % Raymer
span_e  = 0.9;
span_r  = 0.9;

%% Calculations
S_VT = c_VT * b_W * S_W / L_VT;
S_HT = c_HT * CBar_W * S_W / L_HT;
b_VT = sqrt(AR_VT * S_VT);
b_HT = sqrt(AR_HT * S_HT);
C_r_VT = 2 * S_VT / (b_VT*(1+lambda_VT));
C_r_HT = 2 * S_HT / (b_HT*(1+lambda_HT));
rudder_hingeline    = 1 - (0.8 * Cr_C); % Raymer
elevator_hingeline  = 1 - (0.0 * Ce_C); % To look good
phi_HT              = atand((b_HT*tand(0) - lambda_HT*C_r_HT*elevator_hingeline + elevator_hingeline*C_r_HT)/b_HT);
phi_VT              = atand((b_VT*tand(10) - lambda_VT*C_r_VT*rudder_hingeline + rudder_hingeline*C_r_VT)/b_VT);