function Cp = calcPressure(X, Y, airfoil, AoA, vss)

% Calculates coefficient of pressure at a point or as a field. 
%
% SYNTAX:
%   CP = calcPressure(X, Y, airfoil, AoA, vss)
%   
% INPUT:
%   X - matrix of x-coordinates
%   Y - matrix of y-coordinates
%   airfoil - airfoil struct
%   AoA - angle of attack (rads)
%   vss - list of vortex sheet strengths
%
% OUTPUT:
%   CP - matrix of coefficient of pressure 


[U,V] = calcVelocityField(X, Y, airfoil, AoA, vss);
u = hypot(U,V); % Mag of velocity
Cp = 1 - u.^2;  % Note: u is already non-dimensional. 