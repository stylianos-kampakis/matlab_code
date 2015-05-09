%%
close all
clear all
total_epochs=[];

testing_accuracy=[];
training_accuracy=[];

options=izknet_optionset('Number_of_inputs',2,'ms',20,'Std_constant',2.5 ...
    ,'Voltage_sent',100,'Amplifier',100,...
    'SelectionFcn',@selectionremainder,...
    'a',0.045,'b',0.2,'c',-65,'d',5,...
    'sensor_ranges',[0.0667    0.5587;0.0667    0.7740;0.0667    0.0786;0.0667    0.5104;0.0667    0.8151;0.0667    0.0600],...
    'Type','params_feedforward_k');


optionsga=gaoptimset('Generations',35,...
    'PopInitRange',[-100;100],'PopulationSize',75,...
    'CrossoverFraction',0.6,'Elite',1,'FitnessLimit',0,...
    'UseParallel','always',...
    'StallGenLimit',10,'PlotFcns',@gaplotbestf);


%%
for total_trials=1:100


%Create the dataset
[irisp irist]=iris();

sepal_length=normalize_data(irisp(1,:));
sepal_width=normalize_data(irisp(2,:));
petal_length=normalize_data(irisp(3,:));
petal_width=normalize_data(irisp(4,:));

%We use only the features that have been found to be relevant



irisp=[petal_length;petal_width];

%Sample the dataset
[folds positions]=sample_rand(irisp,150,[],[],1);
irisp=irisp(:,positions);
irist=irist(:,positions);



net=izknet([6 3],options);




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


[net_iris, fval]=trn_izknet(training_data,targets,net,optionsga,-50,50)
%net_iris=net;



%Test for generalization on the unseen instances

targets=irist(:,first:finish);
testing_accuracy=[testing_accuracy evaluate_success(testing_data,targets,net_iris)];
%training_accuracy=[training_accuracy (1-fval)];

end

end

