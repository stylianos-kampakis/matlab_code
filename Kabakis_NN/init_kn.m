function net=init_kn(layers,type,purpose,a,...
    number_of_inputs,ms,number_of_outputs,...
    std_constant,regression_matrix,output_layer,sensor_ranges,...
    sensor_neurons_distribution,amplifier,cost_matrix)

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

if nargin<4 || isempty(a)
   net.a=1; 
else
   net.a=a;
end


if nargin<5 || isempty(number_of_inputs)
   net.number_of_inputs=1;
else
   net.number_of_inputs=number_of_inputs;
end

if nargin<6 || isempty(ms)
   
    net.ms=50;
else
    net.ms=ms;
    
end

if nargin<6 || isempty(number_of_outputs)
   net.number_of_outputs=1;
else
   net.number_of_outputs=number_of_outputs;
end

if nargin<7 || isempty(std_constant)
   net.std_constant=2.5;
else
   net.std_constant=std_constant;
end

%argument 8=regression matrix covered below

if nargin<9 || isempty(output_layer)
   net.output_layer=numel(layers);
else
   net.output_layer=output_layer;
end


if nargin<10 || isempty(sensor_ranges)
   net.sensor_ranges=[zeros(net.number_of_inputs,1) ones(net.number_of_inputs,1)];
else
   net.sensor_ranges=sensor_ranges;
end

%If the sensor neurons distribution is empty then the function creates its
%own distribution. This distribution is seperates the input space into
%same-length spaces. So, for example, if there are 24 neurons and two
%inputs, then the 12 neurons will be used for the first input and 12 for
%the second

if nargin<11 || isempty(sensor_neurons_distribution)
    if net.number_of_inputs>1
        net.sensor_neurons_distribution=[];
        seperator=round(net.number_of_sensor_neurons/net.number_of_inputs);
        
        for i=1:net.number_of_inputs
           
            net.sensor_neurons_distribution=[
               net.sensor_neurons_distribution seperator];
            
        end
        
    if sum(net.sensor_neurons_distribution)>net.number_of_sensor_neurons
        i=numel(net.sensor_neurons_distribution);
        while sum(net.sensor_neurons_distribution)>net.number_of_sensor_neurons
        net.sensor_neurons_distribution(i)=...
         net.sensor_neurons_distribution(i)-1; 
        i=i-1;
        end
   
        
    elseif sum(net.sensor_neurons_distribution)<net.number_of_sensor_neurons
        i=numel(net.sensor_neurons_distribution);
        while sum(net.sensor_neurons_distribution)<net.number_of_sensor_neurons
        net.sensor_neurons_distribution(i)=...
         net.sensor_neurons_distribution(i)+1; 
        i=i-1;
        end  
    end
    
    
    
elseif net.number_of_inputs==1 
   net.sensor_neurons_distribution=net.number_of_sensor_neurons;
else
   net.sensor_neurons_distribution=sensor_neurons_distribution;
    end

end

if nargin<12 || isempty(amplifier)  
    net.amplifier=1;    
else
    net.amplifier=amplifier;  
end

if nargin<13 ||isempty(cost_matrix)
    net.cost_matrix=[1 1 1 1];
else
    net.cost_matrix=cost_matrix;
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
if nargin<8 || isempty(regression_matrix)

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


%***********Now make the weights of the layers


for i=1:numel(layers)-1
   
    layer_weights{i}=rand(layers(i+1),layers(i));
    
end



net.layer_weights=layer_weights;
net.layers=layers;



%**********Now make the thresholds

for i=1:numel(layers)-1
    
   net.thresholds{i}=-1*rand(layers(i+1),1);
    
end

end
