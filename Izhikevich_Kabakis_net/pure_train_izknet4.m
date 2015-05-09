function [net success training_success time]=pure_train_izknet4(net,in,out,options,layers_for_renewal,options_for_renewal)
tStart=tic;
%Create the default optionset if one is not already in the arguments
if(nargin<4)
    options=pure_train_optionset;
end

renewal_counter=0;

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
for i=1:size(in,2)

    %Evaluate the input
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

%This code here tries to fix the position of the sensor neurons in case
%that no input neuron has fired
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
   
    
%Check if the desired output is not the same as the output we got    
if ~(sum(result==out(:,i))==numel(result))  
%Choose a random output neuron so that we do not check the output neurons
%always in the same order
choices=randperm(numel(result));

   for choice=1:numel(result)
       j=choices(choice);
       %If the output should be zero, but it is not
       if(action_series_outputs(j)~=0 && out(j,i)==0)      

           action_series_inputs(action_series_inputs>0)=1;

              while (action_series_outputs(j)>Discrepancy_inhibition)
                  
          %Identify whether the current reaching the neuron is negative or
          %positive. If it is negative, then the neuron rebound spikes
                    pos_or_neg=sum(net.layer_weights{1}(j,:).*action_series_inputs);     
          %Apply the weight change depending on whether the neuron rebound
          %spikes or not
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
                                               

              end                        
       end        
   end   

%Permute the output neurons once again
   choices=randperm(numel(result));
      for choice=1:numel(result)               
        j=choices(choice);
 %If the output neuron should have fired but it did not
       if(action_series_outputs(j)~=1 && out(j,i)==1)

                while(action_series_outputs(j)<Discrepancy_excitation)
%Identify whether the weights are negative or positive. If they are
%negative then move them to the negative direction in order to rebound
%spike.
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

                
                end        
          
       end   
      end      
   
  end    
 end
end

%Lower the discrepancies for the new epoch

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
else
    renewal_counter=renewal_counter+1;
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


if(renewal_counter>options.Epochs_for_renewal)
   disp('Renewing weights') 
   net=izknet(layers_for_renewal,options_for_renewal);
   renewal_counter=0;
end

end


%If the training has stopped and the result was not achieved then terminate
%and report the final results.
net.layer_weights=saved_weights;
success=evaluate_success(in,out,net);
disp(['Target success NOT achieved. Terminating. Training success: ' num2str(success) ' , epoch : ' num2str(k)]);
time=toc(tStart);
