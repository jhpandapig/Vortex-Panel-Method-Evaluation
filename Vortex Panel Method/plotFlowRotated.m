% Plot velocity field and streamlines aligned with freestream. 

% User input values. 
airfoil = generateAirfoil('2412', 200);
AoA = 15/180*pi;
vss = calcVSS(airfoil,AoA);
xMin = -1.5;
xMax = 2.5;
yMin = -1.2;
yMax = 1.2;
nodeSpacing = 0.05;
streamlineSpacing = 0.1;

% ------------------------------

% Initialise standard meshgrid. 
[X, Y] = meshgrid(xMin:nodeSpacing:xMax, yMin:nodeSpacing:yMax);
X = X - nodeSpacing/2;

% Calculate velocity field for rotated meshgrid and plot vector field. 
% Rotate mesh coordinates to align with freestream.
[rotX, rotY] = rotateMesh(X, Y, AoA);
[U,V] = calcVelocityField(rotX, rotY, airfoil, AoA, vss);   % U,V aligned with chord line. 
% Rotate velocity components back to the freestream-aligned coordinates.
[rotU, rotV] = rotateMesh(U, V, -AoA);

% Rotate airfoil coordinates. 
rotAirfoil = airfoil;
rotAirfoil.panelBoundary = rotatePoint(airfoil.panelBoundary, -AoA);
rotAirfoil.panelCentre = rotatePoint(airfoil.panelCentre, -AoA);
rotAirfoil.meanCamber = rotatePoint(airfoil.meanCamber, -AoA);

figure
hold on
plotAirfoil(rotAirfoil)
hold on
axis([xMin xMax yMin yMax])
axis equal
quiver(X,Y,rotU,rotV, 'b')


% Rotate bounds for streamline. 
bounds = [xMin yMin ; xMin yMax ; xMax yMax ; xMax yMin];
rotBounds = rotatePoint(bounds, AoA);

for yStart = yMin : streamlineSpacing : yMax
    % Compute rotated start points. 
    startPoint = rotatePoint([xMin yStart], AoA);

    % Generate streamline in coordinates aligned with chord. 
    streamline = calcStreamline(startPoint(1), startPoint(2), rotBounds, airfoil, AoA, vss);

    % Rotate streamline coordinates. 
    rotStreamline = rotatePoint(streamline,-AoA);
    hold on
    plot(rotStreamline(:,1), rotStreamline(:,2));
end
