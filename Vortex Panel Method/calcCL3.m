function CL = calcCL3(airfoil, AoA)
% Calculates lift coefficient by the steady-state momentum equation around
% a control volume. 
%
% SYNTAX: 
%   CL = calcCL3(airfoil,AoA)
%
% INPUT: 
%   airfoil - airfoil struct
%   AoA - list of AoA (rads)
%
% OUTPUT: 
%   CL - list of lift coefficients

%% User Input for Control Volume
xMin = -0.2;
xMax = 1.2;
yMin = -0.5;
yMax = 0.5;

nodeSpacing = 0.05;


%% Calculate vortex sheet strengths
CL = NaN(size(AoA));
for i = 1:length(AoA)
    vss = calcVSS(airfoil, AoA(i));
    
    % Generate mesh
    [X,Y] = meshgrid(xMin:nodeSpacing:xMax, yMin:nodeSpacing:yMax);
    X(2:end-1, 2:end-1) = NaN;  % Clear unused nodes
    Y(2:end-1, 2:end-1) = NaN;
    
    % Calculate velocity and pressure
    [U,V] = calcVelocityField(X,Y,airfoil,AoA(i),vss);
    CP = calcPressure(X,Y,airfoil,AoA(i),vss);
    
    % Pressure force on outer control surface
    % Force on fluid = -integral(Cp*n)dS
    
    FpressureX = ...
        trapz(Y(:,1), CP(:,1)) ...
        - trapz(Y(:,end), CP(:,end));
    
    FpressureY = ...
        trapz(X(1,:), CP(1,:)) ...
        - trapz(X(end,:), CP(end,:));
    
    surfaceF = [FpressureX; FpressureY];
    
    %% Momentum flux through outer control surface
    % Integral of V*(V dot n)dS
    
    % Upper boundary (n = [0,1])
    upperFluxX = trapz(X(end,:), U(end,:).*V(end,:));
    upperFluxY = trapz(X(end,:), V(end,:).^2);
    
    % Lower boundary (n = [0,-1])
    lowerFluxX = -trapz(X(1,:), U(1,:).*V(1,:));
    lowerFluxY = -trapz(X(1,:), V(1,:).^2);
    
    % Right boundary (n = [1,0])
    rightFluxX = trapz(Y(:,end), U(:,end).^2);
    rightFluxY = trapz(Y(:,end), U(:,end).*V(:,end));
    
    % Left boundary (n = [-1,0])
    leftFluxX = -trapz(Y(:,1), U(:,1).^2);
    leftFluxY = -trapz(Y(:,1), U(:,1).*V(:,1));
    
    momentumFlux = [ ...
        upperFluxX + lowerFluxX + rightFluxX + leftFluxX;
        upperFluxY + lowerFluxY + rightFluxY + leftFluxY];
    
    %% Force on airfoil
    
    CF = surfaceF - 2*momentumFlux;
    
    % Lift perpendicular to freestream
    CL(i) = -CF(1)*sin(AoA(i)) + CF(2)*cos(AoA(i));

%disp('Force coefficients [Cx; Cy]:');
%disp(CF);

end
