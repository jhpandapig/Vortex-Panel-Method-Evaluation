%% User input

%NACA = '0012';
N = [10 20 50 100 200 500 2000];
AoA = (0:5:15) .* pi ./ 180;
P = 0.3:0.1:1.5;  % Power law estimate

for NACA = ["2412"]
    %% Calculate CL
    
    CL = NaN(length(N), length(AoA));
    addpath('Vortex Panel Method') 
    
    for i = 1:length(N)
        airfoil = generateAirfoil(NACA, N(i));
        for j = 1:length(AoA)
            [CL(i,j), ~] = calcCL_CM1(airfoil, AoA(j));
        end
    end
    
    
    %% 1/N curve fitting. C = Cinf + k/N^p
    R = NaN(length(P), length(AoA));
    k = R;
    Cinf = R;
    
    for j = 1:length(P)
        p = P(j);
        coeff = NaN(2, length(AoA));
    
        for i = 1:length(AoA)
            x = N.^(-p);
            y = CL(:,i)';
    
            coeff(:,i) = polyfit(x, y, 1);
    
            % Predicted values
            yfit = polyval(coeff(:,i), x);
    
            % Calculate R^2
            SSres = sum((y - yfit).^2);
            SStot = sum((y - mean(y)).^2);
    
            R(j,i) = 1 - SSres/SStot;
        end
        k(j,:) = coeff(1,:);
        Cinf(j,:) = coeff(2,:);
    end
    
    %disp(R)
    
    
    %% Find best-fitting p for each angle of attack
    
    [bestR, index] = max(R);    % Returns the best fit for each AoA. 
    
    bestP = P(index);
    
    bestCinf = NaN(size(AoA));
    for i = 1:length(AoA)
        bestCinf(i) = Cinf(index(i), i);
    end
    
    %% CL subtracted by Cinf
    errorCL = bestCinf - CL(1:end, :);
    
    figure
    hold on
    
    for i = 1:length(AoA)
        plot(N(1:end), errorCL(:,i), 'o-', ...
            'DisplayName', sprintf('AoA = %g deg', AoA(i) .* 180 ./ pi));
    end
    
    % Add 1/N line. 
    n = linspace(N(1), N(end), 1000);
    hold on
    for i = 1:length(AoA)
       plot(n, -k(index(i),i)./n.^bestP(i), '--', ...
            'DisplayName', sprintf('Power law fit p = %g, AoA = %g deg', ...
            bestP(i), AoA(i) .* 180 ./ pi));
    end
    
    xscale('log')
    %yscale('log')
    xlabel('Number of panels N');
    ylabel('Error in CL');
    title('Error by doubling N');
    legend('show');
    grid on;
    
    % disp('Best P')
    % disp(bestP)
    % disp('Best R')
    % disp(bestR)
    %disp('Cinf')
    %disp(bestCinf)
    disp('p')
    disp(bestP)
end