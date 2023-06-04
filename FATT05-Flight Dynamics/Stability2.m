clear 
clc

%% Longitudinal Static Stability 
% the pitching moment needs to be negative

x_cg = 17; % Aircraft centre of gravity

%% Wing Variables

c_bar = 4;  % Mean chord
a_w = 6;  % Lift curve slope of wing
x_ac =  18;  % aerodynamic centre of wing
S_w = 80; % Wing area
AR = 9.5;   % Aspect ratio
TR = 0.35;  % Taper ratio
sweep = 0; % Sweep (degrees)
b = 27.27;   % Span
alpha_0 = 2 * pi/180 ;
alpha_w = 3 * pi/180;
CL_Cruise = 1.5;   % CL at cruise Mach
CL_Zero = 1.5;  % CL at zero Mach
CL_Max = 2;
twist =3 ; % Twist (degrees)
i_w = 3 * pi/180 ;

%% Fuselage Variables
k_fus = 1; % Empirically defined factor using graph from slides
L_fus = 30; % Fuselage length
W_fus = 4; % Maximum fuselage width

%% Powerplant Variables
num_props = 2;
x_props = 13;
S_props = 4; 
dCN_da_p = 0.003; % Empirical - fix

%% Tailplane Variables
eta_h = 1.0 ; % Tailplane efficiency factor - empirical values, can be calculated using qh/qinf
a_h = 5; % Lift curve slope of tailplane
S_h =  25; % Tailplane horizontal area 
x_ac_h  = 27; % aerodynamic centre tail
V_bar =  S_h/S_w * (x_ac_h - x_cg)/c_bar ;

% Downwash - empirically defined
KA = 1/AR - 1/(1+AR^(1.7));
KTR = (10-3*TR)/7;
L_ht = 12 ; % horizontal distance between aero centres of wing and tail
L_vt = 4;  % vertical distance between aero centres of wing and tail
KH = (1 - abs(L_vt/b)) / (2*L_ht/b)^(3/2);
deda = 4.44 * (KA * KTR * KH * sqrt(cosd(sweep)))^1.19 * CL_Cruise/CL_Zero;

% method 2 for calculating downwash - NACA TR-738
epsilon = 114.6 * CL_Max / (pi * AR)  * pi/180 ;
deda2 = 114.6 * a_w / (pi * AR) * pi/180  ;

%% Stability Calculation about CG

% Contributions from each component:
dCmdCL_wing = (x_ac -x_cg)/c_bar ;
dCmdCL_tail = eta_h * a_h/a_w  * (1 - deda) * V_bar;
dCmdCL_props_direct = num_props * (x_props - x_cg)/ c_bar * S_props/S_w * (1 + deda) * dCN_da_p ;
dCmdCL_props_downwash = a_h/a_w * V_bar * eta_h / 0.07 * dCN_da_p * (1 + deda) ;
dCmdCL_props = dCmdCL_props_downwash + dCmdCL_props_direct ;
dCmdCL_fuselage = k_fus * L_fus * W_fus^2 / (c_bar * S_w) ; 

% Summing each contribution

dCmdCL = -dCmdCL_wing + dCmdCL_fuselage - dCmdCL_props - dCmdCL_tail;

% Neutral Point Calculation
x_np = (x_ac - x_cg) - dCmdCL_fuselage + dCmdCL_tail - dCmdCL_props;

SM_poweroff = (x_np  )  / c_bar ;

% Apply a 'sensible' margin to account for power on effects

SM_poweron = SM_poweroff - 0.07
 
% Overall Static Stability
dCMda_poweroff = - a_w * SM_poweroff
dCMda_poweron = - a_w * SM_poweron ;
%% Trim
Cm_ac = 0.05;
i_h = -2 * pi/180 ;

%% ELEVATOR POWER 
% Method presented is based on the PERKINS textbook

de_max = -30 * pi/180;
CL_Max = 1.25;
tau = 0.5; % Empirical relation from PERKINS (p250, Figure-33) (dat_dde)
Cm_d = a_h * V_bar * eta_h *  tau; % Elevator power criterion 

%% Elevator Angle for Equilbrium

CL_eq = linspace(0,CL_Max,10); % Change to a vector for the plot
de_0 = - Cm_ac / Cm_d - (alpha_0 - i_w + i_h) / tau ;
de_equilibrium = de_0 -  CL_eq .* dCmdCL / Cm_d ;

