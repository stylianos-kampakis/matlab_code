%Debugging peirama

Discrepancy=1;

while Discrepancy>Discrepancy_inhibition
   
   for j=1:numel(result)
       %Discrepancy=0;      
       
       if(action_series_outputs(j)~=0 && out(j,i)==0)       
           Discrepancy=action_series_outputs(j); 
           action_series_inputs(action_series_inputs>0)=1;
  tic
              while (action_series_outputs(j)>Discrepancy_inhibition)
                  
                    pos_or_neg=sum(net.layer_weights{1}(j,:).*action_series_inputs);     
             
                    if pos_or_neg>=0
                    net.layer_weights{1}(j,:)=net.layer_weights{1}(j,:)-Inhibitory_momentum.*action_series_inputs;                                                                                                      
                    else                                
                    net.layer_weights{1}(j,:)=net.layer_weights{1}(j,:)+...
                    Inhibitory_momentum.*action_series_inputs.*(-sign2(net.layer_weights{1}(j,:)));                                                                                                        
                    end                     
                   [result , action_series]= eval_izknet(net,in(:,i));                                       
                   
                   action_series=cell2mat(action_series);  
                   action_series=clean_duplicates(action_series);
                   action_series_outputs=derive_action(action_series(first_index+1:second_index,:),0);                      
                   Discrepancy=action_series_outputs(j);                                   
     if toc>5
          ssd=3;
          break;
     end
              end
              
     if Discrepancy==1
        SKATA=232323; 
     end
     
%      if sum(out(:,i)==in(:,i))~=3
%         sdsdsds=3; 
%      end
              
       end        
   end   
end