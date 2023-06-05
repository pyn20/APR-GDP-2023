%housekeeping
clear
clc
clf

%thermal model for catalytic converter heatsink

%create thermal analysis model

%thermalmodel = createpde("thermal","transient");

%%%generating own geometry

newmodel = createpde("thermal","transient");

 %define circle in rectangle
C1 = [0.455,-0.455,-0.455,0.455]';
C2 = [0.45,-0.45,-0.45,0.45]';
gm = [C1,C2];
sf = 'C1-C2';

ns = char('C1','C2');
ns = ns';
g = decsg(gm,sf,ns);

geometryFromEdges(newmodel,g);
pdegplot(newmodel,"VertexLabels","on","EdgeLabels","on")
xlim([-1,1])
ylim([-1,1])
axis equal

%%%end of own geometry

%specify thermal properties of material

% thermalProperties(newmodel,"ThermalConductivity",1,"MassDensity",1,"SpecificHeat",1);
% 
% %apply boundary conditions
% 
% 
% thermalBC(newmodel,"Edge",5,"Temperature",100);
% thermalBC(newmodel,"Edge",6,"Temperature",100);
% thermalBC(newmodel,"Edge",7,"Temperature",100);
% thermalBC(newmodel,"Edge",8,"Temperature",100);
% thermalBC(newmodel,"Edge",3,"HeatFlux",-10);
% 
% %set initial conditions
% 
% %thermalIC(thermalmodel,0);
% thermalIC(newmodel,0);
% 
% %generate mesh
% 
% %generateMesh(thermalmodel);
% %figure
% %pdemesh(thermalmodel)
% %title("Mesh with Quadratic Triangular Elements")
% 
% generateMesh(newmodel);
% figure
% pdemesh(newmodel)
% title("Mesh with Quadratic Triangular Elements")
% 
% %specify solution times
% 
% tlist = 0:0.5:5;
% 
% %calculate solution
% 
% %thermalresults = solve(thermalmodel,tlist);
% thermalresults = solve(newmodel,tlist);
% 
% %evaluate heat flux
% 
% [qx,qy] = evaluateHeatFlux(thermalresults);
% 
% %plot temperature distribution and heat flux
% 
% %pdeplot(thermalmodel,"XYData",thermalresults.Temperature(:,end),"Contour","on","FlowData",[qx(:,end),qy(:,end)],"ColorMap","hot");
% pdeplot(newmodel,"XYData",thermalresults.Temperature(:,end),"Contour","on","FlowData",[qx(:,end),qy(:,end)],"ColorMap","hot");
% 
