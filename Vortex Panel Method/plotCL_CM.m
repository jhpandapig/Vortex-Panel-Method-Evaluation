% Plots CL and CM using the first method. 
% Test. 
airfoil = generateAirfoil('2412', 200);
%airfoil = flatPlate;
AoA = (-15 : 1 : 80)./180.*pi;
%--------------------------------------

[CL,CM] = calcCL_CM1(airfoil, AoA);

% Convert AoA to deg
AoAdeg = AoA .*180./pi;

hold on
% Plot CL
% figure
plot(AoAdeg, CL)


% Calculate gradient (thin airfoil theory = 2pi/rad)
% p = polyfit(AoA,CL,1);
% gradCL = p(1);
% subtitle(['Gradient of VPM CL/rad = ' num2str(p(1)) ', 2pi = ' num2str(2*pi)])
% text(0, 0, ['CL(0) = ' num2str(round(p(2), 2))])

% Plot CD
% figure
% plot(AoAdeg, CD, 'r-o')
% title('CD against AoA (deg). Note: D Alemberts Paradox applies. CD should = 0')
% xlabel('AoA (deg)')
% ylabel('CD')

% Plot CM
% plot(AoAdeg, CM)
% grid on
% title('VPM CL and CM against AoA')
% xlabel('AoA (deg)')
% ylabel('Coefficient')
% legend('VPM CL', 'VPM CM')

% Plot centre of pressure and aerodynamic centre. 

% CoP = CM./CL;
% 
% for i = 1:length(AoA)-1
%     meanAoA(i) = (AoA(i) + AoA(i+1)) ./ 2;
%     gradCL(i) = (CL(i+1) - CL(i))./(AoA(i+1) - AoA(i));
%     gradCM(i) = (CM(i+1) - CM(i))./(AoA(i+1) - AoA(i));
% end
% 
% AC = gradCM ./ gradCL;
% 
% figure
% hold on
% plot(AoAdeg, CoP, 'r-o')
% plot(meanAoA .* 180 ./ pi, AC, 'y-o')
% legend('Centre of Pressure', 'Aerodynamic Centre')