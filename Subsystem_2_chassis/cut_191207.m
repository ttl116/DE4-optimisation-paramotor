close all
clear
clc

% Inputs into Solidworks
% All Input & output units:
% Length | mm , Width | mm ,Thickness | mm 
% VMS | Pa , Disp | mm , Mass | kg
%To remember - load the right workspace, units of table vs .mat, double %
%means new section,

%
% Latin hypercube sampling
p = 25 ;  % Points
N = 3  ; % Dimensions
% Bounds
lb = [1000 800 40]; % lower bounds for Length(x1), Width(x2), Thickness(x3)
ub = [1500 1200 49.5]; % upper bounds for Length(x1), Width(x2), Thickness(x3)

%Formula below used to generate samples for solidworks study - results
%found in Input LHS or in the transposed matrix from MatLab workspace
X = lhsdesign(p,N,'criterion', 'correlation'); % criterion & correlation for equal distribution
InputLHS = bsxfun(@plus,lb,bsxfun(@times,X,(ub-lb)));
%These values were then exported to solidworks to a design study
%varibles input == InputLHS

%
load('141219.mat');
load 'input15'
load 'steel'
load 'al'
load 'ti'
load 'cf'
%

%format: [thickness width curvewidth length]
Input = double(input15) ;

% format: [VMS Displacement Mass]
Steel = double(steel);
Aluminium = double(al);
Titanium = double(ti);
Carbon_Fibre = double(cf);


%Cost data:[Steel Al Ti CF]
Cost = [0.837 2.57 44.1 84 ];

%Material yield data: [Steel Al Ti CF]
Yield = [2.4E+8 9.5E+7 7.3E+8 2.3E+7 ];

% Linear testing:
[Steel_lMass, Steel_lVMS, Steel_lDisp] = lin_function(Input, Steel); 
[Al_lMass, Al_lVMS, Al_lDisp] = lin_function(Input, Aluminium);
[Ti_lMass, Ti_lVMS, Ti_lDisp] = lin_function(Input, Titanium);
[CF_lMass, CF_lVMS, CF_lDisp] = lin_function(Input, Carbon_Fibre);

% %NON LINEAR FUNCTION EXCLUSION *ran & still on github* 
% Nonlinear methods were excluded, due to a limited data sample and
% difficulty function fitting - an aspect that if developed may improve the
% optimisation results.

[Steel_nlD, Steel_nlVMS] = nonlin_function2(Input, Steel, Yield(1));
[Al_nlD, Al_nlVMS] = nonlin_function2(Input, Aluminium, Yield(2));
[Ti_nlD, Ti_nlVMS] = nonlin_function2(Input, Titanium, Yield(3));
[CF_nlD, CF_nlVMS] = nonlin_function2(Input, Carbon_Fibre, Yield(4));
%% using linear results as non linear not obtained
o_steel = table2array(Steel_lMass.Coefficients(:,1))
o_al = table2array(Al_lMass.Coefficients(:,1));
o_ti = table2array(Ti_lMass.Coefficients(:,1));
o_cf = table2array(CF_lMass.Coefficients(:,1));
ov_steel = table2array(Steel_lVMS.Coefficients(:,1));
ov_al = table2array(Al_lVMS.Coefficients(:,1));
ov_ti = table2array(Ti_lVMS.Coefficients(:,1));
ov_cf = table2array(CF_lVMS.Coefficients(:,1));
d_steel = table2array(Steel_lDisp.Coefficients(:,1));
d_al = table2array(Al_lDisp.Coefficients(:,1));
d_ti = table2array(Ti_lDisp.Coefficients(:,1));
d_cf = table2array(CF_lDisp.Coefficients(:,1));

% Optimisation of materials
[MinSteel, SQP_Steel, SQPG_Steel, IP_Steel, GIP_Steel] = opt_function( Cost(1), Yield(1), o_steel, ov_steel, d_steel);
[MinAl, SQP_Al, SQPG_Al, IP_Al, GIP_Al] = opt_function( Cost(2), Yield(2),  o_al, ov_al, d_al);
[MinTi, SQP_Ti, SQPG_Ti, IP_Ti, GIP_Ti] = opt_function( Cost(3), Yield(3), o_ti, ov_ti, d_ti);
[MinCF, SQP_CF, SQPG_CF, IP_CF, GIP_CF] = opt_function( Cost(4), Yield(4), o_cf, ov_cf, d_cf);

% Displaying solution
disp('Solution for Steel Alloy')
disp(['Cost = ' num2str(MinSteel(6))])
disp(['Mass =' num2str(MinSteel(5))])
disp(['Measurements =' num2str(MinSteel(1:4))])
disp('Solution for Aluminium 1060')
disp(['Cost = ' num2str(MinAl(6))])
disp(['Mass =' num2str(MinAl(5))])
disp(['Measurements =' num2str(MinAl(1:4))])
disp('Solution for Titanium Alloy')
disp(['Cost = ' num2str(MinTi(6))])
disp(['Mass =' num2str(MinTi(5))])
disp(['Measurements =' num2str(MinTi(1:4))])
disp('Solution for Carbon Fibre')
disp(['Cost = ' num2str(MinCF(6))])
disp(['Mass =' num2str(MinCF(5))])
disp(['Measurements =' num2str(MinCF(1:4))])
