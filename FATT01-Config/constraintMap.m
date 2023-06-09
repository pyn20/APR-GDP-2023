% Housekeeping
clear
clc
close all

%% Parameter Definition
% Specification
range   = 1200000; % m
bfl     = 1400; % m

range_diversion = 300000; % m ASSUMED
loiter_time     = 1200; % s
service_ceiling = 30000; % ft
climb_rate_service_ceiling = 100 * 0.00508; % ms^-1

% Assumed
rho             = 1.13; % on ground (2 000 ft)
rho_cruise      = 0.55; % 25k ft
rho_diversion   = 0.55; % 25k ft
rho_ServCeil    = 0.44; % 30k ft
V_cruise        = 139; % ms^1
V_diversion     = 139; % ms^1
V_ServCeil      = 139; % ms_1
AR              = 8.5;
e               = 0.79;
L_D_max         = 16.2; % Clean config
CLmax_climb2    = 1.5; % Clean config
CLmax_climb3    = 2.7; % Full flaps
CLmax_climb1    = 0.8 * CLmax_climb3; % TO flaps
CLmax_climb4    = CLmax_climb1; % Approach flaps
C_D0            = pi*AR*e / (2*L_D_max)^2;
c_cruise        = 0.000305; % Power specific fuel consumption, kg (W s)^-1
c_diversion     = 0.000305; % Power specific fuel consumption, kg (W s)^-1
c_loiter        = 2/3 * c_cruise; % Power specific fuel consumption, kg (W s)^-1
g               = 9.81; % ms^-2
eta_p           = 0.8; % Propeller efficiency

V_md_loiter     = 100; % Minimum drag speed at loiter altitude, ms^-1 DUMMY
x_loiter_speed  = 2/(3^(-3/4) + 3^(1/4)); % Term to maximise endurance

del_CD.UC       = 0.02;
del_CD.TO_flaps = 0.02;
del_CD.L_flaps   = -0.07;
del_e.UC        = -0.05;
del_e.TO_flaps  = -0.05;
del_e.L_flaps   = -0.010;

% Wing loading array
W_S = linspace(0,10000,1000);

%% Calculated Values
% Fuel weight fractions
w_frac.takeoff      = 0.975;
w_frac.climb        = 0.98;
w_frac.cruise       = 0.817;
w_frac.goAround     = 0.985;
w_frac.landing      = 0.99;
w_frac.diversion    = 0.975; % SUBJECT TO CHANGE
w_frac.loiter       = 0.968;

w_frac_at.cruise    = w_frac.takeoff * w_frac.climb;
w_frac_at.landing   = 0.85;
w_frac_at.diversion = w_frac_at.cruise * w_frac.cruise * w_frac.landing * ...
    w_frac.goAround;
w_frac_at.loiter    = w_frac_at.diversion * w_frac.diversion;
wf_w0               = 1.01 * (1 - w_frac_at.loiter * w_frac.loiter * w_frac.landing);

% Thrust lapse fractions
t_frac_at.cruise = 0.5;
t_frac_at.diversion = 0.5;
t_frac_at.loiter = 0.8;
t_frac_at.ground = 0.85;

% Dirty configurations
CD_climb1   = C_D0 + del_CD.TO_flaps;
CD_climb2   = C_D0;
CD_climb3   = C_D0 + del_CD.UC + del_CD.L_flaps;
CD_climb4   = C_D0 + del_CD.UC + del_CD.TO_flaps;
e_climb1    = e + del_e.TO_flaps;
e_climb2    = e;
e_climb3    = e + del_e.UC + del_e.L_flaps;
e_climb4    = e + del_e.UC + del_e.TO_flaps;

% T/O and Landing
TOP             = bfl * 3.2084 / 37.5;
sigma_ground    = 0.93; % 2 000 ft
LDA             = bfl;
S_a             = 305; % m


%% Constraint Equations
% BFL
% T_W.bfl = W_S / (sigma_ground*CLmax_climb1*TOP) / 47.88;
T_W.bfl = t_frac_at.ground * (0.297 - 0.019 * 2) * W_S/(bfl*1.15*CLmax_climb1);
P_W.bfl = 1.2.*sqrt(W_S/(0.5*rho*CLmax_climb1/1.1^2)) / eta_p .* T_W.bfl;

% Cruise
T_W.cruise = w_frac_at.cruise/t_frac_at.cruise * (0.5*rho_cruise*V_cruise^2*C_D0./(w_frac_at.cruise*W_S)...
    + w_frac_at.cruise*W_S/(0.5*rho_cruise*V_cruise^2*pi*AR*e));
P_W.cruise = V_cruise / eta_p .* T_W.cruise;

% Diversion
T_W.diversion = w_frac_at.diversion/t_frac_at.diversion * (0.5*rho_diversion*V_diversion^2*C_D0./(w_frac_at.diversion*W_S)...
    + w_frac_at.diversion*W_S/(0.5*rho_diversion*V_diversion^2*pi*AR*e));
P_W.diversion = V_diversion / eta_p .* T_W.diversion;

% Loiter


% Landing
W_S_landing = 1/w_frac_at.landing * (0.6*LDA-S_a) * CLmax_climb3 / 0.51;

% Service Ceiling
T_W.ServCeil = w_frac_at.cruise/t_frac_at.cruise * (1/V_ServCeil * climb_rate_service_ceiling + ...
    0.5*rho_ServCeil*V_ServCeil^2*C_D0./(w_frac_at.cruise*W_S)...
    + w_frac_at.cruise*W_S/(0.5*rho_ServCeil*V_ServCeil^2*pi*AR*e));
