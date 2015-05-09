function [net,fval]=trn_izknet(input,output,net,options,LB,UB)

%Create the fitness function
f=@(x)izknet_ga(input,output,net,x);

%Specify the number of variables
nvars=0;

if strcmp(net.type,'feedforward')
    
    for i=1:numel(net.layers)-1
        nvars=nvars+net.layers(i)*net.layers(i+1);
    end
end

if strcmp(net.type,'params_feedforward') 
  nvars=sum(net.layers)*4;
end

if strcmp(net.type,'params_feedforward_k') 
  nvars=sum(net.layers)*4+1;
end

if strcmp(net.type,'params_input_only')
  nvars=(sum(net.layers)-net.layers(numel(net.layers)))*4;
end

if strcmp(net.type,'total')
    for i=1:numel(net.layers)-1
        nvars=nvars+net.layers(i)*net.layers(i+1);
    end
  nvars=nvars+sum(net.layers)*4;
end

if strcmp(net.type,'clusters')
    nvars=net.layers(1)*2;
end



%These are the options for the training
if nargin<4 || isempty(options)
options=gaoptimset('PlotFcns',@gaplotbestf,'Generations',150,...
    'PopInitRange',[-50;50],'PopulationSize',[20;20],...
    'CrossoverFraction',0.6,'Elite',0,'FitnessLimit',0,...
    'UseParallel','always');
end
%UNCOMMENT FOR BOUNDS
if(nargin<4 || isempty(LB))
   LB=-100;
end

if(nargin<5 || isempty(UB))
   UB=100;
end

%The final results
[weights, fval]=ga(f,nvars,[],[],[],[],LB,UB,[],options);

%Create the net
if strcmp(net.type,'feedforward')
previous=0;
    for i=1:numel(net.layers)-1
        
        net.layer_weights{i}=weights(previous+1:previous+(net.layers(i)*net.layers(i+1)));
        
        net.layer_weights{i}=reshape(net.layer_weights{i},net.layers(i+1),net.layers(i));
        
        previous=(net.layers(i)*net.layers(i+1));
    end
elseif strcmp(net.type,'params_feedforward')
%optimization of params only
previous=0;
for i=1:numel(net.layers)
   net.a{i}=weights(previous+1:previous+net.layers(i))';
   previous=previous+net.layers(i);
end

for i=1:numel(net.layers)
   net.b{i}=weights(previous+1:previous+net.layers(i))';
   previous=previous+net.layers(i);
end

for i=1:numel(net.layers)
   net.c{i}=weights(previous+1:previous+net.layers(i))';
   previous=previous+net.layers(i);
end

for i=1:numel(net.layers)
   net.d{i}=weights(previous+1:previous+net.layers(i))';
   previous=previous+net.layers(i);
end
elseif strcmp(net.type,'params_feedforward_k')
%optimization of params only
previous=0;
for i=1:numel(net.layers)
   net.a{i}=weights(previous+1:previous+net.layers(i))';
   previous=previous+net.layers(i);
end

for i=1:numel(net.layers)
   net.b{i}=weights(previous+1:previous+net.layers(i))';
   previous=previous+net.layers(i);
end

for i=1:numel(net.layers)
   net.c{i}=weights(previous+1:previous+net.layers(i))';
   previous=previous+net.layers(i);
end

for i=1:numel(net.layers)
   net.d{i}=weights(previous+1:previous+net.layers(i))';
   previous=previous+net.layers(i);
end

net.k=weights(numel(weights));

elseif strcmp(net.type,'total')
%optimization of both parameters and weights
 previous=0;
    for i=1:numel(net.layers)-1
        
        net.layer_weights{i}=weights(previous+1:previous+(net.layers(i)*net.layers(i+1)));
        
        net.layer_weights{i}=reshape(net.layer_weights{i},net.layers(i+1),net.layers(i));
        
        previous=(net.layers(i)*net.layers(i+1));
    end

for i=1:numel(net.layers)-1
   net.a{i}=weights(previous+1:previous+net.layers(i))';
   previous=previous+net.layers(i);
end

for i=1:numel(net.layers)-1
   net.b{i}=weights(previous+1:previous+net.layers(i))';
   previous=previous+net.layers(i);
end

for i=1:numel(net.layers)-1
   net.c{i}=weights(previous+1:previous+net.layers(i))';
   previous=previous+net.layers(i);
end

for i=1:numel(net.layers)-1
   net.d{i}=weights(previous+1:previous+net.layers(i))';
   previous=previous+net.layers(i);
end

elseif strcmp(net.type,'clusters')
    net.sensor_parameters(:,1)=weights(1:numel(weights)/2)';
    net.sensor_parameters(:,2)=weights(numel(weights)/2+1:numel(weights))';
    
end

end
