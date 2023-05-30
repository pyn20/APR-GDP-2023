density = 2700;
mixTankOuterDia = 0.3;
mixTankThickness = 5e-3;
mixTankInnerDia = mixTankOuterDia - 2*mixTankThickness
mixtankLength = 3;
mixtankVolume = mixtankLength*pi*(mixTankInnerDia/2)^2
mixtankWeight = density*mixtankLength*pi*((mixTankOuterDia/2)^2-(mixTankInnerDia/2)^2)