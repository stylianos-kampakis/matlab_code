function new_net=fit_train_izknet(in,out,net)
new_net=net;
new_net.layer_weights{1}=zeros(size(net.layer_weights{1}));

for i=1:size(in,2)
    
     x=find(in(:,i)==1);
     y=find(out(:,i)==1);
    
      %new_net.layer_weights{1}(out(:,i)==1,in(:,i)==1)=1;
     
      if i==106
          
      end
      
      if x(2)==106
      end
      
      
      if isempty(x)
      end
      
      if isempty(y)
      end
      
    for j=1:numel(x)
    new_net.layer_weights{1}(y,x(j))=1;
    end
    
    x=[];
    y=[];
    
end

for i=1:size(net.layer_weights{1},2)
   
    if net.layer_weights{1}(:,i)
        
    end
    
end

end