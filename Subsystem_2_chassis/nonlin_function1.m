%% Completing Linear Regression


function [model_d, model_vms] = nonlin_function1(Input, Output, VMS)
%New index order for data sets randon seed 1
rng(1);
newInd = randperm(length(Output));

%Reordered input and output
new_input = Input(newInd, :); 
new_output = Output(newInd, :);
%Vector definition for model fitting
vec_d = new_output(:,3);
vec_vms = new_output(:,2);


%Split point one:  
split_pt1 = floor(0.75*length(Output));
input_train1 = new_input(1:split_pt1, :)
output_train1 = new_output(1:split_pt1, :)
input_test1 = new_input(split_pt1+1:end, :)
output_test1 = new_output(split_pt1+1:end, :)

%normalising 1 wrt training set
[input_train1,PS_in_Train1] = mapstd(new_input(1:split_pt1, :)');
[output_train1,PS_out_Train1] = mapstd(new_output(1:split_pt1, :)');

input_test1 = mapstd('apply',new_input(split_pt1+1:end, :)', PS_in_Train1);
output_test1 = mapstd('apply',new_output(split_pt1+1:end, :)', PS_out_Train1);
%-------------------------------------------------------------------------

beta0 = [1 1 1];

%% Subsystem -  Model for displacement
modelfun = @(b,x)(b(:,1)./(x(:,3)) + b(2).*(x(:,1)) + b(3))
model_d = fitnlm(new_input, vec_d, modelfun, beta0)
%model_d = polyfit(new_input, new_output, 3)
%md = string(model_d)
[model_d.RMSE min(Output(:,3)) max(Output(:,3))]
%% Uncomment to see the residuals of the model
%plotResiduals(model_d)
%figure
%plotDiagnostics(model_d,'cookd')
figure
new_output(:,3);
ypred = feval(model_d, new_input);
[input_test_th, t] = sort(new_input(:,3)) ;
ypred = ypred(t);
output_test_th = new_output(t,3)  ;
[output_test_th, t] = sort(new_output(:,2)) ;
a = input_test_th;
class(a);
scatter(output_test_th, input_test_th);
hold on
plot(ypred, input_test_th) ;
hold off
xlabel('Thickness (mm)')
ylabel('Displacement (mm)')
figure

%% VMS 
modelfun1 = @(b,x)(b(:,1)./(x(:,3)) + b(2).*(x(:,1)) + b(3))
model_vms = fitnlm(new_input, vec_vms, modelfun1, beta0);
%model_vms = polyfit(new_input, new_output, 3)
[model_vms.RMSE min(Output(:,2)) max(Output(:,2))];
%plotResiduals(mdlVMS);
%plotDiagnostics(mdlVMS,'cookd');
figure
ypred = feval(model_vms, new_input);
ypred = ypred(t);
scatter(new_output(t,2), input_test_th(:,2));
xlabel('Thickness (mm)')
ylabel('VMS(N/mm^2)')
hold on
plot(ypred, input_test_th) ;
hold off
end 