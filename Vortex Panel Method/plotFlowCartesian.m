% Plot velocity field and streamlines aligned with chord line. 

airfoil = generateAirfoil('2412', 200);
AoA = 10/180*pi;
vss = calcVSS(airfoil,AoA);
xMin = -1;
xMax = 2;
yMin = -1;
yMax = 1;
nodeSpacing = 0.05;
streamlineSpacing = 0.1;

[X, Y] = meshgrid(xMin:nodeSpacing:xMax, yMin:nodeSpacing:yMax);
X = X - nodeSpacing/2;
[U,V] = calcVelocityField(X, Y, airfoil, AoA, vss);

figure
hold on
plotAirfoil(airfoil)
hold on
axis = [xMin xMax yMin yMax];
quiver(X,Y,U,V, 'b')
bounds = [xMin yMin ; xMin yMax ; xMax yMax ; xMax yMin];
for yStart = yMin : streamlineSpacing : yMax
    hold on
    streamline = calcStreamline(xMin, yStart, bounds, airfoil,AoA,vss);
    plot(streamline(:,1), streamline(:,2))
    %streamline(X,Y,U,V, xMin, yStart)
end

% Test no-penetration condition by computing velocity just outside the
% airfoil (passed to ~ 10^-3). 

% Outside panel centres.
% eps = 10^-5;
% testPoints = airfoil.panelCentre + eps*[cos(airfoil.delta') sin(airfoil.delta')];
% plot(testPoints(:,1),testPoints(:,2),'r')
% [U, V] = calcVelocityField(testPoints(:,1), testPoints(:,2),airfoil,AoA,vss);
% normalVelocity = U .* cos(airfoil.delta') + V .* sin(airfoil.delta');
% disp(normalVelocity(normalVelocity>10^-3))