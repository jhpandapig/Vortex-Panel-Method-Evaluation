function airfoil = generateThinAirfoil(NACA, N)
% INPUT: NACA series code as a string, number of panels. 
% Returns airfoil structure. 
% Syntax: airfoil = generateAirfoil(2412, 200). 
%
% Airfoil struct contains: 
% 1. N, number of panels. 
% 2. panelBoundary, (N+1,2) matrix containing coordinates of panel boundaries. 
% 3. phi, panel angle. 
% 4. delta, panel outward normal angle. 
% 5. panelCentre, (N,2) matrix containing coordinates of panel centres. 
% 6. panelLength, N list containing panel lengths. 
% 7. meanCamber, (ceil(N/2)+1, 2) matrix containing coordinates of mean camber line. 

% ------------------------------

% Generate boundary. 
% Check if 4-digit or 5-digit. 
NACA = num2str(NACA);
if length(NACA) == 4
    % Generate 4-digit airfoil. 
    
    [meanCamber, camberGrad] = generateNaca4(NACA, N);

elseif length(NACA) == 5
    % Generate 5-digit airfoil. 
end

% ------------------------------
% Package into structure. 

airfoil.NACA = NACA;
airfoil.meanCamber = meanCamber;
airfoil.camberGrad = camberGrad;

% ------------------------------
% Plot airfoil. 
%figure
%plotAirfoil(airfoil)