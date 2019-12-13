function x = runfmincon(S,C,M,N,AR)

LDr = 4;
AOA = 0.122;
v = 13.4;
Mp = 120;
h = 0.4;
Rb = 0.8;

%Line variables%
d = M(S,2);
BL = M(S,3);
wpml = M(S,4);
cpml = M(S,5);
%Wing Variables%
wpmw = N(C,2);
cpmw = N(C,3);

fun = @(x)(((2*((x(1)*x(2)*pi)/4))+(40*x(8)*x(2)))*x(15))+(x(3)*x(9)*x(1)*x(13));
x0 = [20 7 100 LDr AOA v Mp h Rb d BL wpml cpml wpmw cpmw];
A = [4,-AR*pi,0,0,0,0,0,0,0,0,0,0,0,0,0];
b = [0];
Aeq = [0,0,0,1,0,0,0,0,0,0,0,0,0,0,0;0,0,0,0,1,0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,1,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,1,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,1,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,1,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,1,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0,1,0,0,0,0;0,0,0,0,0,0,0,0,0,0,0,1,0,0,0;0,0,0,0,0,0,0,0,0,0,0,0,1,0,0;0,0,0,0,0,0,0,0,0,0,0,0,0,1,0;0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
beq = [LDr;AOA;v;Mp;h;Rb;d;BL;wpml;cpml;wpmw;cpmw];
lb = [];
ub = [];
nonlcon = @nonlinear25;
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
%Solving the optimization problem
x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

end