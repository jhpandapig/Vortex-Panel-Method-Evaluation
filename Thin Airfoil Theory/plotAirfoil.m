function plotAirfoil(airfoil)

% Plot airfoil. 
hold on
axis([-1 2 -1 1])
axis equal
%plot(airfoil.panelBoundary(:,1), airfoil.panelBoundary(:,2),'w-')
plot(airfoil.meanCamber(:,1), airfoil.meanCamber(:,2),'y--')
