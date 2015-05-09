function [net training_success]=pure_train_izknet2(net,in,out,options)

%Create the default optionset if one is not already in the arguments
if(nargin<4)
    options=pure_train_optionset;
end

%Transfer the options to appropriate local variables
Epochs=options.Epochs;
Inhibitory_function=str2func(options.Inhibitory_function);
Excitatory_function=str2func(options.Excitatory_function);
Inhibitory=options.Inhibitory;
Excitatory=options.Excitatory;
Inhibitory_momentum=options.Inhibitory_momentum;
Excitatory_momentum=options.Excitatory_momentum;
Inhibitory_momentum_degradation=options.Inhibitory_momentum_degradation;
Excitatory_momentum_degradation=options.Excitatory_momentum_degradation;
Inhibitory_learning_rate=options.Inhibitory_learning_rate;
Excitatory_learning_rate=options.Excitatory_learning_rate;
Target_success=options.Target_success;
Randomize_batch=options.Randomize_batch;
Renew_weights=options.Renew_weights;
Epochs_for_renewal=options.Epochs_for_renewal;
Report=options.Report;
Discrepancy_excitation=options.Discrepancy_excitation;
Discrepancy_inhibition=options.Discrepancy_inhibition;
Discrepancy_excitation_degradation=options.Discrepancy_excitation_degradation;
Discrepancy_inhibition_degradation=options.Discrepancy_inhibition_degradation;


training_success=[];
previous_success=0;
renewal_counter=0;
achieved=0;


for k=1:Epochs
    net.layer_weights{1}
    saved_weights=net.layer_weights;
    
    if achieved==1
       break 
    end
    %Batch randomization changes the position of the elements of the
    %training set in each epoch
    if strcmp(Randomize_batch,'true')  
        positions=randperm(size(in,2));
        in=in(:,positions);     
        out=out(:,positions);
    end
    
    %The renewal counter along with the previous_success variable are used
    %in order to assess whether a re-initialization in weights should be
    %performed
    if renewal_counter==Epochs_for_renewal && strcmp(Renew_weights,'true')       
       %net.layer_weights{1}=-1 + 2.*rand((size(net.layer_weights{1})));        
       random=ceil(numel(net.layer_weights{1})*rand);
       net.layer_weights{1}(random)=-1 + 2.*rand;
       disp('RENEWED WEIGHTS');
       renewal_counter=0;
       previous_success=0;
    end
    
    %For every element in the training set
for i=1:size(in,2)

    %Evaluate the input
   [result, action_series voltage] = eval_izknet(net,in(:,i));
   
   
    if (check_time(action_series(1,:))==1)
      net.ms=net.ms+1;
      [result, action_series voltage] = eval_izknet(net,in(:,i));
    end   
 
   action_series_inputs=derive_action(action_series(1,:),0);  
  
   action_series_outputs=derive_action(action_series(2,:),net.ms);
   
   %Now we need to check if there were any rebound spikes. In order to do
   %that we have to take the voltage and check whether before a spike there
   %was a decrease in voltage below the equilibrium value.
   
   %Find the voltage and keep all columns up to the first firing
    involtage=cell2mat(voltage(1,:));
    voltage=cell2mat(voltage(size(voltage,1),:));
    [~,column] = find(voltage==30);
    if ~isempty(column)
    voltage=voltage(:,1:column(1));
    %Find the initial voltage and check whether before the firing the
    %voltage of a neuron fell below the initial voltage
    rebounds=find_rebounds(voltage,action_series(2,:),-73);
    else
        %In case of no firing then simply create artificial matrices
        voltage=zeros(net.number_of_output_neurons,1);
        rebounds=ones(net.number_of_output_neurons,1);
    end    

    
    
    
    previous=1;
   previous_sensors=0;
   std_increase=0.001;
   mean_increase=0.01;

   
   if sum(action_series_inputs)==0
       
       for numinputs=1:net.number_of_inputs
       not_firing=0;
       involtage_now=involtage(previous:numinputs*net.sensor_neurons_distribution(numinputs),:);
           
       [position,~]=find(involtage_now==max(max(involtage_now)));
     
       while not_firing==0;

          net.sensor_parameters(position+previous_sensors,1)=net.sensor_parameters(position+previous_sensors,1)+std_increase;

          if net.sensor_parameters(position+previous_sensors,2)<in(numinputs,i)
          net.sensor_parameters(position+previous_sensors,2)=net.sensor_parameters(position+previous_sensors,2)+mean_increase;
          else
          net.sensor_parameters(position+previous_sensors,2)=net.sensor_parameters(position+previous_sensors,2)-mean_increase;                
          end
          
          [~, action_series]=eval_izknet(net,in(:,i));
          action_series_inputs=derive_action(action_series(1,:),0);
          action_series_inputs=action_series_inputs(previous:numinputs*net.sensor_neurons_distribution(numinputs));
          not_firing=sum(action_series_inputs);
       
       
       end
       previous=1+numinputs*net.sensor_neurons_distribution(numinputs);
       previous_sensors=previous_sensors+net.sensor_neurons_distribution(numinputs);
       end       
   else
   
    
    
