function [meanCamber, camberGrad] = generateNaca4(NACA, N)

% TODO COMMENT
% Syntax: [meanCamber, camberGrad] = generateNaca4(NACA, N).

m = str2double(NACA(1)) / 100;     % Max camber. 
p = str2double(NACA(2)) / 10;    % Position of max camber. 
%t = str2double(NACA(3:4)) / 100;  % Thickness. 

% Generate mean camber line x-coords for cosine distribution. 
a = linspace(0,pi,ceil(N/2)+1);   % N/2 for upper and lower surfaces. 
x = (1 - cos(a))./2;

% Generate mean camber line yMean and camber gradient camberGrad. 
if m == 0 || p == 0
    yMean = zeros(size(x));
    grad = zeros(size(x));
else 
    yMean = NaN(size(x));
    yMean(x <= p) = m/p^2 .* (2*p*x(x <= p) - x(x <= p).^2);
    yMean(x > p) = m/(1-p)^2 .* ((1-2*p) + 2*p*x(x > p) - x(x > p).^2);

    grad = NaN(size(x));
    grad(x <= p) = 2*m/p^2 .* (p - x(x <= p));    % d(yMean)/dx. 
    grad(x > p) = 2*m/(1-p)^2 .* (p - x(x > p));
end

% Combine mean camber line coords. 
meanCamber = [x' yMean'];
camberGrad = [x' grad'];

% Calculate half-thickness yT. 
% yT = 5*t*(0.2969*sqrt(x) - 0.1260*x - 0.3516*x.^2 + 0.2843*x.^3 - 0.1036*x.^4);
% 
% theta = atan(camberGrad);   % Angle from chord line. 
% upperSurface = [x - yT.*sin(theta); yMean + yT.*cos(theta)]';
% lowerSurface = flip([x + yT.*sin(theta); yMean - yT.*cos(theta)]');
% panelBoundary = [lowerSurface ; upperSurface(2:end,:)];