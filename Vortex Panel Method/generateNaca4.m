function [panelBoundary, meanCamber] = generateNaca4(NACA, N)
% Returns coordinates of the panel's boundaries and mean camber line.  
% 
% SYNTAX: 
%   [panelBoundary, meanCamber] = generateNaca4(NACA, N)
%
% INPUT: 
%   NACA - NACA series code as a string
%   N - number of panels
%
% OUTPUT:
%   panelBoundary - (N+1,2) matrix containing coordinates of panel boundary
%   points
%   meanCamber - (m,2) matrix containing coordinates of mean camber line

%% User inputs
cosDistribution = true;    % Use a cosine distribution or regular spacing of panels. 

%% Extract NACA values

m = str2double(NACA(1)) / 100;     % Max camber. 
p = str2double(NACA(2)) / 10;    % Position of max camber. 
t = str2double(NACA(3:4)) / 100;  % Thickness. 

%% Generate x-coordinates
if cosDistribution == true
    a = linspace(0,pi,ceil(N/2)+1);   % N/2 for upper and lower surfaces. 
    x = (1 - cos(a))./2;
else
    x = linspace(0, 1, ceil(N/2) + 1);
end


%% Generate mean camber line yMean and camber gradient camberGrad. 
if m == 0 || p == 0
    yMean = zeros(size(x));
    camberGrad = zeros(size(x));
else 
    yMean = NaN(size(x));
    yMean(x <= p) = m/p^2 .* (2*p*x(x <= p) - x(x <= p).^2);
    yMean(x > p) = m/(1-p)^2 .* ((1-2*p) + 2*p*x(x > p) - x(x > p).^2);

    camberGrad = NaN(size(x));
    camberGrad(x <= p) = 2*m/p^2 .* (p - x(x <= p));    % d(yMean)/dx. 
    camberGrad(x > p) = 2*m/(1-p)^2 .* (p - x(x > p));
end

%% Combine mean camber line coords. 
meanCamber = [x' yMean'];

%% Calculate half-thickness yT. 
yT = 5*t*(0.2969*sqrt(x) - 0.1260*x - 0.3516*x.^2 + 0.2843*x.^3 - 0.1036*x.^4);

theta = atan(camberGrad);   % Angle from chord line. 
upperSurface = [x - yT.*sin(theta); yMean + yT.*cos(theta)]';
lowerSurface = flip([x + yT.*sin(theta); yMean - yT.*cos(theta)]');
panelBoundary = [lowerSurface ; upperSurface(2:end,:)];