figure()
plot(CL_eq, de_equilibrium .*180/pi)
hold on
yline(de_0 * 180/pi)
hold on
xline(CL_Max)
hold on 
yline(de_max * 180/pi)
xlabel('Lift Coefficient')
ylabel('')
hold off

%% Most Forward CG for Free Flight
% The CG that for which maximum up elevator will just balance out the
% maximum lift coefficient 

dCm_dCL_max = (de_0 - de_max) * Cm_d / CL_Max;

%%  Elevator Required for Landing
alpha_landing = 3 * pi/180; % i don't know this oneo

Cm_ac_landing = 0.05 ; % Flaps deflected for landing
Cm_props = dCmdCL_props * CL_Max;
Cm_fuselage= dCmdCL_fuselage * alpha_landing;

k = 1.05; % Empirical constant from NACA WR L-95
epsilon_groundeffect = epsilon * 0.5 ; % *0.5 is initial approx,  more detail is possible from NACA TR 738
dalpha_groundeffect = CL_Max / a_w * ( 1/k - 1 );
delta_de_groundeffect = epsilon_groundeffect / tau;
de_flare = de_max - 5 * pi/180 + delta_de_groundeffect ; % 5 deg elevator margin is advised to flare the airplane during landing approach

de_landing = 180/pi * ( CL_Max * (x_ac - x_cg)/c_bar + Cm_ac + Cm_fuselage + Cm_props - a_h * (alpha_w - alpha_0 - epsilon_groundeffect - i_w + i_h ) * V_bar * eta_h ) / (a_h * V_bar * eta_h * tau);

% Compare x_cg_forward to see the difference in methods
x_cg_forward_landing1  = x_ac - Cm_d / CL_Max * ( de_flare + ((alpha_w + dalpha_groundeffect) - epsilon_groundeffect - i_w + i_h)/tau + (Cm_ac_landing + Cm_fuselage + Cm_props) / Cm_d );


delta_x_cg_forward_landing = delta_de_groundeffect * Cm_d / CL_Max; % sum this to the forward cg

delta_de_groundeffect2 = 180/pi * delta_de_groundeffect; % convert to degrees

%% Trim
%CL_trim = linspace(0,1.5,10);
alpha_trim = linspace(-3,8,10) * pi/180 ;
i_h_trim = linspace(-3,6,10) * pi/180 ;
de_cruise = 2 * pi/180 ;
Vel_cruise = 100;  
rho_cruise = 0.55;
total_mass = 30000;
q = 0.5 * rho_cruise * Vel_cruise^2;
CL_design = total_mass * 9.81 / (q * S_w) ;

figure()
% Plot Cm_cg against CL
for j = 1:length(i_h_trim)

%     Cm_fuselage_trim = dCmdCL_fuselage .* alpha_trim;
%     Cm_cg_trim = Cm_ac + a_w .* (alpha_trim + i_w - alpha_0) .* (x_ac - x_cg) ./ c_bar + Cm_fuselage_trim - a_h .* (alpha_trim - alpha_0 - epsilon - i_w + i_h_trim(j) + tau * de_cruise) .* V_bar .* eta_h;

         CLw_trim = a_w .* (alpha_trim + i_w - alpha_0); 
         CLh_trim = a_h  .* ( (alpha_trim + i_w - alpha_0) .* (1 - deda) + (i_h_trim(j) - i_w)  + alpha_0 )+ tau * de_cruise ;
         CL_trim  = CLw_trim + eta_h * S_h/S_w * CLh_trim;
         
         Cm_cg_trim = - CLw_trim * (x_ac - x_cg )/c_bar  + Cm_ac + dCmdCL_fuselage .* alpha_trim - eta_h * CLh_trim * V_bar;

    plot(CL_trim,Cm_cg_trim,'r','LineWidth',2)
    hold on
end
%     plot([0, Cl_des],[0, 0.00-0.005],'k--','LineWidth',2)
%     hold on
%     plot([Cl_des, Cl_des],[-0.5, 0.00-0.005],'k--','LineWidth',2)

 
xlabel('Lift Coefficient CL')
ylabel('Pitching Moment')

set(gca,'FontSize',14)
%% Hinge Moment Parameter Estimation
