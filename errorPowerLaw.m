%% Inputs
NACA = '2412';
N = [10 50 100 200 400 800 1600];
AoA_deg = 0:5:15;
AoA = deg2rad(AoA_deg);

%% Calculate lift coefficients
CL = NaN(length(N), length(AoA));

addpath('Vortex Panel Method');

for i = 1:length(N)

    airfoil = generateAirfoil(NACA, N(i));

    for j = 1:length(AoA)
        [CL(i,j), ~] = calcCL_CM1(airfoil, AoA(j));
    end

end

%% Plot CL against N and AoA
[n, a] = meshgrid(N, AoA_deg);

figure
surf(n, a, CL')
shading interp
colorbar

xlabel('Number of panels, N')
ylabel('AoA (degrees)')
zlabel('CL')
title('N - AoA - CL')


%% Differences by doubling N
deltaCL = CL(1:end-1,:) - CL(2:end,:);

figure
hold on

for j = 1:length(AoA)
    plot(N(2:end), deltaCL(:,j), 'o-', ...
        'DisplayName', sprintf('AoA = %g deg', AoA_deg(j)));
end

xscale('log')
xlabel('Number of panels N');
ylabel('Successive difference');
title('Successive Differences by doubling N');
legend('show');
grid on;

%% Calculate observed convergence order using richardson extrap. method
p = NaN(length(N)-2, length(AoA));

for i = 1:length(N)-2

    d1 = CL(i,:) - CL(i+1,:);
    d2 = CL(i+1,:) - CL(i+2,:);

    p(i,:) = log2(abs(d1./d2));

end

%% Plot convergence order
figure;
hold on;

for j = 1:length(AoA)
    plot(N(2:end-1), p(:,j), 'o-', ...
        'DisplayName', sprintf('AoA = %g deg', AoA_deg(j)));
end

xlabel('Number of panels (middle mesh)');
ylabel('Observed convergence order, p');
title('VPM Convergence Order');
legend('show');
grid on;

%% Display results
disp('Successive differences in CL:');
disp(deltaCL);

disp('Observed convergence orders:');
disp(p);
