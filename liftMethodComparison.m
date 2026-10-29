% Compare lift calculation methods by plotting multiple CL-AoA graphs

clear

%% User Input
NACA = '2412';
N = 200;
AoA = (0:3:15) .* pi ./ 180;

principal = true;
alt1 = false;
alt2 = true;

addpath('Vortex Panel Method\')
airfoil = generateAirfoil(NACA,N);

hold on
if principal == true
    CL2 = calcCL2(airfoil,AoA);
    plot(AoA .* 180 ./ pi, CL2)
end
if alt1 == true
    [CL1, ~] = calcCL_CM1(airfoil, AoA);
    plot(AoA .* 180 ./ pi, CL1)
end
if alt2 == true
    CL3 = calcCL3(airfoil,AoA);
    plot(AoA .* 180 ./ pi, CL3)
end

hold on
xlabel('AoA (deg)')
ylabel('CL')
labels = ["Principal","Alt 1", "Alt 2"];
legend(labels([principal alt1 alt2]))
grid on
