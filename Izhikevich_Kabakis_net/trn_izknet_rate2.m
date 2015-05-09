function net=trn_izknet_rate2(input,output,net,options,LB,UB)

%Create the fitness function
f=@(x)izknet_ga_rate2(input,output,net,x);

%Specify the number of variables
nvars=0;

if strcmp(net.type,'feedforward')
    
    for i=1:numel(net.layers)-1
        nvars=nvars+net.layers(i)*net.layers(i+1);
    end
end

%These are the options for the training
if nargin<4 || isempty(options)
options=gaoptimset('PlotFcns',@gaplotbestf,'Generations',150,...
    'PopInitRange',[-50;50],'PopulationSize',[20;20],...
    'CrossoverFraction',0.6,'Elite',0,'FitnessLimit',0,...
    'UseParallel','always');
end

if(nargin<4 || isempty(LB))
   LB=-5;
end

if(nargin<5 || isempty(UB))
   UB=5;
end


%The final results
nvars=nvars+net.layers(2);

weights=ga(f,nvars,[],[],[],[],LB,UB,[],options);

%Create the net
if strcmp(net.type,'feedforward')
previous=0;
    for i=1:numel(net.layers)-1
        
        net.layer_weights{i}=weights(previous+1:previous+(net.layers(i)*net.layers(i+1)));
        
        net.layer_weights{i}=reshape(net.layer_weights{i},net.layers(i+1),net.layers(i));
        
        previous=(net.layers(i)*net.layers(i+1));
    end

end

net.separators=[weights(numel(weights)-net.layers(2)+1:numel(weights))];


end