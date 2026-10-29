function [U,V] = calcVelocityField(X,Y, airfoil, AoA, vss)

% Calculates combined velocity field. 
%
% Syntax: 
%   [U,V] = calcVelocityField(X, Y, airfoil, AoA, vss)
%
% INPUT:
%   X - matrix of x-coordinates
%   Y - matrix of y-coordinates
%   airfoil - airfoil struct
%   AoA - angle of attack (rads)
%   vss - list of vortex sheet strengths
%
% OUTPUT:
%   U - matrix of x-component of combined velocity
%   V - matrix of y-component of combined velocity 


% Remove points inside airfoil. 
in = inpolygon(X,Y,airfoil.panelBoundary(:,1), airfoil.panelBoundary(:,2));
X(in) = NaN;
Y(in) = NaN;
[inducedU, inducedV] = calcInducedFlow(X,Y,airfoil,vss);
[freeU, freeV] = calcFreestream(AoA);
U = freeU + inducedU;
V = freeV + inducedV;

% U(in) = 0;
% V(in) = 0;