function vss = calcVSS(airfoil, AoA)

% Calculates boundary vortex sheet strengths. 
%
% SYNTAX: 
%   vss = calculateVSS(airfoil, AoA)
%
% INPUT:
%   airfoil - airfoil struct
%   AoA - angle of attack (rads)
%
% OUTPUT:
%   vss - (N+1) list of boundary vortex sheet strengths



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
            A(i,j) = a1;
            B(i,j+1) = a2;

            % Verify via symbolic integral with coefficients (passed). 
            % syms z
            % expr = (C1*z + C2) / ((z+C3)^2 + C5^2);
            % E_error = vpa(int(expr, z, [0 s])) - E;
            % disp(E_error)
            % 
            % syms z
            % expr = (z/s)*(C1*z + C2) / ((z+C3)^2 + C5^2);
            % D_error = vpa(int(expr, z, [0 s])) - D;
            % disp(D_error)
        end
    end
end

% Combined influence of j on the ith panel = M(i,j). 
M = A + B; 

% Kutta condition: TE circulation = 0. 
M(end, 1) = 1;
M(end, end) = 1;

% Vector b to solve Mx = b. 
b = -2*pi*cos(airfoil.delta - AoA)';    % No penetration
b(N+1) = 0;                             % Kutta condition. 

% Solve for vortex sheet strength vss. 
vss = M\b;
vss = vss';

% Test matrix condition
%fprintf('N = %d, cond(M) = %.3e\n', N, cond(M));


%------------------------------
% Test no-penetration using coefficients (passed). 
% inducedFlow = zeros(1,N);
% for i = 1:N
%     inducedFlow(i) = (A(i,:)+B(i,:))*vss'./(2*pi);
% 
% end

% Test A and B. 
% altA = zeros(N+1);
% altB = zeros(N+1);
% for i = 1:N
%     for j = 1:N
%         x = airfoil.panelCentre(i,1); 
%         y = airfoil.panelCentre(i,2);
%         X = airfoil.panelBoundary(j,1);
%         Y = airfoil.panelBoundary(j,2);
%         s = airfoil.panelLength(j);
%         C1 = sin(airfoil.phi(j) - airfoil.delta(i));
%         C2 = cos(airfoil.phi(i)) * (x-X) + sin(airfoil.phi(i)) * (y-Y);
%         C3 = cos(airfoil.phi(j)) * (X-x) + sin(airfoil.phi(j)) * (Y-y);
%         C4 = (x-X)^2 + (y-Y)^2;
%         C5 = sqrt(C4 - C3^2);
% 
%         syms z
%         expr = 1/(2*pi) * (1 - z/s) * (C1*z + C2) / ((z+C3)^2 + C5^2);
%         altA = 
%     end
% end



% Test no-penetraion by integrating solution of vss.  (passed). 

% inducedFlow = zeros(1,N);
% for i = 1:N
%     for j = 1:N
%         if i == j
%             inducedFlow(i) = inducedFlow(i) + 1/(2*pi)*(vss(j) - vss(j+1));
%         else
%             x = airfoil.panelCentre(i,1); 
%             y = airfoil.panelCentre(i,2);
%             X = airfoil.panelBoundary(j,1);
%             Y = airfoil.panelBoundary(j,2);
%             s = airfoil.panelLength(j);
%             C1 = sin(airfoil.phi(j) - airfoil.delta(i));
%             C2 = cos(airfoil.phi(i)) * (x-X) + sin(airfoil.phi(i)) * (y-Y);
%             C3 = cos(airfoil.phi(j)) * (X-x) + sin(airfoil.phi(j)) * (Y-y);
%             C4 = (x-X)^2 + (y-Y)^2;
%             C5 = sqrt(C4 - C3^2);
% 
%             syms z
%             expr = 1/(2*pi)*(vss(j) + (vss(j+1) - vss(j)) * z/s) * ...
%                 (C1*z + C2) / ((z+C3)^2 + C5^2);
%             inducedFlow(i) = inducedFlow(i) + vpaintegral(expr,z,[0 s]);
%             clear z
%         end
%     end
%     altInducedFlow(i) = (A(i,:)+B(i,:))*vss'./(2*pi);
%     disp(inducedFlow(i) - altInducedFlow(i))
% end
% 
% freestream = cos(airfoil.delta - AoA);
% Un = freestream + inducedFlow;
% disp(Un)
% end