function rotAirfoil = rotateAirfoil(airfoil, angle)

% Returns airfoil struct with all coordinates rotated by an angle CCW.
%
% SYNTAX:
%   rotAirfoil = rotateAirfoil(airfoil, angle)
%
% INPUT:
%   airfoil - airfoil struct
%   angle - angle of CCW rotation (Rads)
%
% OUTPUT:
%   rotAirfoil - airfoil struct with rotated coordinates

% Rotate airfoil coordinates. 
rotAirfoil = airfoil;
rotAirfoil.panelBoundary = rotatePoint(airfoil.panelBoundary, angle);
rotAirfoil.panelCentre = rotatePoint(airfoil.panelCentre, angle);
rotAirfoil.meanCamber = rotatePoint(airfoil.meanCamber, angle);

% Rotate panel angles. 
rotAirfoil.phi = airfoil.phi + angle;
rotAirfoil.phi(rotAirfoil.phi > pi) = rotAirfoil.phi(rotAirfoil.phi > pi) - 2*pi;
rotAirfoil.delta = airfoil.delta + angle;
rotAirfoil.delta(rotAirfoil.delta > pi) = rotAirfoil.delta(rotAirfoil.delta > pi) - 2*pi;