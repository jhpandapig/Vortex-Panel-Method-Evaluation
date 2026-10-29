function [U,V] = calcInducedFlow(X,Y, airfoil, vss)

% Returns components of induced flow velocity in coordinate frame aligned
% with the chord line. 
%
% SYNTAX:
%   [U,V] = calcInducedFlow(X,Y, airfoil, vss)
% 
% INPUT: 
%   X - matrix of x-coordinates
%   Y - matrix of y-coordinates
%   airfoil - airfoil struct
%   vss - list of vortex sheet strengths
%
% OUTPUT: 
%   U - matrix of x-component of induced flow velocity
%   V - matrix of y-component of induced flow velocity

% Initialise U and V. 
U = zeros(size(X));
V = zeros(size(X));

% Calculate U, summing over each panel. 

for j = 1:airfoil.N
    Xboundary = airfoil.panelBoundary(j,1);
    Yboundary = airfoil.panelBoundary(j,2);
    C1 = sin(airfoil.phi(j));
    C2 = Yboundary - Y;
    C3 = cos(airfoil.phi(j)) .* (Xboundary-X) + sin(airfoil.phi(j)) .* (Yboundary-Y);
    C4 = (X-Xboundary).^2 + (Y-Yboundary).^2;
    C5 = sqrt(C4 - C3.^2);
    
    [a1,a2] = intSF(C1,C2,C3,C4,C5,airfoil.panelLength(j));
    U = U + 1./(2.*pi) .* (a1.*vss(j) + a2.*vss(j+1));

end

% Calculate V
for j = 1:airfoil.N
    Xboundary = airfoil.panelBoundary(j,1);
    Yboundary = airfoil.panelBoundary(j,2);
    C1 = -cos(airfoil.phi(j));
    C2 = X - Xboundary;
    C3 = cos(airfoil.phi(j)) .* (Xboundary-X) + sin(airfoil.phi(j)) .* (Yboundary-Y);
    C4 = (X-Xboundary).^2 + (Y-Yboundary).^2;
    C5 = sqrt(C4 - C3.^2);

    [a1,a2] = intSF(C1,C2,C3,C4,C5,airfoil.panelLength(j));
    V = V + 1./(2.*pi) .* (a1.*vss(j) + a2.*vss(j+1));
    % disp(V)
end
