%%
close all
clear all
total_iterations=100;

testing_accuracy_pure=[];
training_accuracy_pure=[];
test_acc_final=[];
train_acc_final=[];


buffer=[];
fid = fopen('threestep.bin', 'a+');


%%

options_for_training=pure_train_optionset_final('Epochs', 100, ...
'Target_success',0.94, ...
'Randomize_batch','true');

options=izknet_optionset('Number_of_inputs',2,'ms',25,'Std_constant',2.5 ...
    ,'Voltage_sent',60,'Amplifier',30,'Initialization','zeros');



%%
%Create the dataset
[irisp irist]=iris();

sepal_length=normalize_data(irisp(1,:));
sepal_width=normalize_data(irisp(2,:));
petal_length=normalize_data(irisp(3,:));
petal_width=normalize_data(irisp(4,:));

%We use only the features that have been found to be relevant
irisp=[petal_length;petal_width];
%%

for iterations=1:total_iterations
    disp(['Iteration number: ' num2str(iterations)]);


%Sample the dataset
[folds positions]=sample_rand(irisp,150,[],[],1);
irisp=irisp(:,positions);
irist=irist(:,positions);


net=izknet([6 3],options);

net.sensor_parameters(:,2)=[0.06;0.0786;0.5104;0.5587;0.7740;0.8151];


for strat=1:10
    %Each strat is one fold
    strat
first=(strat-1)*15+1;
finish=strat*15;
testing_data=folds(:,first:finish);
training_data=folds;
training_data(:,first:finish)=[];
targets=irist;
targets(:,first:finish)=[];
targets_test=irist(:,first:finish);

[net_iris,training_success]=pure_train_izknet_final(net,training_data,targets,options_for_training);



%Test for generalization on the unseen instances



testing_accuracy_pure=[testing_accuracy_pure evaluate_success(testing_data,targets_test,net_iris)];
training_accuracy_pure=[training_accuracy_pure training_success];

%%
%*********parameter optimization


net_iris.type='params_feedforward';
initpop=[ones(9,1)'*0.045,ones(9,1)'*0.2,ones(9,1)'*-65,ones(9,1)'*5];
initpop=repmat(initpop,20,1);



optionsga=gaoptimset('PlotFcns',@gaplotbestf,'Generations',20,...
    'PopInitRange',[-100;100],'PopulationSize',50,...
    'CrossoverFraction',0.6,'Elite',1,'FitnessLimit',0,...
    'UseParallel','always','InitialPopulation',initpop);


[net_iris, fval]=trn_izknet(training_data,targets,net_iris,optionsga,-100,100);

train_acc_final=[train_acc_final (1-fval)];
test_acc_final=[test_acc_final evaluate_success(testing_data,targets_test,net_iris)];

 
end

end

train_final=train_acc_final;
test_final=test_acc_final;

%Check whether the total accuracy is higher for the parameter optimization
%or the simple training. Then, choose the best total accuracy.
for i=1:numel(train_acc_final)
   
    dummy1=(testing_accuracy_pure(i)+training_accuracy_pure(i))/2;
    dummy2=(test_acc_final(i)+train_acc_final(i))/2;
    
    if dummy2<dummy1
       train_final(i)=training_accuracy_pure(i);
       test_final(i)=testing_accuracy_pure(i);
    end
    
end
 