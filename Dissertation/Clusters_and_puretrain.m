 close all
total_iterations=1000;
time=[];
all_training_results=[];
all_total_results=[];
all_test_results=[];
total_epochs=[];
buffer=[];
fid = fopen('multipopt.bin', 'a+');

for iterations=1:total_iterations
    disp(['Iteration number: ' num2str(iterations)]);
%Create the dataset
[irisp irist]=iris();

sepal_length=normalize_data(irisp(1,:));
sepal_width=normalize_data(irisp(2,:));
petal_length=normalize_data(irisp(3,:));
petal_width=normalize_data(irisp(4,:));

%We use only the features that have been found to be relevant
irisp=[petal_length;petal_width];

%Sample the dataset
[irisp2 positions]=sample_rand(irisp,110,[],[],0);
irist2=irist(:,positions);



%*********cluster sensors optimization
options=izknet_optionset('Number_of_inputs',2,'ms',25,'Std_constant',2.5 ...
    ,'Voltage_sent',60,'Amplifier',30,'Initialization','zeros');
net=izknet([6 3],options);
net.type='clusters';


initpop=[ones(6,1)'*0.0667 0.06 0.0786 0.5103 0.5587 0.7740 0.8151];
initpop=repmat(initpop,10,1);



options=gaoptimset('PlotFcns',@gaplotbestf,'Generations',20,...
    'PopInitRange',[0;1],'PopulationSize',50,...
    'CrossoverFraction',0.6,'Elite',1,'FitnessLimit',0,...
    'UseParallel','always','InitialPopulation',initpop);



[net_iris, fval]=trn_izknet(irisp2,irist2,net,options,0,1);


%%%%%puretrain



options_for_training=pure_train_optionset('Epochs', 100, ...
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
'Target_success',0.94, ...
'Randomize_batch','true', ...
'Renew_weights','false',...
'Epochs_for_renewal',3,...
'Discrepancy_inhibition',0,...
'Discrepancy_excitation',1,...
'Discrepancy_inhibition_degradation',1,...
'Discrepancy_excitation_degradation',0);



[net_iris,training_success]=pure_train_izknet4(net_iris,irisp2,irist2,options_for_training);
end