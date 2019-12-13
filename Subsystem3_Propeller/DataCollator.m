clc
clear all

%{
The following code extracts values from independtn .csv files and compiles
them for use in the Optimatorinator.m file. Few relevant varialbes are used
throughout this code and are abbreviated as specified:
Maximum Camber (m)
Camber Position (p)
Maximum Thickness (t)
Reynolds Number (Re)
Angle of attack (a)
Coefficient of Lift (Cl)
Coefficient of Drag (Cd)
%}

% the codes for the set of downloaded aerofoil data explained in
% reference (12) of the report. The terms in each code are ordered 
% as m p t so for the first aerofiol m = 0, p = 0, t = 6
naca4 = [0 0 06; 0 0 08; 0 0 09; 0 0 10; 0 0 12; 0 0 15;
    0 0 18; 0 0 21; 0 0 24; 1 4 08; 1 4 10; 1 4 12; 2 4 08;
    2 4 10; 2 4 11; 2 4 12; 2 4 14; 2 4 15; 2 4 18; 2 4 21;
    2 4 24; 4 4 12; 4 4 15; 4 4 18; 4 4 21; 4 4 24; 6 4 09; 6 4 12];

naca4 = naca4.'; % matrix transposed for compilation

% set of reynolds numbers tested with each aerofoil
reynoset = [1000000 500000 200000 100000 50000];

cldata = [];
cddata = [];

% parses through and compiles each data source into cldata and cddata
for foil = naca4
    f = string(foil);
    if strlength(f(3)) < 2
        f(3) = strcat('0', f(3));
    end
    for rey = reynoset
        r = string(rey);
        file = strcat('xf-naca', f(1), f(2), f(3), '-il-', r, '-n5.csv');
        data = readmatrix(file).';
        for point = data
            clpoint = [foil(1) foil(2) foil(3) rey point(1) point(2)];
            cdpoint = [foil(1) foil(2) foil(3) rey point(1) point(3)];
            cldata = vertcat(cldata, clpoint);
            cddata = vertcat(cddata, cdpoint);
        end
    end
end

% the compiled data is written to a file such that the each data point
% (row) includes a value for each parameter. The columns are ordered as
% | m | p | t | Re | a | Cl or Cd |
writematrix(cldata, 'CoefficientofLift.csv');
writematrix(cddata, 'CoefficientofDrag.csv');

