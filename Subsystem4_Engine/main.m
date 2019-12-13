clear
clc
close all

tic
% test starting values - change xvalue in fmincon solver below
x0 = [65,59,8000,14.9]; % Bailey V5 engine
x1 = [99,99,9999,19.9]; % upper bound limit
x2 = [21,21,501,12.1]; % lower bound limit
x3 = [54,45,9200,14.9]; % EOS 100 engine
x4 = [61,52.5,9000,14.9]; % EOS 150 ICI mod. 2019 engine
x5 = [66,53,7700,14.9]; % Minari F1 ME9C engine
x6 = [66,56.8,8000,14.9]; % Minari F1 Pro F1-M9-Cl-F engine
x7 = [70,60,8000,14.9]; % Simonini Mini 2 EVO engine
x8 = [82,76,6200,14.9]; % Simonini Victor 1 Super engine
x9 = [58,52,8400,14.9]; % Simonini Colbri engine
x10 = [73,64,7500,14.9]; % Air Conception Tornado 280 engine
x11 = [47.6,44,9500,14.9]; % Vittorazi Atom 80 engine
x12 = [50,44,10000,14.9]; % Macfly 80 engine (original RPM 10450)
x13 = [64,60,7400,14.9]; % Polini Thor 190 engine
x14 = [70,61,8000,14.9]; % Cors-Air Black Bull engine
A = [];
B = [];
Aeq = [];
Beq = [];
lb = [20, 20, 500, 12];
ub = [100, 100, 10000, 20];

options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');
[x,fval,output]=fmincon('obj',x3,A,B,Aeq,Beq,lb,ub,'nonlcon',options);

disp(x)
disp(fval)

toc