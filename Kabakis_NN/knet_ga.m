function error=knet_ga(input,output,net,weights)

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



results=[];


if strcmp(net.purpose,'classification')

for i=1:size(input,2)
   
    results=[results eval_knet(net,input(:,i))];
    
end


homog=0;

for j=1:size(results,2)
   
    if sum(results(:,j))>0
     homog=homog+sum(results(:,j))-net.number_of_outputs;
    else
     homog=homog+net.number_of_outputs;        
    end
end

%**************Error metrics
    results=(results==output);
    
    
    error=numel(results(results==0))/numel(results);
    
    if error==0
        
    end
    
   %error=numel(results(results==0));
    
%   for i=1:numel(results)
%      
%       if results(i)==1 && output(i)==1
%          
%           error(i)=-1*net.cost_matrix(1); %true positive
%                
%       elseif results(i)==0 && output(i)==0
%          
%           error(i)=-1*net.cost_matrix(2); %true negative
%          
%       elseif results(i)==1 && output(i)==0
%          
%           error(i)=net.cost_matrix(3); %false positive
%        
%       elseif results(i)==0 && output(i)==1
%          
%           error(i)=net.cost_matrix(4); %false negative
%           
%       end
%       
%   end
    
 error=sum(error);



 %************Regression case
    

elseif strcmp(net.purpose,'regression')

    error=[];
    
    for i=1:size(input,2)
   
    results=eval_knet(net,input(:,i));
    
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