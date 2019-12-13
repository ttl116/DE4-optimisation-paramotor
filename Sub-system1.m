%-- design variables --%
% b = x(1)    
% c = x(2)  
% No = x(3) 
%-- Parameters --%
% LDr = x(4)
% AOA = x(5)
% v = x(6)
% Mp = x(7) 
% h = x(8)
% Rb = x(9)
%-- Line choice values --%
% d = x(10)
% BL = x(11)        
% wpml = x(12)
% cpml = x(13)
%-- Wing choice values --%
% wpmw = x(14)
% cpmw = x(15)


% Monotonicity analysis of b,c with respect to g1,g2
%b with respect to g1
b = linspace(5,50);
szb = size(b);
Lenb = szb(2);
y1 = [];
for i = 1:Lenb;
    val = ((120+(((2*((b(i)*2*pi)/4))+(40*0.4*2))*0.038)+(20*0.8*b(i)*0.00067))*9.81)-((2*pi*0.122)/(1+((2*pi*2/(4*b(i))))))*(0.5*1.22*13.4^2*((pi*2*b(i))/4));
    b(i);
    y1(i) = val;
end
figure
plot(b,y1)
ylabel('g1') 
xlabel('b') 
title('b with respect to g1')

%c with respect to g1
c = linspace(1,20);
szc = size(c);
Lenc = szc(2);
y2 = [];
for i = 1:Lenc;
    val = ((120+(((2*((10*c(i)*pi)/4))+(40*0.4*c(i)))*0.038)+(20*0.8*10*0.00067))*9.81)-((2*pi*0.122)/(1+((2*pi*c(i)/(4*10)))))*(0.5*1.22*13.4^2*((pi*c(i)*10)/4));
    c(i);
    y2(i) = val;
end
figure
plot(c,y2)
ylabel('g1') 
xlabel('c')
title('c with respect to g1')

%b with respect to g2
b2 = linspace(1,50);
szb2 = size(b2);
Lenb2 = szb2(2);
y4 = [];
for i = 1:Lenb2;
    val = 4 -((2*pi*0.122)/(1+((2*pi*2/(4*b2(i))))))/((0.015+(0.5*(0.4/2)))+(((((2*pi*0.122)/(1+((2*pi*2/(4*b2(i))))))^2)*2)/(4*b2(i)))+((4*20*0.8*b2(i)*0.002)/(pi*2*b2(i)))+((4*0.75*0.6)/(pi*2*b2(i))));
    b2(i);
    y4(i) = val;
end
figure
plot(b2,y4)
ylabel('g2') 
xlabel('b') 
title('b with respect to g2')

%c with respect to g2
c2 = linspace(1,20);
szc2 = size(c2);
Lenc2 = szc2(2);
y5 = [];
for i = 1:Lenc2;
    val = 4-((2*pi*0.122)/(1+((2*pi*c2(i)/(4*10)))))/((0.015+(0.5*(0.4/c2(i))))+(((((2*pi*0.122)/(1+((2*pi*c2(i)/(4*10)))))^2)*c2(i))/(4*10))+((4*20*0.8*10*0.002)/(pi*c2(i)*10))+((4*0.75*0.6)/(pi*c2(i)*10)));
    c2(i);
    y5(i) = val;
end
figure
plot(c2,y5)
ylabel('g2') 
xlabel('c') 
title('c with respect to g2')


%Initial optimisation (fmincon for 60 material combinations)
M = readmatrix('Lines.xlsx');
szM = size(M);
LenM = szM(1);

N = readmatrix('wingmaterials.xlsx');
szN = size(N);
LenN = szN(1);

pt = LenN*LenM;
Solutions = zeros(pt,6);

for c = 1:LenN
    for s = 1:LenM
        y = runfmincon(s,c,M,N,5);
        val = ((c-1)*20)+s;
        Solutions(val,1) = c;
        Solutions(val,2) = s;
        Solutions(val,3) = y(1);
        Solutions(val,4) = y(2);
        Solutions(val,5) = y(3);
        Solutions(val,6) = (((2*((y(1)*y(2)*pi)/4))+(40*y(8)*y(2)))*y(15))+(y(3)*y(9)*y(1)*y(13));
    end 
end

%plot of optimal solutions 
for z = 1:20 
    Lm(z) = Solutions(z,2);
    C1(z) = Solutions(z,6);
    C2(z) = Solutions(z+20,6);
    C3(z) = Solutions(z+40,6);
end
figure 
plot(Lm,C1,Lm,C2,Lm,C3)
title('Minimum cost for different material combinations')
ylabel('Cost ($)') 
xlabel('Line material choice') 
legend({'Wing material 1','Wing material 2','Wing material 3'},'Location','northwest')


%Post-optimal analysis 
outputs = []
for AR = 1:12
    y = runfmincon(10,3,M,N,AR);
    output = (((2*((y(1)*y(2)*pi)/4))+(40*y(8)*y(2)))*y(15))+(y(3)*y(9)*y(1)*y(13));
    outputs(AR) = output;
end

xAR = (1:12);
figure 
plot(xAR,outputs)
title('Affect of Aspect ratio on cost')
ylabel('Cost ($)') 
xlabel('Aspect Ratio') 

%ParetoSet
fun = @(x)[(((2*((x(1)*x(2)*pi)/4))+(40*0.4*x(2)))*7.9)+(x(3)*0.8*x(1)*1.15); -1*((2*pi*0.122)/(1+((2*pi*x(2)/(4*x(1))))))/((0.015+(0.5*(0.4/x(2))))+(((((2*pi*0.122)/(1+((2*pi*x(2)/(4*x(1))))))^2)*x(2))/(4*x(1)))+((4*x(3)*0.8*x(1)*0.00095)/(pi*x(2)*x(1)))+((4*0.75*0.6)/(pi*x(2)*x(1))))];
A = [];
b = [];
Aeq = [];
beq = [];
lb = [5 1 10];
ub = [20 10 30];
nonlcon = @nonlinear26;
%Maxgenerations reduced for running time but 1000 used for max accuracy during report
opts_ga = optimoptions('gamultiobj','MaxGenerations',400,'ParetoFraction',0.6,'FunctionTolerance',1e-4,'MaxStallGenerations',200,'PlotFcn','gaplotpareto');
rng default % For reproducibility
[x,fval,exitflag,output,population,scores] = gamultiobj(fun,3,A,b,Aeq,beq,lb,ub,nonlcon,opts_ga);

%Optimal solution optimisers
fprintf('Optimsiers and objective - Wing material, Line material, span, chord, number of lines, Cost')
disp(Solutions(50,:))
