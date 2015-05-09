for trials=1:1

%Create the dataset
[irisp irist]=iris();

sepal_length=normalize_data(irisp(1,:));
sepal_width=normalize_data(irisp(2,:));
petal_length=normalize_data(irisp(3,:));
petal_width=normalize_data(irisp(4,:));

%We use only the features that have been found to be relevant
%irisp=[sepal_length;sepal_width;petal_length;petal_width];


irisp=[petal_length;petal_width];

%Sample the dataset
[irisp2 positions]=sample_rand(irisp,100,[],[],0);
irist2=irist(:,positions);


options=izknet_optionset('Number_of_inputs',2,'ms',20,'Std_constant',2.5 ...
    ,'Voltage_sent',100,'Amplifier',100,...
    'SelectionFcn',@selectionremainder,...
    'a',0.045,'b',0.2,'c',-65,'d',5,...,
    'sensor_ranges',[0.0667    0.5587;0.0667    0.7740;0.0667    0.0786;0.0667    0.5104;0.0667    0.8151;0.0667    0.0600],...
    'Sensor_ranges',[0.075,0.8;0.06,0.820],'Type','feedforward');
net=izknet([6 3],options);


options=gaoptimset('PlotFcns',@gaplotbestf,'Generations',30,...
    'PopInitRange',[-100;100],'PopulationSize',75,...
    'CrossoverFraction',0.6,'Elite',1,'FitnessLimit',0,...
    'UseParallel','always');




net_iris=trn_izknet(irisp2,irist2,net,options,-50,50)


%Test for general success
result=[];

for i=1:size(irisp,2)
    
   result=[result eval_izknet(net_iris,irisp(:,i))];
    
end

total_results=(result==irist);
error=1-sum(sum(total_results))/numel(total_results)
success=sum(sum(total_results))/numel(total_results)


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





%*********parameter optimization

options=izknet_optionset('Number_of_inputs',2,'ms',20,'Std_constant',2.5 ...
    ,'Voltage_sent',100,'Amplifier',100,...
    'SelectionFcn',@selectionremainder,...
    'a',0.045,'b',0.2,'c',-65,'d',5,...,
    'sensor_ranges',[0.0667    0.5587;0.0667    0.7740;0.0667    0.0786;0.0667    0.5104;0.0667    0.8151;0.0667    0.0600],...
    'Sensor_ranges',[0.075,0.8;0.06,0.820],'Type','params_feedforward');


net=izknet([6 3],options);
initpop=[ones(9,1)'*0.045,ones(9,1)'*0.2,ones(9,1)'*-65,ones(9,1)'*5];
initpop=repmat(initpop,10,1);
net.layer_weights=net_iris.layer_weights;



options=gaoptimset('PlotFcns',@gaplotbestf,'Generations',20,...
    'PopInitRange',[-100;100],'PopulationSize',75,...
    'CrossoverFraction',0.6,'Elite',1,'FitnessLimit',0,...
    'UseParallel','always','InitialPopulation',initpop);




[net_iris,fval]=trn_izknet(irisp2,irist2,net,options,-50,50);

training_success=1-fval;


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

fid = fopen('multiple.bin', 'a+');
 fprintf(fid,'%f %f \r\n',[training_success, success_untrained]);
 fclose(fid)

end