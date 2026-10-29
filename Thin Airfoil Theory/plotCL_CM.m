function plotCL_CM(airfoilTAT, AoA)

% airfoilTAT = generateThinAirfoil('2412', 20);
% AoA = pi./180.* (-10:20);

[CL, CM] = calcCL_CM(airfoilTAT, AoA);

hold on
plot(AoA .* 180./pi, CL)
plot(AoA .* 180./pi, CM);
xlabel('AoA (deg)');
ylabel('Coefficient'); 
legend('TAT CL', 'TAT CM');
grid on;
title('Thin Airfoil Theory CL and CM against AoA');