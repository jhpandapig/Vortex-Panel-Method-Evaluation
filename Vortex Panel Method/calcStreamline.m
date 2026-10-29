function streamline = calcStreamline(xStart, yStart, bounds,airfoil,AoA,vss)

% Calculates streamline coordinates. Note: stepsize varies near the airfoil
% and further out. 
% 
% SYNTAX: 
%   streamline = calcStreamline(xStart, yStart, bounds,airfoil,AoA,vss)
%   
% INPUT:
%   xStart - starting x-coordinate
%   yStart - starting y-coordinate
%   bounds - (:,2) matrix defining the vertices of a polygonal boundary
%   (streamline calculation terminates outside the boundary)
%   airfoil - airfoil struct
%   AoA - angle of attack (rads)
%   vss - list of vortex sheet strengths
%
% OUTPUT: 
%   streamline - (:,2) matrix containing coordinates of streamline in
%   coordinate frame aligned with the chord line. 


dsInner = 10^-3; % Lower limit step size.
dsOuter = 1; % Upper limit step size. 
 
rInner = 1; % Furthest radius away from (0.5,0) at which ds = dsInner. 
rOuter = 3; % Closest radius at which ds = dsOuter

maxIteration = 10000;
streamline = NaN(maxIteration,2);
streamline(1,:) = [xStart yStart];    % Position. 


i = 1;
while inpolygon(streamline(i,1), streamline(i,2), bounds(:,1), bounds(:,2)) && i<=maxIteration
    % Calculate velocity at current position along streamline. 
    [U,V] = calcVelocityField(streamline(i,1),streamline(i,2),airfoil,AoA,vss);
    u = [U V];  

    % Calculate step size ds. 
    ds = calcStepSize(streamline(i,:));
    dr = ds .* u ./ norm(u);
    streamline(i+1,:) = streamline(i,:) + dr;
    i = i + 1;
end

streamline = streamline(1:i,:);

% axis(axis)
% hold on
% plot(streamline(:,1), streamline(:,2));

function ds = calcStepSize(position)
% INPUT: (1,2) matrix containing coordinates of current position. 
r = hypot(position(1) - 0.5, position(2));
if r < rInner
    ds = dsInner;
elseif r > rOuter
    ds = dsOuter;
else
    ds = dsInner + (dsOuter-dsInner) * (r - rInner) / (rOuter-rInner);
end
end
end