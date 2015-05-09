function net=trn_knet(input,output,net,options)

%Create the fitness function
f=@(x)knet_ga(input,output,net,x);

%Specify the number of variables
nvars=0;

if strcmp(net.type,'feedforward')
    
    for i=1:numel(net.layers)-1
        nvars=nvars+net.layers(i)*net.layers(i+1);
    end
    
nvars=nvars+sum(net.layers(2:numel(net.layers)));
    
end



%These are the options for the training

if nargin<4 || isempty(options)
options=gaoptimset('PlotFcns',@gaplotbestf,'Generations',150,...
    'PopInitRange',[-1;6],'PopulationSize',[25;25],...
    'CrossoverFraction',0.6,'Elite',1,'FitnessLimit',0,...
    'UseParallel','always');
end

%The final results
weights=ga(f,nvars,[],[],[],[],[],[],[],options);


%Create the net
if strcmp(net.type,'feedforward')
    previous=0;
    for i=1:numel(net.layers)-1
        
        net.layer_weights{i}=weights(previous+1:previous+(net.layers(i)*net.layers(i+1)));
        
        net.layer_weights{i}=reshape(net.layer_weights{i},net.layers(i+1),net.layers(i));
        
        previous=(net.layers(i)*net.layers(i+1));
    end

    weights_left=weights;
    weights_left(1:previous)=[];
    
    previous=0;
    
  for j=1:numel(net.layers)-1
        
       net.thresholds{j}=weights_left(previous+1:previous+net.layers(j+1));
       previous=net.layers(j+1);
       net.thresholds{j}=net.thresholds{j}';
    end
    
end



end