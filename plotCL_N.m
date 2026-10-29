% Plot CL against AoA for multiple N

NACA = '2412';
AoA = (0:3:15)./180.*pi;
eps = 10^-5;    % Sample point's distance from panel centre. 
N = [100 200];
%N = 1500;

addpath('Vortex Panel Method\')

%--------------------------------------
times = zeros(size(N));
for n = N
    tic;
    airfoil = generateAirfoil(NACA, n);
    %fprintf('Minimum panel length = %.3e\n', min(airfoil.panelLength));
    
    CL= calcCL2(airfoil,AoA);
    elapsedTime = toc;
    times(N == n) = elapsedTime;

    % Convert AoA to deg
    AoAdeg = AoA .*180./pi;
    
    % Plot CL
    hold on
    plot(AoAdeg, CL, 'DisplayName', ...
        sprintf('N = %d (%.3f s)', n, elapsedTime));
end

grid on
title('CL against AoA')
xlabel('AoA (deg)')
ylabel('CL')
legend('show', 'Location', 'best')



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


% ---
% figure
% loglog(N, times, 'o-')
% grid on
% xlabel('Number of panels, N')
% ylabel('Execution time (s)')
% title('Computational Complexity')

% Fit power law
%p = polyfit(log(N), log(times), 1);

%fprintf('Experimental time complexity: O(N^%.2f)\n', p(1));