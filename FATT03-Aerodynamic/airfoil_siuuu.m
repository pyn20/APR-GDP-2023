clear
clc
close all

load('airfoilDB.mat');

%% Define alpha & beta

alpha=1;
beta=10;

%% Field Type

comparedFields = {'clDes','clcdDes','clMax','liftCurve','cm0'};

%% Iterate through all airfoils and Re to find max & min

for fieldNo = 1:length(comparedFields)
    for reNo = 1:length(airfoilDB(1).reDB)
        maxValues(reNo).(comparedFields{fieldNo}) = -inf;
        minValues(reNo).(comparedFields{fieldNo}) = inf;
        for airfoilNo = 1:length(airfoilDB)
            if airfoilDB(airfoilNo).reDB(reNo).(comparedFields{fieldNo}) > maxValues(reNo).(comparedFields{fieldNo})
                maxValues(reNo).(comparedFields{fieldNo}) = airfoilDB(airfoilNo).reDB(reNo).(comparedFields{fieldNo});
                indexMax = [airfoilNo, reNo];
            end
            
            if airfoilDB(airfoilNo).reDB(reNo).(comparedFields{fieldNo}) < minValues(reNo).(comparedFields{fieldNo})
                minValues(reNo).(comparedFields{fieldNo}) = airfoilDB(airfoilNo).reDB(reNo).(comparedFields{fieldNo});
                indexMin = [airfoilNo, reNo];
            end
        end
    end
end

%% Find min, max and Calculate R for all

for fieldNo = 1:length(comparedFields)
    A = min([minValues.(comparedFields{fieldNo})]);
    B = max([maxValues.(comparedFields{fieldNo})]);
    for airfoilNo = 1:length(airfoilDB)
        for reNo = 1:length(airfoilDB(1).reDB)
            x = airfoilDB(airfoilNo).reDB(reNo).(comparedFields{fieldNo});
            if isempty(x)
                R(airfoilNo,reNo) = NaN;
            else
                R(airfoilNo,reNo) = (beta*(x-A)-alpha*(x-B))/(B-A);
            end
        end
    end
    Compare(fieldNo).Field = (comparedFields{fieldNo});
    Compare(fieldNo).Value = B;
    Compare(fieldNo).R = R;
    Compare(fieldNo).highest_MI_index = find(R(:,1)==max(R));
    Compare(fieldNo).highest_MI_Airfoil = airfoilDB(find(R(:,1)==max(R))).naca;
end

%% Cl design 

WingLoading = 3675;
[T, a, P, rho] = atmosisa(25000);
rho0 = 1.225;
M = 0.45; % Defined by Config
V_cruise = a * M;
cl_design = WingLoading/(.5*rho0*V_cruise^2)

% Round up to cl_design = 0.4
cl_design_rounded = ceil(cl_design*10)/10
