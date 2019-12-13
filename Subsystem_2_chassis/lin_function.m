%Linear function for R^2 values and function fitting for mass

function [beta_m, beta_vms, beta_d] = lin_function(Input, output)
%New index order for data sets randon seed 1
rng(1);
newInd = randperm(length(output));

%Reordered input and output
new_input = Input(newInd,:);
new_output = output(newInd,:);

%Split point one: 75% 25% 
split_pt1 = floor(0.75*length(output));

input_train1 = new_input(1:split_pt1, :)
output_train1 = new_output(1:split_pt1, :) 
input_test1 = new_input(split_pt1+1:end, :)
output_test1 = new_output(split_pt1+1:end, :)

%normalising 1 wrt training set
%[input_train1,PS_in_Train1] = mapstd(new_input(1:split_pt1)');
%[output_train1,PS_out_Train1] = mapstd(new_output(1:split_pt1)');
%input_test1 = mapstd('apply',new_input(split_pt1+1:end)',PS_in_Train1);
%output_test1 = mapstd('apply',new_output(split_pt1+1:end)',PS_out_Train1);

%Linear regression for mass
beta_m = mvregress(input_train1, output_train1(:,3))
rsq_m = 1 - norm(input_test1*beta_m - output_test1(:,3))^2/norm(output_test1(:,3)'-mean(input_test1)')^2
model_m = fitlm(input_train1,output_train1(:,3))

%Linear regression for VMS
beta_vms = mvregress(input_train1, output_train1(:,1))
rsq_vms = 1 - norm(input_test1*beta_m - output_test1(:,1))^2/norm(output_test1(:,1)'-mean(input_test1)')^2
model_vms = fitlm(input_train1,output_train1(:,1))

%Linear regression for Displacement
beta_d = mvregress(input_train1, output_train1(:,2))
rsq_d = 1 - norm(input_test1*beta_m - output_test1(:,2))^2/norm(output_test1(:,2)'-mean(input_test1)')^2
model_d = fitlm(input_train1,output_train1(:,2))
end