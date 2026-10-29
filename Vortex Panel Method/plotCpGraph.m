% Plot Cp graph over the airfoil. 

%% User input values. 
airfoil = generateAirfoil('2412', 200);
AoA = 15/180*pi;
vss = calcVSS(airfoil,AoA);
xMin = -0.2;
xMax = 1.2;
P = 1:7;

%% Plot ambient static pressure and stagnation pressure
figure
hold on
plot([xMin xMax], [0 0], '--', 'DisplayName', sprintf('Ambient pressure'))
plot([xMin xMax], [1 1], '--', 'DisplayName', sprintf('Stagnation pressure'))

%% Iterate for each exponent in P
N = airfoil.N;
CL = NaN(size(P));
for p = P
    eps = 10^-p;
    testPoints = airfoil.panelCentre + eps*[cos(airfoil.delta') sin(airfoil.delta')];
    CpSurface = calcPressure(testPoints(:,1), testPoints(:,2), airfoil, AoA, vss);
    plot(airfoil.panelCentre(:,1), CpSurface, ...
        'DisplayName', sprintf('p = %d, eps = 10^{-%d}', p, p));

    % Calculate CL
    vss = calcVSS(airfoil,AoA);
    testPoints = airfoil.panelCentre + eps*[cos(airfoil.delta') sin(airfoil.delta')];
    CpSurface = calcPressure(testPoints(:,1), testPoints(:,2), airfoil, AoA, vss)';
    panelForce = -CpSurface .* airfoil.panelLength; % Outward +ve
    CL(P==p) = sum(panelForce .* sin(airfoil.delta - AoA));
end

%% Plot each CP graph
%figure
hold on
title('Graph of CP along chord line')
set(gca, 'YDir','reverse')
xlim([xMin xMax])
xlabel('x* - non-dimensional length along chord line')
ylabel('Cp (inverted axis)')


legend('show', 'Location', 'best')

figure
plot(P,CL)
xlabel('Exponent of sample distance')
ylabel('CL')
title('CL against sample distance')
grid on


%% Power law regression of CL against sampling distance

eps_values = 10.^(-P);

% Trial convergence exponents
Q = 0.1:0.01:3;

R2 = NaN(size(Q));
coefficients = NaN(length(Q), 2);

for i = 1:length(Q)

    q = Q(i);

    % Transform independent variable
    x = eps_values(:).^q;
    y = CL(:);

    % Linear regression
    coeff = polyfit(x, y, 1);

    k = coeff(1);
    CL0 = coeff(2);

    coefficients(i,:) = [k, CL0];

    % Calculate R-squared
    yfit = polyval(coeff, x);

    SSres = sum((y-yfit).^2);
    SStot = sum((y-mean(y)).^2);

    if SStot > 0
        R2(i) = 1 - SSres/SStot;
    end

end

%% Find best-fitting exponent

[bestR2, idx] = max(R2);

bestQ = Q(idx);
bestK = coefficients(idx,1);
bestCL0 = coefficients(idx,2);

fprintf('Best exponent q = %.4f\n', bestQ);
fprintf('R-squared = %.6f\n', bestR2);
fprintf('Extrapolated CL = %.8f\n', bestCL0);

%% Plot numerical results and fitted power law

eps_fit = logspace(log10(min(eps_values)), ...
    log10(max(eps_values)), 300);

CL_fit = bestCL0 + bestK .* eps_fit.^bestQ;

figure;
semilogx(eps_values, CL, 'o', ...
    'DisplayName', 'VPM results');
hold on;

semilogx(eps_fit, CL_fit, '--', ...
    'LineWidth', 1.5, ...
    'DisplayName', ...
    sprintf('Power law fit: q = %.3f, R^2 = %.5f', ...
    bestQ, bestR2));

xlabel('Pressure sampling distance, \epsilon');
ylabel('Lift coefficient, C_L');
title('Convergence of C_L with Sampling Distance');
legend('show', 'Location', 'best');
grid on;

%% Plot R-squared against trial exponent

figure;
plot(Q, R2, 'LineWidth', 1.5);
hold on;
plot(bestQ, bestR2, 'ro');

xlabel('Trial exponent, q');
ylabel('R^2');
title('Power Law Regression Goodness of Fit');
grid on;
