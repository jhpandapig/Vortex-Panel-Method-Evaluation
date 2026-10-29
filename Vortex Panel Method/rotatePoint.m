function newA = rotatePoint(A, angle)
% INPUT: (n,2) matrix containing coordinates, CCW angle of rotation in rads. 
% Returns (n,2) matrix containing rotated coordinates. 
% Syntax: newA = rotate(A, angle)

% Returns coordinates of rotated point. 
%
% SYNTAX: 
%   newA = rotatePoint(A, angle)
%
% INPUT: 
%   A - (1,2) matrix of point's coordinates
%   angle -  angle of CCW rotation (rads)
%
% OUTPUT
%   newA - (1,2) matrix of rotated point's coordinates

R = [cos(angle) sin(angle); -sin(angle) cos(angle)];
newA = A * R;