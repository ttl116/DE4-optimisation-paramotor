clc
clear all

%{
The following code runs an optimisaiton function linking the efficiencty of
a propeller blade to it's cross section geometry. The variables used are as
described below:
x(1) Coefficient of Lift
x(2) Pitch Angle
x(3) Coefficient of Drag
x(4) Forward Velocity
x(5) Radius at Cross Section
x(6) Angular Velocity
x(7) Maximum Camber
x(8) Camber Position
x(9) Maximum Thickness
x(10) Reynolds Number
x(11) Angle of Attack
%}

eff = @(x) ((x(1)*cos(x(2)) - x(3)*sin(x(2))) * x(4)) / ...
    (((x(1)*sin(x(2)) + x(3)*cos(x(2))) * x(5)) * x(6));
% paramotor efficiency formulated as equation 7 in the report

x0 = [0.5 1 0.5 1 1 1 1 1 1 1 1]; %arbitrary starting points within bounds
A = []; 
b = []; % no inequality constriants specified (as in the report)
Aeq = [0 1 0 0 0 0 0 0 0 0 0;
    0 0 0 1 0 0 0 0 0 0 0;
    0 0 0 0 0 4/6 0 0 0 0 0];
beq = [pi/4 13.4 1.24]; 
% equality constraints based on assumptions in the report
lb = [0 0 0 0 0 0 0 0 0 0 -15];
ub = [1 pi 1 20 50 1 9.5 9 40 10000000 15]; 
% lower and upper bounds detrmeined by 
% logical reason and limits set in the NACA database
nonlcon = @cons;
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');

x = fmincon(eff,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

function [c,ceq] = cons(x)
    cldata = readmatrix('CoefficientofLift.csv');
    cddata = readmatrix('CoefficientofDrag.csv');

    indvar = cldata(:, 1:5);
    cldepvar = cldata(:, 6);
    cddepvar = cddata(:, 6);
    %extraction and partitioning of test data

    clm = polyfitn(indvar, cldepvar, 2);
    cdm = polyfitn(indvar, cddepvar, 2);
    %creation of non-linear models in mutliple dimensions using polyfitn
    
    cleq = @(x) 0;
    cdeq = @(x) 0;

    for term = 1:21
        clterm = @(x) x(7)^clm.ModelTerms(term, 1) * x(8)^clm.ModelTerms(term, 2) * ...
            x(9)^clm.ModelTerms(term, 3) * x(10)^clm.ModelTerms(term, 4) * ...
            x(11)^clm(term, 5) * clm.Coefficients(term);
        cdterm = @(x) x(7)^clm.ModelTerms(term, 1) * x(8)^clm.ModelTerms(term, 2) * ...
            x(9)^clm.ModelTerms(term, 3) * x(10)^clm.ModelTerms(term, 4) * ...
            x(11)^clm(term, 5) * clm.Coefficients(term);
        cleq = @(x) cleq(x) + clterm(x);
        cdeq = @(x) cdeq(x) + clterm(x);
    end
    % conversion of polyfitn models into equations for use in fmincon()
    
    ceq = {@(x) cleq(x) - x(1), @(x) cdeq(x) - x(2)};
    c = [];
    % declaration of non-linear constraints
end