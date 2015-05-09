function rebounds=find_rebounds(voltage,action_series_outputs,threshold)


    %Find the initial voltage and check whether before the firing the
    %voltage of a neuron fell below the initial voltage
    if iscell(voltage)
        voltage=cell2mat(voltage(size(voltage,1),:));
    end
    
    if iscell(action_series_outputs)
        action_series_outputs=cell2mat(action_series_outputs);
    end
    
    possible_rebound=zeros(size(voltage,1),1);
    for h=1:size(voltage,1)
       for o=1:size(voltage,2)
           
           if voltage(h,o)==30
              break; 
           end
           
          if voltage(h,o)<threshold;
              possible_rebound(h)=1;
          end
       end
    end
    
 action_series_outputs=sum(action_series_outputs,2);
 action_series_outputs(action_series_outputs>1)=1;
 
 rebounds=action_series_outputs.*possible_rebound;
    
    %The rebounds variable is included in the multiplications below. A
    %rebound spike needs an opposite treatment. If an inhibitory neuron
    %creates a spike, then we need to increase its weight, not lower it.
    rebounds(rebounds==1)=-1;
    rebounds(rebounds==0)=1;
    rebounds=rebounds';

end