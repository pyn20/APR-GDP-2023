clear
clc
close all

%% Parameters
AR = param.AR;  % wing aspect ratio
AR_h = param.ht.AR;  % horizontal tailplane aspect ratio
AR_v = param.vt.AR;    % vertical tailplane aspect ratio
A_fc = param.fuse.A_cargo*10.764;    % cargo hold floor area
B_h = convlength(param.ht.b,'m','ft');    % horizontal taiplane span
B_w = convlength(param.wing.b,'m','ft');     % wing span
D = convlength(param.fuse.w_f,'m','ft');      % max fuselage diameter
F_w = D/2;     % fuselage width at horizontal tail intersection
H_t_H_v = 0;    % 0 for fuselage mounted ht
K_buf = 1.02;   % 1.02 for short ranges
K_door = 1.06; % one side cargo door
K_lav = 0.31;   % 0.31 for short range
K_Lg = 1;   % 1.12 for fuselage mounted landing gear, 1 otherwise
K_mp = 1;  % 1.126 for kneeling main gear; 1.0 otherwise
K_ng = 1.017; % 1.017 for pylon mounted nacelle; 1.0 otherwise
K_np = 1;    % 1.15 for kneeling nose-gear; 1.0 otherwise
K_r = 1;     % 1.133 for reciprocating engines; 1.0 otherwise
K_tp = 1;   % 1 for turbofan
K_uht = 1;  % 1 for not all=moving tail
L = convlength(param.fuse.l_structural,'m','ft');  % aircraft structural length
L_a = convlength(param.fuse.l_fuselage,'m','ft');    % Electrical routing distance; generators to avionics to cockpit (ft)
L_ec = convlength(param.fuse.l_fuselage,'m','ft');    % Engine controls routing distance; engine to cockpit- total if multiengine (ft)
L_f = convlength(param.fuse.l_fuselage,'m','ft');     % total fuselage length
L_ht = convlength(param.wing.l_h,'m','ft');    % Length from wing aerodynamic centre to horizontal tailplane aerodynamic centre (ft)
L_m = convlength(param.uc.L_m,'m','in');     % Main landing gear length (inches)
L_n = convlength(param.uc.L_n,'m','in');   % Nose landing gear length 
L_vt = convlength(param.wing.L_vt,'m','ft');    % Length from wing aerodynamic centre to vertical tailplane aerodynamic centre (ft)
L_over_D = L/D;
N_c = 5;     % number of crew
N_en = 2;    % number of engines
N_f = 6;     % Number of functions performed by controls; typically 4 − 7
N_gear = param.uc.N_gear;    % The ratio of the average total load applied to the main gear during landing to the max landing weight; typically 2.7−3 for commercial aircraft  
N_gen = 3;      % number of generators = N_en
N_l = 1.5*N_gear;   % ultimate landing gear load factor
N_Lt = convlength(param.engine.N_Lt,'m','ft');        % nacelle length
N_m = 0;         % Number of mechanical function performed by controls; typically 0 −2
N_mss = param.uc.N_mss;       % Number of main gear shock struts
N_mw = param.uc.N_mw;        % Number of main wheels
N_nw = param.uc.N_nw;        % Number of nose wheels
N_p = 95;         % total number of persons on board
N_seat = 90;        % number of seats 
N_t = param.sys.N_t;         % total number of fuel tanks
N_z = 2.1*1.5; % ulimate load factor, 1.5x limit load factor
N_w = convlength(param.engine.N_mD,'m','ft');     % nacelle width
R_kva = 45;   % system electrical rating, typically 40-60 for transports (KVA)
S_cs = param.cs.S_cs*10.764;    % total control surface area
S_csw = param.cs.S_csw*10.764;   % area of wing mounted control surfaces
S_e = param.cs.S_e*10.764; % elevator area
S_f = param.fuse.S_wet*10.764+900;     % fuselage wetted area
S_ht = param.ht.S_h*10.764;    % horizontal tailplane area
S_n = param.engine.S_n*10.764;     % nacelle wetted area
S_w = param.wing.S*10.764; % reference wing area
S_vt = param.vt.S_v*10.764;    % vertical tailplane area
tc_root = param.wing.t_c_root; % wing root thickness to chord ratio    
tc_rootv = param.vt.tc_root_v;   % Vertical tailplane root thickness to chord ratio
V_i = param.sys.V_i*264.2;     % integral fuel tank volume (gal)
V_p = param.sys.V_p;     % sealf sealing tank volume (gal)
V_t = 220*param.sys.V_t;    % total fuel tank vol gal
V_pr = param.fuse.W_pr*220;    % volume of pressurized sections
V_s = 149.601;     % landing stall speed in mph
W_APU = param.sys.W_APU;   % uninstalled APU weight
W_c = param.sys.W_c*2.205;     % max cargo weight
W_dg = convmass(param.sys.W_dg,'kg','lbm');    % design gross weight
W_en = convmass(param.engine.w,'kg','lbm');    % engine weight
W_enc = 2.231*(W_en^0.901);     % weight of engine contents
% W_l = param.sys.W_l;     % landing design gross weight
W_l = convmass(38001.56757,'kg','lbm');
W_seat = 32.6;      % weight of sigle seat
W_uav = param.sys.W_uav;       % uninstalled avionics, typically 800-1400 lb
lambda = param.wing.lambda_w;  % wing taper ratio
cap_lambda = param.wing.cap_lambda;  % wing quarter chord sweep
cap_lambda_ht = rad2deg(param.ht.cap_lambda_ht);   % Horizontal tailplane quarter chord sweep
cap_lambda_vt = rad2deg(param.vt.cap_lambda_vt);   % Vertical tailplane quarter chord sweep

