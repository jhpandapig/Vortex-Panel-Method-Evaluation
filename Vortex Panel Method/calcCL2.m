function CL = calcCL2(airfoil,AoA)
% Calculates lift coefficient by summing total circulation and
% Kutta-Joukowski Theorem. This is the principal method for this method. 
%
% SYNTAX: 
%   CL = calcCL2(airfoil,AoA)
%
% INPUT: 
%   airfoil - airfoil struct
%   AoA - list of AoA (rads)
%
% OUTPUT: 
%   CL - list of lift coefficients

CL = NaN(size(AoA));

for i = 1:length(AoA)
    vss = calcVSS(airfoil,AoA(i));
    circulation = 0;
    for j = 1: airfoil.N
        circulation = circulation - (vss(j) + vss(j+1))./2 .* airfoil.panelLength(j);
    end
    CL(i) = 2 * circulation;
end