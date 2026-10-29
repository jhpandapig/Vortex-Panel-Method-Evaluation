function [CL, CM] = calcCL_CM1(airfoil,AoA)
% Calculates lift and moment coefficient using pressure distribution over
% aerofoil surface. 
%
% SYNTAX: 
%   [CL, CM] = calcCL_CM1(airfoil,AoA)
%
% INPUT: 
%   airfoil - airfoil struct
%   AoA - list of AoA (rads)
%
% OUTPUT: 
%   CL - list of lift coefficients
%   CM - list of moment coefficients


eps = 10^-5;    % Sample point's distance from panel centre. 

CL = NaN(size(AoA));
CM = NaN(size(AoA));

for i = 1:length(AoA)
    vss = calcVSS(airfoil,AoA(i));
    testPoints = airfoil.panelCentre + eps*[cos(airfoil.delta') sin(airfoil.delta')];
    CpSurface = calcPressure(testPoints(:,1), testPoints(:,2), airfoil, AoA(i), vss)';
    panelForce = -CpSurface .* airfoil.panelLength; % Outward +ve
    CL(i) = sum(panelForce .* sin(airfoil.delta - AoA(i)));

    % Following vector components are aligned with chord line. 
    panelForceVec = [cos(airfoil.delta) ; sin(airfoil.delta) ; zeros(1,airfoil.N)] ...
        .* [panelForce ; panelForce ; panelForce];
    positionVec = [airfoil.panelCentre zeros(size(airfoil.panelCentre, 1), 1)]';
    moment = cross(positionVec, panelForceVec);
    CM(i) = -sum(moment(3,:));  % nose-up +ve. 
end 
