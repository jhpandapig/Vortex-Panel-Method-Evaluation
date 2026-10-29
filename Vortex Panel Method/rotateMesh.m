function [rotX, rotY] = rotateMesh(X, Y, angle)

% Returns rotated X and Y meshgrid. 
%
% SYNTAX:
%   [rotX, rotY] = rotateMesh(X, Y, angle)
%
% INPUT:
%   X - meshgrid of x-coords
%   Y - meshgrid of y-coords
%   angle - angle of CCW rotation (rads)
%
% OUTPUT:
%   rotX - meshgrid of rotated x-coords
%   rotY - meshgrid of rotated y-coords

rotX = cos(angle) .* X - sin(angle) .* Y;
rotY = sin(angle) .* X + cos(angle) .* Y;
