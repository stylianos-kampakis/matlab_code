function net=trn_izknet_swarm(input,output,net,options,LB,UB)

%Create the fitness function
f=@(x)izknet_swarm(input,output,net,x);

%Specify the number of variables
nvars=0;

if strcmp(net.type,'feedforward')
    
    for i=1:numel(net.layers)-1
        nvars=nvars+net.layers(i)*net.layers(i+1);
    end
end



if(nargin<4 || isempty(LB))
   LB=-5;
end

if(nargin<5 || isempty(UB))
   UB=5;
end

%The final results

Population=20;
Neurons=nvars;
Epochs=100;
prop_move=1;
prop_social=1;
social_step=0.05;
disturbance=3;
disturbance_decrease=0.05;
weights=myswarm('min',f,Population,Neurons,LB,UB,Epochs,...
    prop_move,prop_social,social_step,disturbance,disturbance_decrease);

%Create the net
if strcmp(net.type,'feedforward')
previous=0;
    for i=1:numel(net.layers)-1
        
        net.layer_weights{i}=weights(previous+1:previous+(net.layers(i)*net.layers(i+1)));
        
        net.layer_weights{i}=reshape(net.layer_weights{i},net.layers(i+1),net.layers(i));
        
        previous=(net.layers(i)*net.layers(i+1));
    end

end



end