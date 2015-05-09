function target_matrices=truth_table_new(net, input,in_or_out)

in=input;
positions=[];
target_matrices=[];

for p=1:size(in,2)
    input=in(:,p);
    I=[];
    seperator=numel(input)/net.number_of_inputs;
    step=seperator;
    input=input';
    first_neuron=1;
    last_neuron=net.sensor_neurons_distribution(1);
    

    
    %I enters the sensor neurons
    for j=1:net.number_of_inputs
    for i=first_neuron:last_neuron   
    I=[I;(gaussmf(input(j:step),net.sensor_parameters(i,:))*net.amplifier)];
    end

    if j<net.number_of_inputs
    first_neuron=last_neuron + 1;
    last_neuron=sum(net.sensor_neurons_distribution(1:j+1));
    step=step+seperator;
    end

    
%     disp(p)
%     if p==24
%        x=123123123; 
%     end
   
    if sum(I)==0
       x=[];
    else
       x=find(I==max(I));
    end
    positions=[positions x'];
    I(:)=0;
    
    end

    I(positions)=1;
    target_matrices=[target_matrices I];
    positions=[];
    
end





end