if ~(sum(result==out(:,i))==numel(result))    


   
 for j=1:numel(result) 
             
    if(action_series_outputs(j)~=0 && out(j,i)==0) && sum(action_series_inputs)~=0        
           
        if(strcmp(Inhibitory,'true'))                                    
           g=compute_all_gradients(net.layer_weights{1}(j,:),net,in(:,i),j,...
           Discrepancy_inhibition,0,...
           sum(net.layer_weights{1}(j,:).*action_series_inputs)<0,0.01);
              
       
        if sum(g)==0
          sdsd=23; 
       end
       
           net.layer_weights{1}(j,:)=net.layer_weights{1}(j,:)+Inhibitory_learning_rate*g;                           
        end 
         
    
        
        
    end
  
    
    %Re-evaluate
     %Evaluate the input
   [result, action_series voltage] = eval_izknet(net,in(:,i));
   
   
    if (check_time(action_series(1,:))==1)
      net.ms=net.ms+1;
      [result, action_series voltage] = eval_izknet(net,in(:,i));
    end   
 
   action_series_inputs=derive_action(action_series(1,:),0);   
   action_series_outputs=derive_action(action_series(2,:),net.ms);
    
    
       if(action_series_outputs(j)~=1 && out(j,i)==1) && sum(action_series_inputs)~=0
   

           if(strcmp(Excitatory,'true'))                        
             g=compute_all_gradients(net.layer_weights{1}(j,:),net,in(:,i),j,...
           Discrepancy_excitation,1,...
           sum(net.layer_weights{1}(j,:).*action_series_inputs)<0,0.01);
       if sum(g)==0
          sdsd=23; 
       end
       
       
           net.layer_weights{1}(j,:)=net.layer_weights{1}(j,:)+Excitatory_learning_rate*g;                
                                  
           end           
         end       
    
    
        end
    end

   end
   
end
   
%Lower the momentum and update its value if it has fallen below 0
Inhibitory_momentum=Inhibitory_momentum-Inhibitory_momentum_degradation;
Excitatory_momentum=Excitatory_momentum-Excitatory_momentum_degradation;

if Inhibitory_momentum<0    
    Inhibitory_momentum=0;    
end

if Excitatory_momentum<0    
    Excitatory_momentum=0;    
end

%Lower the discrepancies

Discrepancy_inhibition=Discrepancy_inhibition-Discrepancy_inhibition_degradation;
Discrepancy_excitation=Discrepancy_excitation+Discrepancy_excitation_degradation;


if Discrepancy_inhibition<0    
    Discrepancy_inhibition=0;    
end

if Discrepancy_excitation>1    
    Discrepancy_excitation=1;    
end


%Find the results for the network
success=evaluate_success(in,out,net);
training_success=[training_success success];


%If the success rate has remained the same then update the renewal counter
if success<=previous_success
    renewal_counter=renewal_counter+1;
    %net.layer_weights=saved_weights;
    %success=previous_success;
else    
    saved_weights=net.layer_weights;
    previous_success=success;
end

% choices=1:sum(net.sensor_neurons_distribution);
% 
% for numsensors=1:sum(net.sensor_neurons_distribution)
%     reduced_success=success;
% 
%     index=ceil(rand*numel(choices));
%     chosen=choices(index);
%     choices(index)=[];
%     
%     while ~(reduced_success<success) && net.sensor_parameters(chosen,1)>0
%        net.sensor_parameters(chosen,1)=net.sensor_parameters(chosen,1)-0.01;
%        reduced_success=evaluate_success(in,out,net);
% 
%     end
% net.sensor_parameters(chosen,1)=net.sensor_parameters(chosen,1)+0.01;
     
 %end

% %
% epoch_results=zeros(size(out,1),size(out,2));
% 
% for i=1:size(in,2)
%     
%    epoch_results(:,i)=eval_izknet(net,in(:,i));
%     
% end
% 
% epoch_results=(epoch_results==out);
% in(:,find(sum(epoch_results)==3))=[];
% size(in)
%

%Report
if(strcmp(Report,'true'))    
    disp(['Epoch number: ' num2str(k) ' , success rate : ' num2str(success)]);
end

%If target success achieved then report and terminate
if(success>=Target_success)
    disp(['Target success achieved. Terminating. Training success: ' num2str(success) ' , epoch : ' num2str(k)]);
    achieved=1;
    %break;
end

%If the training has stopped and the result was not achieved then terminate
%and report the final results.
if k==Epochs
    net.layer_weights=saved_weights;
    
    for i=1:size(in,2)
    
   epoch_results(:,i)=eval_izknet(net,in(:,i));
    
    end

epoch_results=(epoch_results==out);
success=sum(sum(epoch_results))/numel(epoch_results);

  
disp(['Target success NOT achieved. Terminating. Training success: ' num2str(success) ' , epoch : ' num2str(k)]);
end

end

