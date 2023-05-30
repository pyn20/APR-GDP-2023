close all
clc
clear

% Input variables: temperature T [K] and molecular mass M [g]
% velocity limits:  probability(v1 < v < v2)
[v_P, v_avg, v_rms, KE_avg,prob12] = Boltzmann(300,8,1000,2000)


function [v_P, v_avg, v_rms, KE_avg,prob12] = Boltzmann(T,M,v1,v2)


% Setup and Calculations
R = 8.3145;     % Universal Gas constant
k = 1.38e-23;   % Boltzmann constant
vMin = 0;       % velocity range [m/s]
vMax = 3000;
nV = 1001;
v = linspace(vMin,vMax,nV);
indexv1 = find(v>v1,1);
indexv2 = find(v>v2,1);
indexv = indexv1:indexv2;

if mod(length(indexv),2) == 0; 
    indexv = indexv1:indexv2+1; 
end
M = M*1e-3;     % molecular mass [kg]

% Maxwell-Boltzmann probability density funtion
%fun = @(x) exp(-x.^2).*log(x).^2;

fn = @(v) (M/T)^(1.5) .*v.^2 .* exp(-(M.*v.^2) ./ (2*R*T));
N = integral(fn,vMin,vMax);   % normalization function 
fn1 = (M/T)^(1.5) .*v.^2 .* exp(-(M.*v.^2) ./ (2*R*T));
pD = fn1./N;                    % probability density

% Velocities and average translational kinetic energy
v_P = sqrt(2*R*T/M);           index1 = find(v>=v_P,1);
v_avg = sqrt(8*R*T/(pi*M));    index2 = find(v>=v_avg,1);
v_rms = sqrt(3*R*T/M);         index3 = find(v>=v_rms,1);
KE_avg = 1.5*k*T;

pD1 = @(v) ((M/T)^(1.5) .*v.^2 .* exp(-(M.*v.^2) ./ (2*R*T)))./N;
prob12 = integral(pD1,v1,v2);



% % Graphics and output variables
figure(1)
Ylim = 4e-3;
xP = v(indexv1:indexv2); yP = pD(indexv1:indexv2);
Harea = area(xP, yP);
set(Harea,'FaceColor',[0.9 0.9 1],'EdgeColor',[0.9 0.9 1])
hold on
xP = v; yP = pD;
plot(xP,yP,'b','linewidth',2)
xlabel('velocity  v  [ m.s^{-1} ]')
ylabel('Prob. Density  p_D  [ s.m{-1} ]')
xP = [v_P v_P]; yP = [0 pD(index1)];
plot(xP,yP,'r','linewidth',2)
xP = [v_avg v_avg]; yP = [0 pD(index2)];
plot(xP,yP,'m','linewidth',2)
xP = [v_rms v_rms]; yP = [0 pD(index3)];
plot(xP,yP,'k','linewidth',2)
grid on
set(gca,'fontsize',12)
ylim([0 Ylim])
%legend('p_D','v_P','v_{avg}','v_{rms}')
tm1 = 'T  =  '; tm2 = num2str(T,'%4.0f '); tm3 = '  K';
tm = [tm1 tm2 tm3];
Htext = text(100,0.95*Ylim,tm);
set(Htext,'fontsize',14,'color','b')
tm1 = 'M  =  '; tm2 = num2str(M*1000,'%4.0f '); tm3 = '  g';
tm = [tm1 tm2 tm3];
Htext = text(1300,0.95*Ylim,tm);
set(Htext,'fontsize',14,'color','b')
tm1 = 'v_P  =  '; tm2 = num2str(v_P,'%4.0f '); tm3 = '  m.s^{-1}';
tm = [tm1 tm2 tm3];
Htext = text(100,0.84 *Ylim,tm);
set(Htext,'fontsize',14,'color','r')
tm1 = 'v_{avg}  =  '; tm2 = num2str(v_avg,'%4.0f '); tm3 = '  m.s^{-1}';
tm = [tm1 tm2 tm3];
Htext = text(1300,0.84 *Ylim,tm);
set(Htext,'fontsize',14,'color','m')
tm1 = 'v_{rms}  =  '; tm2 = num2str(v_rms,'%4.0f '); tm3 = '  m.s^{-1}';
tm = [tm1 tm2 tm3];
Htext = text(100,0.73 *Ylim,tm);
set(Htext,'fontsize',14,'color','k')
tm1 = 'KE_{avg}  =  '; tm2 = num2str(KE_avg,'%2.2e '); tm3 = '  J';
tm = [tm1 tm2 tm3];
Htext = text(1300,0.73 *Ylim,tm);
set(Htext,'fontsize',14,'color','m')
tm1 = 'Probability(v_1 < v < v_2)  =  '; tm2 = num2str(prob12,'%2.2f '); tm3 = '  ';
tm = [tm1 tm2 tm3];
Htext = text(1100,0.62 *Ylim,tm);
set(Htext,'fontsize',14,'color','b')


end



