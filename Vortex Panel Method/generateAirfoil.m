function airfoil = generateAirfoil(NACA, N)
% Generates airfoil structure. 
% 
% Syntax: 
%   airfoil = generateAirfoil(NACA, N)
% Example: 
%   airfoil = generateAirfoil('2412',200)
%
% INPUT: 
%   NACA - NACA series code as a string
%   N - number of panels
%
% OUTPUT:
%   Airfoil struct contains: 
% 1. N, number of panels
% 2. NACA, NACA code
% 3. panelBoundary, (N+1,2) matrix containing coordinates of panel boundaries
% 4. phi, panel angle
% 5. delta, panel outward normal angle
% 6. panelCentre, (N,2) matrix containing coordinates of panel centres
% 7. panelLength, N list containing panel lengths
% 8. meanCamber, (ceil(N/2)+1, 2) matrix containing coordinates of mean camber line

% ------------------------------

% Generate boundary. 
% Check if 4-digit or 5-digit. 
NACA = num2str(NACA);
if length(NACA) == 4
    % Generate 4-digit airfoil. 
    
    [panelBoundary, meanCamber] = generateNaca4(NACA, N);

elseif length(NACA) == 5
    % Generate 5-digit airfoil. 
end

% ------------------------------
% Calculate panel angles phi and delta. 
phi = NaN(1, size(panelBoundary, 1)-1); % Angle from +ve chord line parallel to panel. 
for i = 1:length(phi)
    x = panelBoundary(:,1);
    y = panelBoundary(:,2);
    dx = x(i+1) - x(i);
    dy = y(i+1) - y(i);
    phi(i) = atan2(dy, dx);
end
    
delta = phi + pi/2;                 % Angle of panel's outward normal.  
delta(delta > pi) = delta(delta > pi) - 2*pi;

% ------------------------------
% Panel centre. 
panelCentre = NaN(size(panelBoundary,1)-1, size(panelBoundary,2));
for i = 1:size(panelCentre,1)
    panelCentre(i,:) = (panelBoundary(i,:) + panelBoundary(i+1,:))./2;
end

% ------------------------------
% Panel length s. 
panelLength = NaN(1, size(panelCentre,1));
for i = 1:length(panelLength)
    panelLength(i) = norm(panelBoundary(i+1,:) - panelBoundary(i,:));
end

% ------------------------------
% Package into structure. 

airfoil.N = length(phi);    % Number of panels N is greater than input when N is even. 
airfoil.NACA = NACA;
airfoil.panelBoundary = panelBoundary;
airfoil.delta = delta;
airfoil.phi = phi;
airfoil.panelCentre = panelCentre;
airfoil.panelLength = panelLength;
airfoil.meanCamber = meanCamber;

% ------------------------------
% Plot airfoil. 
%plotAirfoil(airfoil)