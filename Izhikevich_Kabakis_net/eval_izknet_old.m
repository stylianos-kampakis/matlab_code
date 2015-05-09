function [result action_series voltage]=eval_izknet_old(net,input)

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

I=[];
%I enters the sensor neurons
for i=1:net.number_of_sensor_neurons
I=[I;(gaussmf(input',sensor_parameters(i,:))*net.amplifier)];
end
%If the neurons accept more than one input, then input is summed
I=sum(I,2);

%Run for the specified duration
for t=1:ms
    %The algorithm runs from layer to layer updating voltage
    for i=1:numel(weights)
        %Set the action_matrix to zero
          action_matrix=zeros(layers(i),1);
         
          v{i}=v{i}+0.04*v{i}.^2+5*v{i}+140-u{i}+I;
          u{i}=u{i}+a.*(b.*v{i}-u{i});
          %Find the neurons that fired
          fired=find(v{i}>=30);   % indices of spikes
          firings=[firings; t+0*fired,fired];
          
          %voltage before the reset condition
          %voltage{i,t}=v{i};
          
          v{i}(fired)=c;
          u{i}(fired)=u{i}(fired)+d;
          
          %Save the voltage at the current instance
          voltage{i,t}=v{i};
          %Update the action_matrix
          action_matrix(fired)=1;
            
          
          
          %Create the input for the next layer
          I=weights{i}*action_matrix;
          
          %Save the action_matrix
          action_series{i,t}=action_matrix;
          
    end
  
end

%Find the first instace of the last layer in the action matrix
%where there is the first spike
     for i=1:ms
        for j=1:net.number_of_outputs
            if action_series{numel(weights),i}(j)==1
                result=action_series{numel(weights),i};
                break;
            end
        end
     end
%If no spike was found then simply return the last action_matrix for the
%last layer
     if isempty(result)
        result= action_series{numel(weights),i};
     end
end

