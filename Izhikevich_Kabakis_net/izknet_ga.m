function error=izknet_ga(input,output,net,weights)

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

elseif strcmp(net.type,'params_input_only')
%optimization of input neurons params only
previous=0;
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
 

elseif strcmp(net.type,'total')
%optimization of both parameters and weights
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






results=[];


if strcmp(net.purpose,'classification') || strcmp(net.purpose,'regression')

for i=1:size(input,2)
   
    results=[results eval_izknet(net,input(:,i))];
    
end

%**************Error metrics
    results=(results==output);
    
    %Original error
    error=numel(results(results==0))/numel(results);



 %************Regression case
    

elseif strcmp(net.purpose,'regression')

    error=[];
    
    for i=1:size(input,2)
   
    results=eval_izknet(net,input(:,i));
    
    if numel(results)==numel(output(i))
    current_error=results-output(i);
    
        if isnan(current_error)
           current_error=1; 
        end
    
    error=[error current_error];
    
    else
        
    current_error=2;    
    error=[error current_error];
    
    end
    
    
    end
    
    
    error=mse(error);
    
end

end