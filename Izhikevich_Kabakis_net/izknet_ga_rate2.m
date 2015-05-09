function error=izknet_ga_rate2(input,output,net,weights)

if strcmp(net.type,'feedforward')
previous=0;
    for i=1:numel(net.layers)-1
        
        net.layer_weights{i}=weights(previous+1:previous+(net.layers(i)*net.layers(i+1)));
        
        net.layer_weights{i}=reshape(net.layer_weights{i},net.layers(i+1),net.layers(i));
        
        previous=(net.layers(i)*net.layers(i+1));
    end

end

net.separators=[weights(numel(weights)-net.layers(2)+1:numel(weights))];

results=[];


if strcmp(net.purpose,'classification') || strcmp(net.purpose,'regression')

for i=1:size(input,2)
   
    results=[results eval_izknet_rate2(net,input(:,i))];
    
end

%**************Error metrics
    results=(results==output);
    
    %Original error
    error=numel(results(results==0))/numel(results);

% %Error with cost matrix
%     error=numel(results(results==0));
%     
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
%     
%   error=sum(error);

% homog=0;
% 
% for j=1:size(results,2)
%    
%     if sum(results(:,j))>0
%      homog=homog+sum(results(:,j))-net.number_of_outputs;
%     else
%      homog=homog+net.number_of_outputs;        
%     end
% end
% 
% results=(results==output & output==1);
% 
% results_summed=sum(results,2);
% 
% results_correct=results_summed/size(results,2);
% 
% %Alternative metric
% % error1=sum(1-results_correct);
% % error2=max(1-results_correct);
% % error=error1+error2-min(results_correct);
% 
% %error=error/(size(results,1)+1);
%  
% 
% error_all=sum(1-results_correct);
% error_max=max(1-results_correct);
% error_min=min(1-results_correct);
% success_max=max(results_correct);
% success_min=min(results_correct);
% 
% normalized_error_all=error_all/net.layers(net.output_layer);
% %normalized_error_max=error_max;
% %normalized_error_min=error_min;
% %normalized_success_max=success_max;
% normalized_homog=homog/(prod(size(results))-size(results,2)*net.number_of_outputs);
% 
% %Alternative metric
% error=1.25*normalized_error_all+1*error_max-1*success_max-1*log(success_min)+1*normalized_homog;
% 

 %************Regression case
    

elseif strcmp(net.purpose,'regression')

    error=[];
    
    for i=1:size(input,2)
   
    results=eval_izknet_rate2(net,input(:,i));
    
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