function [result]=eval_knet(net,input)

a=net.a;
weights=net.layer_weights;
layers=net.layers;
sensor_parameters=net.sensor_parameters;





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

activation=I;
timing=a./activation;
timing(timing>net.ms)=0;

    for i=1:numel(weights)     
        %firing_strength=step_function(timing);
        firing_strength=(1-(timing./net.ms)).*step_function(timing);   
        %firing_strength=tansig(timing).*step_function(timing);
        activation=weights{i}*firing_strength;
        activation=activation+net.thresholds{i};
        timing=a./activation;
        timing(timing<=0)=0;
        timing(timing>net.ms)=0;
    end


%The first neuron to fire wins
result=timing;
result(isinf(result))=0;
result(result==min(result) & result~=0)=NaN;
result(result~=0 & ~isnan(result))=0;
result(isnan(result))=1;

%In the case of regression produce a real number
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

