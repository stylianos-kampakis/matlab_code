%%
%Initialize the variables
close all
clear all
total_iterations=100;
time=[];
all_training_results=[];
all_total_results=[];
all_test_results=[];
total_epochs=[];


testing_accuracy=[];
training_accuracy=[];

%Create the dataset
[irisp irist]=iris();

sepal_length=normalize_data(irisp(1,:));
sepal_width=normalize_data(irisp(2,:));
petal_length=normalize_data(irisp(3,:));
petal_width=normalize_data(irisp(4,:));

%We use only the features that have been found to be relevant
irisp=[petal_length;petal_width];

%Set the options for the network and the training
options_for_training=pure_train_optionset_final('Epochs', 100, ...
'Target_success',0.96, ...
'Randomize_batch','true');


options=izknet_optionset('Number_of_inputs',2,'ms',15,'Std_constant',2.5 ...
    ,'Voltage_sent',60,'Amplifier',30,'Initialization','zeros');


%%
for iterations=1:total_iterations
    disp(['Iteration number: ' num2str(iterations)]);



[folds positions]=sample_rand(irisp,150,[],[],1);
irisp=irisp(:,positions);
irist=irist(:,positions);

%initialize the network
net=izknet([6 3],options);
%Set the parameters to the same settings as in Kampakis (2011)
net.sensor_parameters(:,2)=[0.06;0.0786;0.5104;0.5587;0.7740;0.8151];

%Each strat is one fold
for strat=1:10
    %display the fold we are in
    strat
first=(strat-1)*15+1;
finish=strat*15;
testing_data=folds(:,first:finish);
training_data=folds;
training_data(:,first:finish)=[];
targets=irist;
targets(:,first:finish)=[];


[net_iris,~, training_results,time2]=pure_train_izknet_final(net,training_data,targets,options_for_training)
net_iris=izknet([6 3],options);;
total_epochs=[total_epochs numel(training_results)];

%Test for generalization on the unseen instances

targets=irist(:,first:finish);
testing_accuracy=[testing_accuracy evaluate_success(testing_data,targets,net_iris)];
training_accuracy=[training_accuracy training_results(numel(training_results))];

end

end

