clear
clc
close all

% Pipe heat calculation
% convection between pipe and NH3

T_env = 274.15+400; % temp for environment in K
T0 = 274.15-40; % initial temp of object in K

h = 10; % heat transfer coeff in W/(m^2 K)
A = 0.2825/5;  % flow rate/velocity, assume velocity 5m/s
r = sqrt(A/pi);
A = 2*pi*r*2; % heat transfer surface area in m^2
              % surface area by assumming 2m long; 


% Rate of heat transfer out of the body in Watt
Qdot = h*A*(T0 - T_env)


% r = ; % coeff of heat transfer in per sec
% t = ; % time period
% 
% % Temp at time t
% T_t  = T_env + (T0-T_env)*exp(-r*t)