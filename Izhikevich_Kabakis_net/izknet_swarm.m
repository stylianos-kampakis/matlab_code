function error=izknet_swarm(input,output,net,weights_swarm)

error=zeros(size(weights_swarm,1),1);

for k=1:size(weights_swarm,1)
    
weights=weights_swarm(k,:);

if strcmp(net.type,'feedforward')
previous=0;
    for i=1:numel(net.layers)-1
        
        net.layer_weights{i}=weights(previous+1:previous+(net.layers(i)*net.layers(i+1)));
        
        net.layer_weights{i}=reshape(net.layer_weights{i},net.layers(i+1),net.layers(i));
        
        previous=(net.layers(i)*net.layers(i+1));
    end

end



results=[];


if strcmp(net.purpose,'classification')

for i=1:size(input,2)
   
    results=[results eval_izknet(net,input(:,i))];
    
end


results=(results==output);    

error(k)=numel(results(results==0))/numel(results);    
end

end

end