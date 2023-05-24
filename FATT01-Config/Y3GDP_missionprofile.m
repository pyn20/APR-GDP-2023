close all;
clc;clear;
%need calculation
taxit = 10;
climbt = 20;
descendt = 20;
rev_climbt = 10;
rev_descend1t = 10;
rev_descend2t = 10;
landt = 10;

cruiseh = 25000;%ft
cruisev = 0.45*20.42;%km/s
cruiset = 1200 / cruisev;%1200km cruise length

rev_cruiseh = 20000;%ft
rev_cruisev = 0.4*20.42;%km/s
rev_cruiset = 150 / rev_cruisev;%150km reversed cruise length
loitert = 30;%min
loiterh = 5000;

taxix = [0,taxit];
taxiy = [0,0];
climbx = [taxit,taxit+climbt];
climby = [0,cruiseh];
cruisex = [climbx(2),cruiset+climbx(2)];
cruisey = [cruiseh,cruiseh];
descendx = [cruisex(2),cruisex(2)+descendt];
descendy = [cruiseh,0];
rev_climbx = [descendx(2),descendx(2)+rev_climbt];
rev_climby = [0,rev_cruiseh];
rev_cruisex = [rev_climbx(2),rev_climbx(2)+rev_cruiset];
rev_cruisey = [rev_cruiseh,rev_cruiseh];
%1x2 array
rev_descendx1 = [rev_cruisex(2),rev_cruisex(2)+rev_descend1t];
rev_descendy1 = [rev_cruiseh,loiterh];
loiterx = [rev_descendx1(2),rev_descendx1(2)+loitert];
loitery = [loiterh,loiterh];
rev_descendx2 = [loiterx(2),loiterx(2)+rev_descend2t];
rev_descendy2 = [loiterh,0];
landx = [rev_descendx2(2),rev_descendx2(2)+landt];
landy = [0,0];


figure;
plot(taxix,taxiy,'-c');
hold on;
plot(climbx,climby,'-b');
hold on;
plot(cruisex,cruisey,'-r');
hold on;
plot(descendx,descendy,'-m');
hold on;
plot(loiterx,loitery,'-p');
hold on;
plot(landx,landy,'-c');
hold on;
plot(rev_climbx,rev_climby,'-b');
hold on;
plot(rev_cruisex,rev_cruisey,'-r');
hold on;
plot(rev_descendx1,rev_descendy1,'-m');
hold on;
plot(rev_descendx2,rev_descendy2,'-m');
hold on;
legend('Taxi','Climb','Cruise','Descend','Loiter','Land');
xlabel('time/min');
ylabel('Altitude/ft');