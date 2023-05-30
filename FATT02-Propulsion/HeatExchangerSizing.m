%Script to calculate approximate mass of heat exchanger between turbine and
%catalytic converter, maybe add some heat equations in here as well in the
%future

clear
clc
close all

rhoCopper = 8960; %kg/m^3
thickness = 0.1; %Thickness of the part that wraps outside the turbine blade
innerDiaTurb = 0.86;
outerDiaTurb = 0.9;
weightCopperTurb = pi*((outerDiaTurb/2)^2 - (innerDiaTurb/2)^2)*thickness*rhoCopper;
contactAreaTurb = pi*innerDiaTurb*thickness; %in m^2

lengthConnector = 0.15;
weightConnector = lengthConnector*0.15*0.1*rhoCopper;
contactAreaConnector = 0.15*0.1; %in m^2


innerDiaCat = 0.48; %Inner and outer diameter of the copper part that wraps around the catalytic converter
outerDiaCat = innerDiaCat + 0.02;
thicknessCat = 0.5;
weightCopperCat = pi*((outerDiaCat/2)^2 - (innerDiaCat/2)^2)*thicknessCat*rhoCopper;
contactAreaTurbCat = pi*innerDiaCat*thicknessCat; %m^2
weightTotal = weightCopperTurb + weightConnector + weightCopperCat



