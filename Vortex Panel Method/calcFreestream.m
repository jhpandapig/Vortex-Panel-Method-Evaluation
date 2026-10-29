function [U,V] = calcFreestream(AoA)
% Returns components of freestream velocity in coordinate frame aligned
% with the chord line. 
%
% SYNTAX: 
%   [U,V] = calcFreestream(AoA)
%
% INPUT: 
%   AoA - angle of attack (rads) 
%
% OUTPUT: 
%   U - scalar x-component of freestream velocity
%   V - scalar y-component of freestream velocity 

U = cos(AoA);
V = sin(AoA);