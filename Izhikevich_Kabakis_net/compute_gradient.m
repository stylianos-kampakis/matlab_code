function g=compute_gradient(net,in,weight_number,out_number,desired_out,excitatory,rebound,step)

original_weight=net.layer_weights{1}(weight_number);
[~,action_series]=eval_izknet(net,in);
action_series_inputs=derive_action(action_series(1,:),0);   
action_series_outputs=derive_action(action_series(2,:),net.ms);
original_output=action_series_outputs(out_number);




tic
if excitatory==1
   if rebound==1
       while action_series_outputs(out_number)<desired_out
        net.layer_weights{1}(weight_number)=net.layer_weights{1}(weight_number)-step;
        [~,action_series]=eval_izknet(net,in);
        action_series_outputs=derive_action(action_series(2,:),net.ms);
          if toc>5
            sds=44;
          end
          
            if abs(net.layer_weights{1}(weight_number))>5*abs(original_weight)
                g=0;
                break;
            end
            
            if abs(net.layer_weights{1}(weight_number))<abs(original_weight)/5
                g=0;
                break;
            end
       end
   else 
       while action_series_outputs(out_number)<desired_out
        net.layer_weights{1}(weight_number)=net.layer_weights{1}(weight_number)+step;
        [~,action_series]=eval_izknet(net,in);
        action_series_outputs=derive_action(action_series(2,:),net.ms);
            if toc>5
                sdsd=222; 
            end
            
            if abs(net.layer_weights{1}(weight_number))>5*abs(original_weight)
                g=0;
                break;
            end
            
            if abs(net.layer_weights{1}(weight_number))<abs(original_weight)/5
                g=0;
                break;
            end
       end
   end
else
    if rebound==1
        while action_series_outputs(out_number)>desired_out
         net.layer_weights{1}(weight_number)=net.layer_weights{1}(weight_number)+step;   
         [~,action_series]=eval_izknet(net,in);
         action_series_outputs=derive_action(action_series(2,:),net.ms);   
        
            if abs(net.layer_weights{1}(weight_number))>5*abs(original_weight)
                g=0;
                break;
            end
            
            if abs(net.layer_weights{1}(weight_number))<abs(original_weight)/5
                g=0;
                break;
            end
         
            if toc>5
                sds=44;
            end
        end
    else
        while action_series_outputs(out_number)>desired_out
         net.layer_weights{1}(weight_number)=net.layer_weights{1}(weight_number)-step;
         [~,action_series]=eval_izknet(net,in);
         action_series_outputs=derive_action(action_series(2,:),net.ms);
        
if abs(net.layer_weights{1}(weight_number))>5*abs(original_weight)
                g=0;
                break;
            end
            
            if abs(net.layer_weights{1}(weight_number))<abs(original_weight)/5
                g=0;
                break;
            end
         
            if toc>5
                sds=44;
            end
        end
    end
end

g=(net.layer_weights{1}(weight_number)-original_weight)/(original_output-desired_out);

if isnan(g)
   g=0; 
end