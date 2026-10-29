% Plots pressure field as a colour plot. 

airfoil = generateAirfoil('2412', 200);
AoA = 10/180*pi;
vss = calcVSS(airfoil,AoA);
xMin = -0.2;
xMax = 1.2;
yMin = -0.3;
yMax = 0.3;
nodeSpacing = 0.001;
streamlineSpacing = 0.1;

[X, Y] = meshgrid(xMin:nodeSpacing:xMax, yMin:nodeSpacing:yMax);
X = X - nodeSpacing/2;
CP = calcPressure(X,Y,airfoil,AoA,vss);

figure
hold on
plotAirfoil(airfoil)
contourf(X,Y,CP,50,'LineColor','none');
axis([xMin xMax yMin yMax]);
axis equal

colormap(turbo);

cb = colorbar;
cb.Label.String = 'Pressure coefficient, C_p';

clim([-3 1]);  % Optional: set colour limits