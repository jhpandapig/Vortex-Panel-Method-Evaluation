
function [CL, CM] = calcCL_CM(airfoil, AoA)
% Returns CL and CM for a given airfoil TAT and angle of attack. 
% 
% SYNTAX:
%   [CL, CM] = calcCL_CM(airfoil, AoA)
%
% INPUT:
%   airfoil - airfoil struct (from Thin Airfoil Theory or VPM). 
%   AoA - angle of attack (rads)
%
% OUTPUT:
%   CL - coefficient of lift
%   CM - coefficient of moment at the leading edge. 

NACA = airfoil.NACA;

if length(NACA) == 4
    m = str2double(NACA(1)) / 100;     % Max camber. 
    p = str2double(NACA(2)) / 10;    % Position of max camber. 
    % Thickness is not considered. 

    t = acos(1 - 2*p);

    % Coefficients A0 to A2. 
    A0 = m/pi * (((2*p - 1) * t + sin(t)) / (p^2) + ...
        ((2*p - 1) * (pi-t) - sin(t)) / (1 - p)^2);
    A1 = (2*m/pi) * (((2*p - 1)*sin(t) + t/2 + sin(2*t)/4)/p^2 + ...
        (-(2*p - 1)*sin(t) + (pi-t)/2 - sin(2*t)/4)/(1-p)^2);
    A2 = (2*m/pi) * ( ...
        ((2*p - 1)*sin(2*t)/2 + sin(t)/2 + sin(3*t)/6)/p^2 + ...
        (-(2*p - 1)*sin(2*t)/2 - sin(t)/2 - sin(3*t)/6)/(1-p)^2);
end

CL = pi * (2 * (AoA - A0) + A1);
CM = -pi / 2 * ((AoA - A0) + A1 - A2 / 2);
end