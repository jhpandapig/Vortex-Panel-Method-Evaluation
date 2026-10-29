function CL = calcCL1(airfoil,AoA)
% Calculates lift and moment coefficient using pressure distribution over
% aerofoil surface. 
%
% SYNTAX: 
%   CL = calcCL1(airfoil,AoA)
%
% INPUT: 
%   airfoil - airfoil struct
%   AoA - list of AoA (rads)
%
% OUTPUT: 
%   CL - list of lift coefficients

eps = 10^-5;    % Sample point's distance from panel centre. 

CL = NaN(size(AoA));

for i = 1:length(AoA)
    vss = calcVSS(airfoil,AoA(i));
    testPoints = airfoil.panelCentre + eps*[cos(airfoil.delta') sin(airfoil.delta')];
    CpSurface = calcPressure(testPoints(:,1), testPoints(:,2), airfoil, AoA(i), vss)';
    panelForce = -CpSurface .* airfoil.panelLength; % Outward +ve
    CL(i) = sum(panelForce .* sin(airfoil.delta - AoA(i)));
end 
