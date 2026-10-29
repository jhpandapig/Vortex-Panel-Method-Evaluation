function [a1, a2] = intSF(C1, C2, C3, C4, C5, s)
% intSF stands for integrate standard form. 
% Computes the integral of the form:
% (vss(j) + (vss(j+1)-vss(j) * (z/s)) * (C1*z + C2) / ((z+C3)^2 + C4 - C3^2)
% from 0 to s and returns the values a1 and a2 where a1 and a2 are of the form:
% a1*vss(j) + a2*vss(j+1). 
%
% SYNTAX: 
%   [a1, a2] = deal(intSF(C1, C2, C3, C4, C5, [xMin xMax]))
%
% EXAMPLE SETUP: 
    % x = airfoil.panelCentre(i,1); 
    % y = airfoil.panelCentre(i,2);
    % X = airfoil.panelBoundary(j,1);
    % Y = airfoil.panelBoundary(j,2);
    % s = airfoil.panelLength(j);
    % C1 = sin(airfoil.phi(j) - airfoil.delta(i));
    % C2 = cos(airfoil.phi(i)) * (x-X) + sin(airfoil.phi(i)) * (y-Y);
    % C3 = cos(airfoil.phi(j)) * (X-x) + sin(airfoil.phi(j)) * (Y-y);
    % C4 = (x-X)^2 + (y-Y)^2;
    % C5 = sqrt(C4 - C3^2);
%
% INPUT: C1, C2, C3 ,C4, C5, s, [xMin xMax]. 
%
% OUTPUT:
%   a1 - scalar proportional to vss(j)
%   a2 - scalar proportional to vss(j+1)


if ~ imag(C5) == 0
    error('C5 must be real.');
    disp(C5)
end

I1 = C1./2 .* log(abs((s.^2 + 2.*s.*C3 + C4)./C4)) + ...
    (C2-C1.*C3)./C5 .* (atan((s+C3)./C5) - atan(C3./C5));
I2 = C1 + (C2-2.*C1.*C3)./(2.*s) .* log(abs((s.^2 + 2.*s.*C3 + C4)./C4)) + ...
    (2.*C1.*C3.^2 - C2.*C3 - C1.*C4)./(s.*C5) .* (atan((s+C3)./C5) - atan(C3./C5));

a1 = I1 - I2;
a2 = I2;