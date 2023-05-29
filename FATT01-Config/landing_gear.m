clear
clc
close all

format long g

load('parameters.mat');

x_cg = 15; % cog location from nose, m 
x_cg_temp = 0 ;
x_ng = 0.65;
x_mg = 18.73;


while x_cg - x_cg_temp > 0.01
    
x_cg = whereiscg(x_ng, x_mg);

% GEAR LOADS, NUMBER OF STRUTS, WHEELS:

W0 = param.aircraft.MTOW*9.81; %MTOW, N %UPDATE WITH FINAL MTOW !! - MIGHT HAVE TO CHANGE TYRES
W0_lbs = (W0/9.81)*2.20462;
n_struts = 3; % total number of struts
b = param.wing.b;
wheels_per_strut = 2; % number of wheels per strut;
l_fuselage = param.fuse.l_fuselage;
c_root_wing = param.wing.c_root;

W_ng_W0 = 0.06; % ideal static load on nose gear fraction, errikos
W_ng = W_ng_W0*W0; % static load on nose gear, N
W_mg_W0 =  1 - W_ng_W0; % static load on main gear fraction
W_mg = W_mg_W0*W0; % static load on main gear, N

% PLACEMENT:


% Fill in:

mg_tire_spacing = 20; %inches, spacing between main gear wheels per gear
engine_clearance = 6/39.37; % m
w_mg_tyre = 11.5; % main gear tyre width, inches
gamma = param.wing.gamma; % dihedral angle, degrees
D_fuselage = param.fuse.w_f; %fuselage diameter, m
L_engine = (0.3*(b/2)*cosd(gamma)) - (D_fuselage/2); % location of engine from wing root, m
D_engine = param.engine.d_max; % engine outer diameter, m
h_wing = param.placement.wing_fuselage;  % vertical distance of wing root from bottom of fuselage, m
theta_v = 19; % vertical cog angle to main gear, degrees

l_mg = 2; %guess, m

% Longitudinal placement and heights
l3 = l_mg - (D_fuselage/2); % location of main gear from wing root, m
l1 = L_engine - l3;
l2 = l3 + ((mg_tire_spacing/39.37)/2) + ((w_mg_tyre/39.37)/2);
l = L_engine - l2;
h_engine = (engine_clearance/cosd(5)) + l*tand(5);
h_mg = h_engine + D_engine - l1*tand(gamma); % total height of mg above ground, m
h_ng = h_mg - h_wing - (l3*tand(gamma)); % total height of ng above ground, m

h_cg = h_ng + (D_fuselage/2); % cog height from ground, m

x_mg = x_cg + h_cg*tand(theta_v); % main gear location from nose, m
% x_mg = (l_fuselage/2) + (c_root_wing/2);

% theta_v = atand(x_mg - x_cg)/(h_cg);
x_ng = (x_cg -  (W_mg_W0*x_mg))/(W_ng_W0); % nose gear location from nose, m

uc.mg.long = x_mg;
uc.ng.long = x_ng;
uc.mg.height = h_mg;
uc.ng.height = h_ng;


% Lateral placement - main gear
% theta_ot = 60; % overturn angle, degrees
% l_mg = (h_cg/tand(theta_ot))*((x_mg - x_ng)/(x_mg - x_ng - h_cg*tand(theta_v))); % lateral position of main gear from centreline, m
% % uncomment if l_mg is guessed and is checked for overturn < 63 degrees:

theta_ot = atand((h_cg/l_mg)*((x_mg - x_ng)/(x_mg - x_ng - h_cg*tand(theta_v)))); % degrees

uc.mg.tyre_spacing = mg_tire_spacing;
uc.mg_lateral = l_mg;



B = (x_mg - x_ng)*3.281;
H = h_cg*3.281; % cog height above static ground line, ft

% TIRE SELECTION:

% main gear
W_w_mg_lbs = (((W_mg/2)*1.07)/wheels_per_strut)*(2.20462/9.81); % main gear tire load, lbs

mg_tire_outside_diameter = 29.75; % inches
mg_tire_inflation_pressure = 243; % psi
R_r_mg = 12.5; % rolling radius, inches

uc.mg.tyre_diameter = mg_tire_outside_diameter;
uc.mg.tyre_width = w_mg_tyre;

%nose gear
W_w_ng_lbs = ((W_ng*1.07)/wheels_per_strut)*(2.20462/9.81); % nose gear tire load, lbs
W_dynamic_ng = (10*H*W0)/(9.81*3.28084*B); % dynamic load on ng in N, all lengths in ft
W_dynamic_ng_lbs = W_dynamic_ng*(2.20462/9.81); 
W_w_ng_total = W_w_ng_lbs + W_dynamic_ng_lbs; % total static load on ng, lbs

ng_tire_outside_diameter = 22; % inches
ng_tire_inflation_pressure = 210; % psi
ng_tire_width = 8.5; % inches

uc.ng.tyre_diameter = ng_tire_outside_diameter;
uc.ng.tyre_width = ng_tire_width;


% SHOCK ABSORBER DESIGN:

V_v = 10 ;% touchdown sink speed, ft/s
eta = 0.85; % oleo shock efficiency
eta_t =  0.47; % tire efficiency
N_g = 2.7; % gear load factor

% main gear
S_t_mg = ((mg_tire_outside_diameter/12)/2) - (R_r_mg/12); % tire stroke, ft
S_mg = (V_v^2/(2*(9.81*3.28084)*eta*N_g)) - ((eta_t/eta)*S_t_mg) + (1/12); % Stroke in ft (1 inch safety factor)
L_oleo_mg = (W_mg/2)*(2.20462/9.81); % oleo load, lbs
D_oleo_mg = 0.04*sqrt(L_oleo_mg); % oleo diameter, inches

% nose gear
S_ng = S_mg; % errikos
L_oleo_ng = (W_ng + W_dynamic_ng)*(2.20462/9.81); % oleo load, lbs
D_oleo_ng = 0.04*sqrt(L_oleo_ng); % oleo diameter, inches

oleo_length = 2.5*S_mg; % same for mg and ng

x_cg_temp = whereiscg(x_ng , x_mg);


end

Z_t = h_cg - (h_engine + (D_engine/2));

uc.Z_t = Z_t;
uc.engine_lateral = L_engine + (D_fuselage/2);

save('uc.mat','uc')


