%% Completing Linear Regression


function [model_d, model_vms] = nonlin_function2(Input, Output, VMS)
%New index order for data sets randon seed 1
rng(1);
newInd = randperm(length(Output));

%Reordered input and output
new_input = Input(newInd, :); 
new_output = Output(newInd, :);


%Split point one:  
split_pt1 = floor(0.75*length(Output));
input_train1 = new_input(1:split_pt1, :);
output_train1 = new_output(1:split_pt1, :);
input_test1 = new_input(split_pt1+1:end, :);
output_test1 = new_output(split_pt1+1:end, :);

%normalising 1 wrt training set
%[input_train1,PS_in_Train1] = mapstd(new_input(1:split_pt1, :)');
%[output_train1,PS_out_Train1] = mapstd(new_output(1:split_pt1, :)');

%input_test1 = mapstd('apply', new_input(split_pt1+1:end, :)', PS_in_Train1);
%output_test1 = mapstd('apply', new_output(split_pt1+1:end, :)', PS_out_Train1);
%-------------------------------------------------------------------------

beta0 = [1 1 1];

%% Model for displacement
modelfun = @(b,x)(b(:,1)./(x(:,3)) + b(2).*(x(:,2)) + b(3));
model_d = fitnlm(input_train1, output_train1(:,3), modelfun, beta0);
[model_d.RMSE min(Output(:,3)) max(Output(:,3))];

figure
ypred = feval(model_d, input_test1);
[input_test_th, t] = sort(input_test1(:,3)) ;
ypred = ypred(t);
output_test_th = output_test1(t,3);
[output_test_th, t] = sort(new_output(:,2)) ;
class(input_test_th);
scatter(output_test_th, input_test_th);
hold on
plot(ypred, input_test_th) ;
hold off
xlabel('Thickness (mm)')
ylabel('Displacement (mm)')

%% VMS 
modelfun = @(b,x)(b(:,1)./(x(:,3)) + b(2).*(x(:,2)) + b(3));
model_vms = fitnlm(input_train1, output_train1(:,2), modelfun, beta0);
[model_vms.RMSE min(Output(:,2)) max(Output(:,2))];

figure
ypred = feval(model_vms, input_test1);
ypred = ypred(t);
scatter(new_output(t,1), input_test_th(:,2));
xlabel('Thickness (mm)')
ylabel('VMS(N/mm^2)')
hold on
plot(ypred, input_test_th) ;
hold off
end 