% Initialise matrices. 
N = airfoil.N;
A = zeros(N+1);         % A contains the coefficients for the start boundary point vss. 
B = zeros(N+1, N+1);    % B contains the coefficients for the end boundary point vss. 

% Calculate coefficients for the jth panel's influence on the ith panel. 
% These equations are conditions of no-penetration of each panel.
% Specifically, normal velocity at the centre of each panel = 0. 
for i = 1:N
    for j = 1:N
        if i == j
            A(i,j) = 1;
            B(i,j+1) = -1;
        else
            x = airfoil.panelCentre(i,1); 
            y = airfoil.panelCentre(i,2);
            X = airfoil.panelBoundary(j,1);
            Y = airfoil.panelBoundary(j,2);
            s = airfoil.panelLength(j);
            C1 = sin(airfoil.phi(j) - airfoil.delta(i));
            C2 = cos(airfoil.phi(i)) * (x-X) + sin(airfoil.phi(i)) * (y-Y);
            C3 = cos(airfoil.phi(j)) * (X-x) + sin(airfoil.phi(j)) * (Y-y);
            C4 = (x-X)^2 + (y-Y)^2;
            C5 = sqrt(C4 - C3^2);
    
            [a1, a2] = intSF(C1,C2,C3,C4,C5,s);
            A(i,j) = a1-a2;
            B(i,j+1) = a2;
        end
    end
end