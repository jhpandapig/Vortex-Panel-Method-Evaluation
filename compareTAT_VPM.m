% Compare plots of Thin Airfoil Theory and VPM
% Import XFOIL polar file
filename = 'naca2412_polar.txt';

% Generate TAT and VPM data
NACA = '2412';      % String
N = 200;
AoA = (-15:20) .*pi ./ 180;

plotTAT = true;
plotVPM = true;
plotXFoil = true;
plotAirfoils = false;

% --------------------------------------------------

% TAT
if plotTAT == true
    % Calc TAT coefficients
    cd 'Thin Airfoil Theory'\
    airfoilThin = generateThinAirfoil(NACA, N);
    if plotAirfoils == true
        figure(1)
        plotAirfoil(airfoilThin)
    end
    [TAT_CL, TAT_CM] = calcCL_CM(airfoilThin, AoA);
    cd ..
    
    figure(3)
    hold on
    plot(AoA .* 180 ./ pi, TAT_CL)
end

% VPM
if plotVPM == true
    % Calc VPM coefficients
    cd 'Vortex Panel Method'\
    airfoilVPM = generateAirfoil(NACA, N);
    if plotAirfoils == true
        figure(2)
        plotAirfoil(airfoilVPM)
    end
    [VPM_CL, VPM_CM] = calcCL_CM(airfoilVPM, AoA);

    % Calc CL and CM grad between -10 to 10 deg for VPM. 
    [CL1, CM1] = calcCL_CM(airfoilVPM, -5*pi/180);
    [CL2, CM2] = calcCL_CM(airfoilVPM, 5*pi/180);
    CL_grad = (CL2 - CL1) / (10 * pi / 180);
    CM_grad = (CM2 - CM1) / (10 * pi / 180);
    cd ..
    
    figure(3)
    hold on
    plot(AoA .* 180 ./ pi, VPM_CL)
end

% XFoil
if plotXFoil == true
    % Locate the start of numerical data
    fid = fopen(filename, 'r');
    assert(fid ~= -1, 'Could not open polar file.');
    
    while true
        line = fgetl(fid);
    
        if ~ischar(line)
            error('No numerical polar data found.');
        end
    
        values = sscanf(line, '%f');
    
        if numel(values) >= 5
            break;
        end
    end
    
    % Return to start of first numerical row
    frewind(fid);
    
    % Read all lines and retain numerical rows
    data = [];
    while ~feof(fid)
        line = fgetl(fid);
        values = sscanf(line, '%f');
    
        if numel(values) >= 5
            data(end+1, :) = values(1:5).'; %#ok<SAGROW>
        end
    end
    fclose(fid);
    
    % Extract columns
    alpha = data(:,1);
    CL = data(:,2);
    
    % Plot lift curve
    figure(3)
    hold on
    plot(alpha, CL);
end

% ---------------------------------------------------

xlabel('Angle of Attack (deg)')
ylabel('CL')

legendLabels = ["TAT CL", "VPM CL", "XFoil CL"];
legend(legendLabels([plotTAT plotVPM plotXFoil]))
grid on
title('CL: TAT vs VPM')
subtitle(['VPM CL gradient (/rads) = ' num2str(CL_grad) ...
    '. VPM - TAT grad = ' ...
    num2str(CL_grad - 2*pi)])

% Plot CM
figure
hold on
plot(AoA .* 180 ./ pi, TAT_CM)
plot(AoA .* 180 ./ pi, VPM_CM)
xlabel('Angle of Attack (deg)')
ylabel('CM')
legend('TAT CM', 'VPM CM')
grid on
title('CM: TAT vs VPM')
subtitle(['VPM CM gradient (/rads) = ' num2str(CM_grad) '. VPM - TAT grad = ' ...
    num2str(CM_grad + pi/2)])

