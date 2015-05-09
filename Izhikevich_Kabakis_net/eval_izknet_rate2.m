function [result action_series voltage]=eval_izknet_rate2(net,input)

%Initialize variables
a=net.a;
b=net.b;
c=net.c;
d=net.d;
weights=net.layer_weights;
layers=net.layers;
ms=net.ms;
sensor_parameters=net.sensor_parameters;



action_series=cell(numel(weights),ms);
voltage=cell(numel(weights),ms);

result=[];
firings=[];             % spike timings


%Initialize v, u and I
for i=1:numel(layers)
   v{i}=-65*ones(layers(i),1); 
   u{i}=b.*v{i};
end

%********Input code
%The network can accept any number of inputs at any one time. This means
%that for example, if a function (XOR for example) has two inputs then the
%network can receive them as one input or as two seperate. Two variables,
%the seperator and the step, are used in order to calculate how many inputs
%in each round should be received in each iteration.

I=[];
seperator=numel(input)/net.number_of_inputs;
step=seperator;
input=input';
first_neuron=1;
last_neuron=net.sensor_neurons_distribution(1);
%I enters the sensor neurons
for j=1:net.number_of_inputs
for i=first_neuron:last_neuron   
I=[I;(gaussmf(input(j:step),sensor_parameters(i,:))*net.amplifier)];
end

if j<net.number_of_inputs
first_neuron=last_neuron + 1;
last_neuron=sum(net.sensor_neurons_distribution(1:j+1));
step=step+seperator;
end

end




%If the neurons accept more than one input, then input is summed
I=sum(I,2);

%Run for the specified duration
for t=1:ms
    %The algorithm runs from layer to layer updating voltage
    for i=1:numel(weights)
        %Set the action_matrix to zero
          action_matrix=zeros(layers(i),1);
         

          %This is the improved izhikevich model
          for j=1:numel(v{i})
              
              %dummy variable that is used to hold the new possible voltage
              %of the neuron
            try
              x=v{i}(j)+0.04.*v{i}(j).^2+5.*v{i}(j)+140-u{i}(j)+I(j); 
            catch
               disp('ERROR DETECTED'); 
            end
            %If the voltage is under 30 and the previous voltage was not 30
            %then use the standard izhikevich equations
            
          
            %
              if ((x<30) && ((v{i}(j))~=30))
                 
                 v{i}(j)=v{i}(j)+0.04.*v{i}(j).^2+5.*v{i}(j)+140-u{i}(j)+I(j); 
                 u{i}(j)=u{i}(j)+a.*(b.*v{i}(j)-u{i}(j));  
                               
           %If the voltage is 30 update it to the post-firing condition
              elseif v{i}(j)==30
              
                  v{i}(j)=c;
                  u{i}(j)=u{i}(j)+d;
            %If the new voltage will get over 30 then make it 30 
              elseif x>30
                  
                  v{i}(j)=30;
              end

          end
             
          %Find the neurons that fired
          fired=find(v{i}==30);   % indices of spikes
          firings=[firings; t+0*fired,fired];
          %Save the voltage at the current instance
          voltage{i,t}=v{i};
          %Update the action_matrix
          action_matrix(fired)=1;
            
          
          
          %Create the input for the next layer
          I=weights{i}*action_matrix*net.voltage_sent; 
          
          %Save the action_matrix
          action_series{i,t}=action_matrix;

    end
  
end

%Find the first instace of the last layer in the action matrix
%where there is the first spike

rates=sum(cell2mat(action_series(2,:)),2);

results=zeros(net.number_of_output_neurons,1);

for fg=1:numel(net.separators)

    if rates<net.separators(fg)
       results(fg)=fg;
       break;
    end
    
end


                  
   

%If no spike was found then simply return the last action_matrix for the
%last layer
     if isempty(result)
        result= action_series{numel(weights),i};
     end
     
     if strcmp(net.purpose,'regression')
        
         result(result==0)=NaN;
         
         result=result.*net.regression_matrix;
         
         result(isnan(result))=[];
         
         if isempty(result)
            result=NaN; 
         end
         
         if numel(result)~=net.number_of_outputs
            disp('Error: number of results different than number of outputs') 
         end
         
     end
     
end

