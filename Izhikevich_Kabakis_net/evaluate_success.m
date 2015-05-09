function success=evaluate_success(in,out,net)

epoch_results=zeros(size(out,1),size(out,2));

for i=1:size(in,2)
    
   epoch_results(:,i)=eval_izknet(net,in(:,i));
    
end

epoch_results=(epoch_results==out);
success=sum(sum(epoch_results))/numel(epoch_results);
end