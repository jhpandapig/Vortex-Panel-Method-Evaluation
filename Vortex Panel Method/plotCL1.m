function plotCL1(airfoil, AoA)
% Plot CL-AoA on current figure using method 1. 
%
% SYNTAX:
%   plotCL1(airfoil, AoA)
%
% INPUT: 
%   airfoil struct
%   AoA - scalar angle of attack (rads)

[CL,~] = calcCL_CM1(airfoil,AoA);

hold on
plot(AoA .* 180 ./ pi, CL)