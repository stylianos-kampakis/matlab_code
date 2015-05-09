close all
total_iterations=100;
time=[];
all_training_results=[];
all_total_results=[];
all_test_results=[];
total_epochs=[];

for iterations=1:total_iterations
    disp(['Iteration number: ' num2str(iterations)]);
%Create the dataset
load_cancer;
DATA(:,1)=[];
irist=DATA(:,1);
DATA(:,1)=[];
irisp=DATA;
%[irisp irist]=iris();

for i=1:30
   
    irisp(:,i)=normalize_data(irisp(:,i));
    
end


%Sample the dataset
[irisp2 positions]=sample_rand(irisp',390,[],[],0);
irist=irist';

iristneuron2=irist;
iristneuron2(iristneuron2==1)=3;
iristneuron2(iristneuron2==0)=1;
iristneuron2(iristneuron2==3)=0;

irist=[irist;iristneuron2];
irist2=irist(:,positions);


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
'Target_success',0.95, ...
'Randomize_batch','true', ...
'Renew_weights','false',...
'Epochs_for_renewal',10,...
'Discrepancy_inhibition',0,...
'Discrepancy_excitation',1,...
'Discrepancy_inhibition_degradation',1,...
'Discrepancy_excitation_degradation',0);

% options=izknet_optionset('Number_of_inputs',2,'ms',11,'Std_constant',2.5 ...
%     ,'Voltage_sent',100,'Amplifier',100,'Sensor_ranges',[0.075,0.8;0.06,0.820],'Initialization','aaa');

options=izknet_optionset('Number_of_inputs',30,'ms',25,'Std_constant',1.5 ...
    ,'Voltage_sent',60,'Amplifier',30,'Initialization','zeros');

net=izknet([90 2],options);

net=cluster_sensors(net,irisp,2);
%net.sensor_parameters=rand(6,2);
%net.sensor_parameters(:,1)=zeros(6,1)+0.00001;
%net.sensor_parameters(:,2)=[0.06;0.0786;0.5104;0.5587;0.7740;0.8151];
%net.sensor_parameters(:,2)=[0.06;0.1;0.5104;0.5587;0.7740;0.8151];



% figure
% x=0:0.01:1;
% for p=1:6
%     sigma=net.sensor_parameters(p,1);
%     center=net.sensor_parameters(p,2);
%     plot(x,gaussmf(x,[sigma center]))
%     hold on
% end


layers_for_renewal=[90 2];
options_for_renewal=options;
tic
[net_iris,~, training_results,time2]=pure_train_izknet4(net,irisp2,irist2,options_for_training,layers_for_renewal,options_for_renewal)

time=[time time2];
all_training_results=[all_training_results training_results(numel(training_results))];

total_epochs=[total_epochs numel(training_results)];
plot(1:numel(training_results),training_results);

result=[];

for i=1:size(irisp,2)
    
   result=[result eval_izknet(net_iris,irisp(:,i))];
    
end

total_results=(result==irist);
error=1-sum(sum(total_results))/numel(total_results);
success=sum(sum(total_results))/numel(total_results)
all_total_results=[all_total_results success];


%Test for generalization on the unseen instances
iris_untrained_p=irisp;
iris_untrained_t=irist;

positions_unique=unique(positions);

iris_untrained_p(:,positions_unique)=[];
iris_untrained_t(:,positions_unique)=[];

result_untrained=[];
for i=1:size(iris_untrained_p,2)
    
   result_untrained=[result_untrained eval_izknet(net_iris,iris_untrained_p(:,i))];
    
end


total_results_untrained=(result_untrained==iris_untrained_t);
error_untrained=1-sum(sum(total_results_untrained))/numel(total_results_untrained)
success_untrained=sum(sum(total_results_untrained))/numel(total_results_untrained)


all_test_results=[all_test_results success_untrained];
end

mean_time=mean(time)
best=max(all_training_results)
all_training_results_mean=mean(all_training_results)
all_total_results_mean=mean(all_total_results)
all_test_results_mean=mean(all_test_results)
total_epochs_mean=mean(total_epochs)
[best all_training_results_mean all_test_results_mean all_total_results_mean  total_epochs_mean mean_time ]