K_ws = 0.75*((1+2*lambda)/(1+lambda)) * B_w * tand(cap_lambda)/L;    % 0.75[(1 + 2λ)/(1 + λ)]Bw tan (Λ)/L
K_y = 0.3*L_ht;          % Aircraft pitching radius of gyration; ≈ 0.3Lht (ft)
K_z = L_vt;              % Aircraft yaw radius of gyration; ≈ Lvt (ft)
W0 = param.W0/9.81;
W0 = convmass(W0,'kg',"lbm");
I_y = W0*K_y^2; % Pitching moment of inertia; ≈ W0Ky^2 (lb ft2)

%% Weight equations

% Aircraft wings
test_wing = 0.0051*((((W_dg*N_z)^0.557)*(S_w^0.649)*(AR^0.5)*((1+lambda)^0.1)*(S_csw^0.1)) / ((cosd(cap_lambda))*(tc_root^0.4)));
weights_Raymer.W_w = 0.0051 * (((W_dg*N_z)^0.557) * (S_w^0.649) * (AR^0.5) * ((1+lambda)^0.1) * ((2*S_csw)^0.1) * (cosd(cap_lambda))^(-1) * tc_root^(-0.4));

% Horizontal tailplane
weights_Raymer.W_ht = 0.0379*(K_uht*(W_dg^0.639)*(N_z^0.1)*(S_ht^0.75)*(K_y^0.704)*(AR_h^0.166)*((1+S_e/S_ht)^0.1)) / (((1+F_w/B_h)^0.25)*L_ht*cosd(cap_lambda_ht));

% Vertical tailplane
weights_Raymer.W_vt = 0.0026*(((1+H_t_H_v)^0.225)*(W_dg^0.556)*(N_z^0.536)*(S_vt^0.5)*(K_z^0.875)*(AR_v^0.35)) / ((L_vt^0.5)*cosd(cap_lambda_vt)*(tc_rootv^0.5));

% Fuselage
weights_Raymer.W_fus = 0.328*K_door*K_Lg*((W_dg*N_z)^0.5)*(L^0.25)*(S_f^0.302)*((1+K_ws)^0.04)*(L_over_D^0.1);

% Main landing gear 
weights_Raymer.W_mlg = 0.0106*K_mp*(W_l^0.888)*(N_l^0.25)*(L_m^0.4)*(N_mw^0.321)*(V_s^0.1)/(N_mss^0.5);

% Nose landing gear
weights_Raymer.W_nlg = 0.032*K_np*(W_l^0.646)*(N_l^0.2)*(L_n^0.5)*(N_nw^0.45);

% Nacelle
weights_Raymer.W_inl = 0.6724*K_ng*(N_Lt^0.1)*(N_w^0.294)*(N_z^0.119)*(W_enc^0.611)*(N_en^0.984)*(S_n^0.224);

% Engine controls
weights_Raymer.W_ec = 5*N_en + 0.8*L_ec;

% Engine pneumatic starter
weights_Raymer.W_es = 49.19*((N_en*W_en/1000)^0.541);

% Engine weight
%weights_Raymer.W_en = N_en * W_enc;
weights_Raymer.W_en = N_en * W_en;

% Fuel system
weights_Raymer.W_fs = 2.405*(V_t^0.606)*(N_t^0.5);

% Flight controls
weights_Raymer.W_fc = (145.9*(N_f^0.554)*(S_cs^0.2)*((I_y*(10^(-6)))^0.07))/(1+(N_m/N_f));

% Installed APU 
weights_Raymer.W_APUinst = 2.2*W_APU*1.3;

% Instruments
weights_Raymer.W_instr = 4.509*K_r*K_tp*(N_c^0.541)*N_en*((L_f+B_w)^0.5);

% Hydraulic system
weights_Raymer.W_hydr = 0.2673*N_f*((L_f+B_w)^0.937);

% Electrical system
weights_Raymer.W_el = 7.291*(R_kva^0.782)*(L_a^0.346)*(N_gen^0.1);

% Avionics
weights_Raymer.W_av = 1.73*(W_uav^0.983);

% Furnishings
weights_Raymer.W_furn = 0.0577*(N_c^0.1)*(W_c^0.393)*(S_f^0.75) + N_seat*W_seat + K_lav*(N_p^1.33) + K_buf*(N_p^1.12);

% Air-conditioning
weights_Raymer.W_ac = 62.36*(N_p^0.25)*((V_pr*10^(-3))^0.604)*(W_uav^0.1);

% Anti-icing
weights_Raymer.W_ai = 0.002*W_dg;

% Passengers + crew
weights_Raymer.W_p = 105*90+5*80;


w_total = sum(cell2mat(struct2cell(weights_Raymer)));
labels = fieldnames(weights_Raymer);
pie(cell2mat(struct2cell(weights_Raymer)),labels)
T = struct2table(weights_Raymer);

% save("Weights_Raymer","Weights_Raymer")