P_W.ServCeil = V_ServCeil / eta_p .* T_W.ServCeil;

% Climb 1 - OEI, gear up, TO flaps, MTOW, 1.2 V_Stall
T_W.Climb1 = 2 * (1./(1.2*sqrt(W_S/(0.5*rho*CLmax_climb1))) * ...
    1.2.*sqrt(W_S/(0.5*rho*CLmax_climb1)) * sin(atan(0.012)) + ...
    0.5*rho*(1.2*sqrt(W_S/(0.5*rho*CLmax_climb1))).^2*CD_climb1./W_S...
    + W_S/(0.5*rho*(1.2*sqrt(W_S/(0.5*rho*CLmax_climb1))).^2*pi*AR*e_climb1));
P_W.Climb1 = 1.2.*sqrt(W_S/(0.5*rho*CLmax_climb1)) / eta_p .* T_W.Climb1;

% Climb 2 - OEI, gear up, flaps up, 1.25 V_Stall
T_W.Climb2 = 2 * (1./(1.25*sqrt(W_S/(0.5*rho*CLmax_climb2))) * ...
    1.25.*sqrt(W_S/(0.5*rho*CLmax_climb1)) * sin(atan(0.012))+ ...
    0.5*rho*(1.25*sqrt(W_S/(0.5*rho*CLmax_climb2))).^2*CD_climb2./W_S...
    + W_S/(0.5*rho*(1.25*sqrt(W_S/(0.5*rho*CLmax_climb2))).^2*pi*AR*e_climb2));
P_W.Climb2 = 1.25.*sqrt(W_S/(0.5*rho*CLmax_climb2)) / eta_p .* T_W.Climb2;

% Climb 3 - AEO, go-around, gear down, landing flaps, max landing weight, 1.3
% V_Stall
T_W.Climb3 = w_frac_at.landing * (1./(1.3*sqrt(W_S/(0.5*rho*CLmax_climb3))) * ...
    1.3.*sqrt(W_S/(0.5*rho*CLmax_climb1)) * sin(atan(0.032))+ ...
    0.5*rho*(1.3*sqrt(W_S/(0.5*rho*CLmax_climb3))).^2*CD_climb3./(w_frac_at.landing*W_S)...
    + w_frac_at.landing*W_S/(0.5*rho*(1.3*sqrt(W_S/(0.5*rho*CLmax_climb3))).^2*pi*AR*e_climb3));
P_W.Climb3 = 1.3.*sqrt(W_S/(0.5*rho*CLmax_climb3)) / eta_p .* T_W.Climb3;

% Climb 4 - OEI, gear down, approach flaps, 1.5 V_Stall
T_W.Climb4 = 2 * w_frac_at.landing*(1./(1.5*sqrt(W_S/(0.5*rho*CLmax_climb4))) * ...
    1.5.*sqrt(W_S/(0.5*rho*CLmax_climb1)) * sin(atan(0.021))+ ...
    0.5*rho*(1.5*sqrt(W_S/(0.5*rho*CLmax_climb4))).^2*CD_climb4./(w_frac_at.landing*W_S)...
    + w_frac_at.landing*W_S/(0.5*rho*(1.5*sqrt(W_S/(0.5*rho*CLmax_climb4))).^2*pi*AR*e_climb4));
P_W.Climb4 = 1.5.*sqrt(W_S/(0.5*rho*CLmax_climb4)) / eta_p .* T_W.Climb4;

%% Plot Configuration
figure()
plot(W_S,T_W.cruise,'DisplayName','Cruise')
hold on
plot(W_S,T_W.diversion,'DisplayName','Diversion')
plot(W_S,T_W.ServCeil,'DisplayName','Service Ceiling')
plot(W_S, T_W.Climb1,'DisplayName','Climb 1')
plot(W_S, T_W.Climb2,'DisplayName','Climb 2')
plot(W_S, T_W.Climb3,'DisplayName','Climb 3')
plot(W_S, T_W.Climb4,'DisplayName','Climb 4')
plot(W_S,T_W.bfl,'DisplayName','Take-off')
plot([W_S_landing, W_S_landing],[0, 10],'DisplayName','Landing')
hold off
ylim([0,0.7])
xlim([0,6000])
title('Thrust-to-Weight Constraint Map')
xlabel('Wing Loading, W/S_{ref} (N/m^2)')
ylabel('Thrust to Weight, T/W (N/N)')
legend

figure()
plot(W_S,P_W.cruise,'DisplayName','Cruise')
hold on
plot(W_S,P_W.diversion,'DisplayName','Diversion')
plot(W_S,P_W.ServCeil,'DisplayName','Service Ceiling')
plot(W_S, P_W.Climb1,'DisplayName','Climb 1')
plot(W_S, P_W.Climb2,'DisplayName','Climb 2')
plot(W_S, P_W.Climb3,'DisplayName','Climb 3')
plot(W_S, P_W.Climb4,'DisplayName','Climb 4')
plot(W_S,P_W.bfl,'DisplayName','Take-off')
plot([W_S_landing, W_S_landing],[0, 150],'DisplayName','Landing')
hold off
ylim([0,80])
xlim([0,6000])
title('Power-to-Weight Constraint Map')
xlabel('Wing Loading, W/S_{ref} (N/m^2)')
ylabel('Power to Weight, P/W (W/N)')
legend
