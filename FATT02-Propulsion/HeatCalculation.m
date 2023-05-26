
% Heat calculation of Ru-catalyst with support of CNTs-MgO

% P_l: power loss to environment , this will be a function of altitude
%Temp chaneg from -33 to 25
T_1 = 274.15-33;  % in K
T_2 = 274.15+25;  % in K

sigma = 5.67*10^(-8); % W/m^2K^4
A_l = 0.2825/5;  % flow rate/velocity, assume velocity 5m/s
r_l = sqrt(A_l/pi);
SurfaceA_l = 2*pi*r_l*10;  % surface area by assumming 10m long

e_steel = 0.56; % steel sheet rolled

P_l = e_steel*sigma*SurfaceA_l*(T_2^4-T_1^4)


% P_e: power of heat loss to endothermic reaction, constant
E_per_mol = 92.21536*10^3/2;  %J/mol
flow_one_engine = 0.2062/(17/1000); %in mol/s
E_per_s = E_per_mol*flow_one_engine;
P_e = E_per_s


% P_a: power required to heat NH3 to 400C, function of altitude
A = 0.2825/5;  % flow rate/velocity, assume velocity 5m/s
r = sqrt(A/pi);
SurfaceA = 2*pi*r*2;  % surface area by assumming 2m long
e_Ti = 0.63; % Ti fullly sized

P_a = e_Ti*sigma*SurfaceA*(T_2^4-T_1^4)



P_c = P_l + P_e + P_a





