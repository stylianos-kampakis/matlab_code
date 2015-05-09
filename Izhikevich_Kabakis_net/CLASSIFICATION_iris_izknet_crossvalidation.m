close all
total_iterations=5;
time=[];
all_training_results=[];
all_total_results=[];
all_test_results=[];
total_epochs=[];

results_untrained=[];
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

options_for_training=pure_train_optionset('Epochs', 10, ...
'Inhibitory','true', ...
'Excitatory','true', ...
'Inhibitory_function','purelin', ...
'Excitatory_function','purelin', ...
'Inhibitory_momentum',0.1, ...
'Excitatory_momentum',0.1, ...
'Inhibitory_momentum_degradation',0, ...
'Excitatory_momentum_degradation',0, ...
'Inhibitory_learning_rate',0, ...
'Excitatory_learning_rate',0, ...
'Target_success',0.96, ...
'Randomize_batch','true', ...
'Renew_weights','false',...
'Epochs_for_renewal',3,...
'Discrepancy_inhibition',0,...
'Discrepancy_excitation',1,...
'Discrepancy_inhibition_degradation',1,...
'Discrepancy_excitation_degradation',0);


options=izknet_optionset('Number_of_inputs',2,'ms',15,'Std_constant',2.5 ...
    ,'Voltage_sent',60,'Amplifier',30,'Initialization','zeros');




for iterations=1:total_iterations
    disp(['Iteration number: ' num2str(iterations)]);



[folds positions]=sample_rand(irisp,150,[],[],1);
irisp=irisp(:,positions);
irist=irist(:,positions);


net=izknet([6 3],options);

net.sensor_parameters(:,2)=[0.06;0.0786;0.5104;0.5587;0.7740;0.8151];

for strat=1:10
    strat
first=(strat-1)*15+1;
finish=strat*15;
testing_data=folds(:,first:finish);
training_data=folds;
training_data(:,first:finish)=[];
targets=irist;
targets(:,first:finish)=[];

tic
[net_iris,~, training_results,time2]=pure_train_izknet_final(net,training_data,targets,options_for_training)
time=[time toc];

total_epochs=[total_epochs numel(training_results)];


%Test for generalization on the unseen instances

targets=irist(:,first:finish);
results_untrained=[results_untrained evaluate_success(testing_data,targets,net_iris)];
%testing_accuracy=[testing_accuracy mean(results_untrained)];
training_accuracy=[training_accuracy training_results(numel(training_results))];



end

end


mean(results_untrained)
mean(training_accuracy)
