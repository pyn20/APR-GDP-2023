clear 
clc

%% STATIC AEROELASTICITY CODE - FLEXIBLE WING
% this will be integrated into the longitudinal static stability code

%% Defining ALL Required Variables

% Aerodynamic Variables
n = 1; % Load factor
cl = 1; % Sectional lift coefficient 
cm_ac = 1; % Sectional pitching moment coefficient 
a = 1; % 2D lift curve slope
alpha = 1; % Angle of attack
alpha_r = 1; % Rigid surface rotation
alpha_r_bar = 1; 
twist = 1; 
L_sect = 1; % Sectional lift 
M_sect = 1; % Sectional pitching moment
rho = 1; % Density 
U = 1; % Velocity
q = 1; % Dynamic pressure
c = 1; % Chord

% Structural Variables
theta = 1; % Elastic torsional rotation
G = 1; % Shear modulus
J = 1; % Torsion constant
mg = 1; % Sectional weight of wing
lambda = 1; % Helpful constant
W = 1; % Vehicle weight

% Geometric Variables
x_wing_cg = 1; % Wing centre of gravity
x_wing_ac = % Wing aerodynamic centre

% i am confused about the coordinate system here
e = 1; 
d = 1; 
y = 1; % Span-wise distance 
l = 1; Span
%% Calculation

q = 0.5 * rho * U^2;
lambda = sqrt( (q * c * a * e )/ (G * J) );


% Step 1: Find rigid angle of attack 
alpha_r = (N * W * l * e) / ( 2 * G * J * lambda * l * tan(lambda * l)) + (1 - (lambda * l)/ tan(lambda * l) ) * ...
    ( (N * mg * l^2 * d) /(G*J*(lambda * l)^2) - (c * cm_ac) / (a * e));

alpha_r_bar = (c * cm_ac) / (a * e) - (N * mg * d) / (q * c * a * e);

% Step 2: Find elastic torsional rotation

theta = (alpha_r + alpha_r_bar) * (tan(lambda * l) * sin(lambda * y) + cos(lambda * y) - 1);

% Step 3: Angle of attack 
alpha = alpha_r + theta;

