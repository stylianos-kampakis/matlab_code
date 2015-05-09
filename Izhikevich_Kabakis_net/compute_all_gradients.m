function g=compute_all_gradients(weights,net,in,out_number,desired_out,excitatory,rebound,step)
g=zeros(1,numel(weights));
[~,action_series]=eval_izknet(net,in);
 action_series_inputs=derive_action(action_series(1,:),0);
 
 
 action_series1=cell2mat(action_series(1,:));
 action_series2=cell2mat(action_series(2,:));

 
       for w=1:numel(weights)
        
           
       if action_series_inputs(w)~=0
        
        inputs=find(action_series1(w,:)==1);
        input=inputs(1);
        outputs=find(action_series2(out_number,:)==1);
        if ~(isempty(outputs))
            output=outputs(1);
             
            if ~(input>output)                     
            g(w)=compute_gradient(net,in,sub2ind(size(net.layer_weights{1}),out_number,w),out_number,...
            desired_out,excitatory,...
            rebound,step); 
            end    
        else
            g(w)=compute_gradient(net,in,sub2ind(size(net.layer_weights{1}),out_number,w),out_number,...
            desired_out,excitatory,...
            rebound,step); 
        end

       else
       g(w)=0;
       end 
end