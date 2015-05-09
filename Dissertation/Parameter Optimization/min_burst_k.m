function res=min_burst_k(INPUT,numinputs,monotonic)

%Read the inputs
a=INPUT(1);
b=INPUT(2);
c=INPUT(3);
d=INPUT(4);
total_firings=[];

firings_buffer=zeros(10,1);

%%
%This part of the code is basically a copy of the Izhikevich's simulation.
%It simulates the model for 300ms 


for trials=1:numinputs
weight=INPUT(5)*trials;
I=0;
v=-65;    % Initial values of v
u=b.*v; 
firings=[];             % spike timings
v_matrix=[];
for t=1:200            % simulation of 1000 ms
  % thalamic input  
  
   
  fired=find(v>=30);    % indices of spikes
  firings=[firings; t+0*fired,fired];
  v(fired)=c(fired);
  u(fired)=u(fired)+d(fired);

 
  
  v=v+INPUT(6)*(0.04*v.^2+5*v+140-u+I); 
%   if v>30
%      v=30; 
%   end
  
  u=u+a.*(b.*v-u);    
  
  
   
  v_matrix=[v_matrix v];
  I=0;
  
  %Send the input at t=100
  if t==100
     I=weight; 
  end  
  
  firings_buffer(trials)= numel(firings);
  
end
end

penalty=0;

%Find any firings before 100ms where we apply the stimulus. These are
%autonomous spikes which are not desirable
if ~isempty(firings)
dummy=firings(:,1);
penalty=numel(find(dummy<100));
end

%Check if we are looking for monotonic or non-monotonic patterns

if monotonic==1
for j=2:numel(firings_buffer)
%If we are looking for monotonic patterns then check whether the firings
%are sorted

   for l=1:j-1
      if firings_buffer(j)<=firings_buffer(l)
         penalty=penalty+1; 
      end
   end
   
   
   
end
else
for item1=1:numel(firings_buffer)
    %if we are not looking for monotonic patterns we just want the firings
    %to be different
    for item2=1:numel(firings_buffer)
        if firings_buffer(item1)==firings_buffer(item2)
           
            if item1~=item2
              penalty=penalty+1; 
            end
            
        end
    end

    
end
    
%If the neuron has fired too many spikes penalize it in order to avoid
%having a neuron that never stops spiking after the initial stimulation
   if max(firings_buffer)>=80
      penalty=penalty+max(firings_buffer); 
   end  

end


res=penalty;

if res<4
   sdsds=23; 
end
end





