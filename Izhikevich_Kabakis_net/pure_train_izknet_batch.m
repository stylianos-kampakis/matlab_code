function [net success training_success time]=pure_train_izknet_batch(net,in,out,options)
tStart=tic;
%Create the default optionset if one is not already in the arguments
if(nargin<4)
    options=pure_train_optionset;
end

%Transfer the options to appropriate local variables
Epochs=options.Epochs;
Inhibitory_momentum=options.Inhibitory_momentum;
Excitatory_momentum=options.Excitatory_momentum;
Target_success=options.Target_success;
Randomize_batch=options.Randomize_batch;
Report=options.Report;
Discrepancy_excitation=options.Discrepancy_excitation;
Discrepancy_inhibition=options.Discrepancy_inhibition;
Discrepancy_excitation_degradation=options.Discrepancy_excitation_degradation;
Discrepancy_inhibition_degradation=options.Discrepancy_inhibition_degradation;
batch_size=10;

training_success=[];
previous_success=0;

for k=1:Epochs
    
    saved_weights=net.layer_weights;

    %Batch randomization changes the position of the elements of the
    %training set in each epoch
    if strcmp(Randomize_batch,'true')  
        positions=randperm(size(in,2));
        in=in(:,positions);     
        out=out(:,positions);
    end
    
 
    %For every element in the training set
net_storage={};
for all_inputs=1:size(in,2)/batch_size
initial_net=net;
    for bat=1:batch_size
    net=initial_net;
    %Evaluate the input
    i=all_inputs+bat-1;
    
    
   [result action_series voltage] = eval_izknet(net,in(:,i));
   
    if (check_time(action_series(1,:))==1)
      net.ms=net.ms+1;
      [result action_series voltage] = eval_izknet(net,in(:,i));
    end
   first_index=sum(net.sensor_neurons_distribution);
   second_index=sum(net.sensor_neurons_distribution)+numel(result);
    
  % action_series=clean_action_series(action_series,sum(net.sensor_neurons_distribution),numel(result)); 
   action_series=cell2mat(action_series);
   action_series=clean_duplicates(action_series);
   action_series_inputs=derive_action(action_series(1:first_index,:));    
   action_series_outputs=derive_action(action_series(first_index+1:second_index,:));

   
   %Now we need to check if there were any rebound spikes. In order to do
   %that we have to take the voltage and check whether before a spike there
   %was a decrease in voltage below the equilibrium value.
   
   %Find the voltage and keep all columns up to the first firing
    involtage=cell2mat(voltage(1,:));   
    
    
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
         
          action_series=cell2mat(action_series);
          action_series=clean_duplicates(action_series);
          action_series_inputs=derive_action(action_series(1:first_index,:));
          action_series_inputs=action_series_inputs(previous:numinputs*net.sensor_neurons_distribution(numinputs));
          not_firing=sum(action_series_inputs);
 
       end
       previous=1+numinputs*net.sensor_neurons_distribution(numinputs);
       previous_sensors=previous_sensors+net.sensor_neurons_distribution(numinputs);
       end       
   else
   
    
    
if ~(sum(result==out(:,i))==numel(result))  

Discrepancy=1;

while Discrepancy>Discrepancy_inhibition
     tic
   for j=1:numel(result)
       Discrepancy=0;      
       
       if(action_series_outputs(j)~=0 && out(j,i)==0)       
           Discrepancy=action_series_outputs(j); 
           action_series_inputs(action_series_inputs>0)=1;

              while (action_series_outputs(j)>Discrepancy_inhibition)
                  
                    pos_or_neg=sum(net.layer_weights{1}(j,:).*action_series_inputs);     
             
                    if pos_or_neg>=0
                    net.layer_weights{1}(j,:)=net.layer_weights{1}(j,:)-Inhibitory_momentum.*action_series_inputs;                                                                                                      
                    else                                
                    net.layer_weights{1}(j,:)=net.layer_weights{1}(j,:)+...
                    Inhibitory_momentum.*action_series_inputs.*(-sign2(net.layer_weights{1}(j,:)));                                                                                                        
                    end                     
                   [result , action_series]= eval_izknet(net,in(:,i));                                       
                   
                   action_series=cell2mat(action_series);  
                   action_series=clean_duplicates(action_series);

                   action_series_outputs=derive_action(action_series(first_index+1:second_index,:));                      
                   Discrepancy=action_series_outputs(j);                                   
     if toc>3
          ssd=3;
          break;
     end
              end
              
     if Discrepancy==1
        SKATA=232323; 
     end
     
%      if sum(out(:,i)==in(:,i))~=3
%         sdsdsds=3; 
%      end
              
       end        
   end   
end

   Discrepancy=0;
   
   while Discrepancy<Discrepancy_excitation
       Discrepancy=1;
      for j=1:numel(result)               
       
       if(action_series_outputs(j)~=1 && out(j,i)==1)

           Discrepancy=action_series_outputs(j);   
tic
                while(action_series_outputs(j)<Discrepancy_excitation)

                    pos_or_neg=sum(net.layer_weights{1}(j,:).*(action_series_inputs>0));
          
                     if pos_or_neg>=0
                     action_series_inputs(action_series_inputs>0)=1;
                     net.layer_weights{1}(j,:)=net.layer_weights{1}(j,:)+Excitatory_momentum.*action_series_inputs;    
                     else
              %This code is a little tricky. What it does is the following
              % When we had more than one inputs, but in different timings, 
              %then all other inputs
              %besides the first one, should get weakened. The reason is
              %that even when we want a rebound spike, negative inputs that
              %come later can have an inhibitory effect!
                     action_series_inputs(action_series_inputs<1 & action_series_inputs~=0) = -1;           
                     net.layer_weights{1}(j,:)=net.layer_weights{1}(j,:)-Excitatory_momentum.*action_series_inputs;                              
                     end
             
                    [result, action_series]=eval_izknet(net,in(:,i));         
                    action_series=cell2mat(action_series);
                    action_series=clean_duplicates(action_series);
                    action_series_inputs=derive_action(action_series(1:first_index,:));    
                    action_series_outputs=derive_action(action_series(first_index+1:second_index,:));                           
   if toc>3
       sds=33;
       break;
   end
                
                end        
          
       end   
      end      
   end  
  end    
end
net_storage{bat}=net.layer_weights{1};

    end
    
    storage=zeros(batch_size,1);
for w=1:numel(net.layer_weights{1})
   for io=1:batch_size
      storage(io)=net_storage{bat}(w); 
   end
   net.layer_weights{1}(w)= mean(storage);
end
    
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

if success>previous_success
    saved_weights=net.layer_weights;
    previous_success=success;
end

%Report
if(strcmp(Report,'true'))    
    disp(['Epoch number: ' num2str(k) ' , success rate : ' num2str(success)]);
end

%If target success achieved then report and terminate
if(success>=Target_success)
    disp(['Target success achieved. Terminating. Training success: ' num2str(success) ' , epoch : ' num2str(k)]);
   	time=toc(tStart);
    return;
end


end


%If the training has stopped and the result was not achieved then terminate
%and report the final results.
net.layer_weights=saved_weights;
success=evaluate_success(in,out,net);
disp(['Target success NOT achieved. Terminating. Training success: ' num2str(success) ' , epoch : ' num2str(k)]);
time=toc;
