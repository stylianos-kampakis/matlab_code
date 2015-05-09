function net=init_izkn(layers,type,purpose,ms,cost_matrix,a,b,c,d,...
    amplifier,voltage_sent,number_of_inputs,number_of_outputs,...
    std_constant,regression_matrix,output_layer,sensor_ranges,...
    sensor_neurons_distribution,initialization,step)

net.number_of_sensor_neurons=layers(1);
net.number_of_output_neurons=layers(numel(layers));
net.number_of_sensor_neurons;
net.number_of_output_neurons;

if nargin<2 || isempty(type)
   net.type='feedforward';
else
    net.type=type;
end

if nargin<3 || isempty(purpose)
   net.purpose='classification';
else
   net.purpose=purpose;
end

if nargin<4 || isempty(ms)
   net.ms=20;
else
   net.ms=ms;
end

%**************Cost matrix******
%true positive, true negative, false positive, false negative

if nargin<5 || isempty(cost_matrix)
   net.cost_matrix=[1 1 1 1];
else
   net.cost_matrix=cost_matrix;
end



if nargin<6 || isempty(a)
    for i=1:numel(layers)
        net.a{i}=0.045*ones(layers(i),1); 
    end
else
    for i=1:numel(layers)
        net.a{i}=a*ones(layers(i),1); 
    end
end

if nargin<7 || isempty(b)
   for i=1:numel(layers)
        net.b{i}=0.2*ones(layers(i),1); 
    end
else
    for i=1:numel(layers)
    net.b{i}=b*ones(layers(i),1);
    end
end

if nargin<8 || isempty(c)
   for i=1:numel(layers)
        net.c{i}=-65*ones(layers(i),1); 
    end
else
    for i=1:numel(layers)
   net.c{i}=c*ones(layers(i),1); 
    end
end

if nargin<9 || isempty(d)
   for i=1:numel(layers)
        net.d{i}=5*ones(layers(i),1); 
    end
else
    for i=1:numel(layers)
   net.d{i}=d*ones(layers(i),1); 
    end
end

if nargin<10 || isempty(amplifier)
   net.amplifier=30;
else
   net.amplifier=amplifier;
end

if nargin<11 || isempty(voltage_sent)
   net.voltage_sent=60;
else
   net.voltage_sent=voltage_sent;
end

if nargin<12 || isempty(number_of_inputs)
   net.number_of_inputs=1;
else
   net.number_of_inputs=number_of_inputs;
end

if nargin<13 || isempty(number_of_outputs)
   net.number_of_outputs=1;
else
   net.number_of_outputs=number_of_outputs;
end

if nargin<14 || isempty(std_constant)
   net.std_constant=2.5;
else
   net.std_constant=std_constant;
end

%argument 15=regression matrix covered below

if nargin<16 || isempty(output_layer)
   net.output_layer=numel(layers);
else
   net.output_layer=output_layer;
end


if nargin<17 || isempty(sensor_ranges)
   net.sensor_ranges=[zeros(net.number_of_inputs,1) ones(net.number_of_inputs,1)];
else
   net.sensor_ranges=sensor_ranges;
end

%If the sensor neurons distribution is empty then the function creates its
%own distribution. This distribution is seperates the input space into
%same-length spaces. So, for example, if there are 24 neurons and two
%inputs, then the 12 neurons will be used for the first input and 12 for
%the second

if nargin<18 || isempty(sensor_neurons_distribution)
    if net.number_of_inputs>1
        net.sensor_neurons_distribution=[];
        seperator=round(net.number_of_sensor_neurons/net.number_of_inputs);
        
        for i=1:net.number_of_inputs
           
            net.sensor_neurons_distribution=[
               net.sensor_neurons_distribution seperator];
            
        end
        
    %If the algorithm above produced more neurons than there are in
    %existence then prune them
        
    if sum(net.sensor_neurons_distribution)>net.number_of_sensor_neurons
        i=numel(net.sensor_neurons_distribution);
        while sum(net.sensor_neurons_distribution)>net.number_of_sensor_neurons
        net.sensor_neurons_distribution(i)=...
         net.sensor_neurons_distribution(i)-1; 
        i=i-1;
        end
   
    %If the algorithm produced less then add one
    elseif sum(net.sensor_neurons_distribution)<net.number_of_sensor_neurons
        i=numel(net.sensor_neurons_distribution);
        while sum(net.sensor_neurons_distribution)<net.number_of_sensor_neurons
        net.sensor_neurons_distribution(i)=...
         net.sensor_neurons_distribution(i)+1; 
        i=i-1;
        end  
    end
    
    
%If the number of inputs is 1 then all the neurons are used as sensor
%neurons
    elseif net.number_of_inputs==1 
       net.sensor_neurons_distribution=net.number_of_sensor_neurons;
    else
       net.sensor_neurons_distribution=sensor_neurons_distribution;
    end

end
%************Split the input space into gaussian functions with uniform
%************distributions*********************

net.sensor_parameters=[];

for k=1:net.number_of_inputs
centers=[];
centers(1)=net.sensor_ranges(k,1);
previous_mean=net.sensor_ranges(k,1);

for i=1:net.sensor_neurons_distribution(k)-1
    centers=[centers;previous_mean+(net.sensor_ranges(k,2)-net.sensor_ranges(k,1))/(net.sensor_neurons_distribution(k)-1)];
    previous_mean=centers(i+1);
end

%The standard deviation of the sensor neurons
stdev=1/(net.number_of_sensor_neurons*net.std_constant);

%The parameters of the sensor neurons
net.sensor_parameters=[net.sensor_parameters ; stdev*ones(net.sensor_neurons_distribution(k),1) centers ];
% 
end

%For the regression matrix is used the same procedure as for the 
%sensor neurons
if nargin<15 || isempty(regression_matrix)

    for k=1:net.number_of_inputs
    centers=[];
    centers(1)=net.sensor_ranges(k,1);
    previous_mean=net.sensor_ranges(k,1);



        for i=1:net.number_of_output_neurons-1
            centers=[centers;previous_mean+(net.sensor_ranges(k,2)-net.sensor_ranges(k,1))/(net.sensor_neurons_distribution(k)-1)];
            previous_mean=centers(i+1);
        end

            net.regression_matrix=centers;

    end

else
    
    net.regression_matrix=regression_matrix;

end

if nargin<16
   net.k=1; 
else
   net.k=step;
end


%***********Now make the weights of the layers


for i=1:numel(layers)-1
if(strcmp('positive',initialization))    
    layer_weights{i}=rand(layers(i+1),layers(i));
elseif (strcmp('negative',initialization))
    layer_weights{i}=-1.*rand(layers(i+1),layers(i));
elseif (strcmp('zeros',initialization))
    layer_weights{i}=zeros(layers(i+1),layers(i));
else
    layer_weights{i}=-1 + 2.*rand(layers(i+1),layers(i));    
end
end

%This is a second layer of weights that connects the laster layer with the first. 
%It serves two purposes.
%First, it can be used in case there is a need to create a recursive layer
%Secondly, when the network is not recursive, the input for the neuron, is
%multiplied by these weights (which are zero), in order to get the value of
%0.
layer_weights{numel(layers)}=zeros(layers(1),layers(numel(layers)));

net.layer_weights=layer_weights;
net.layers=layers;

end
