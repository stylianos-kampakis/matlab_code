function res=min_burst(INPUT,numinputs,monotonic)

%Read the inputs
a=INPUT(1);
b=INPUT(2);
c=INPUT(3);
d=INPUT(4);
total_timings=[];

timings_buffer=zeros(10,1);

%%
%This part of the code is basically a copy of the Izhikevich's simulation.
%It simulates the model for 300ms 


for trials=1:numinputs
weight=INPUT(5)*trials;
I=0;
v=-65;    % Initial values of v
u=b.*v; 
timings=[]; 
v_matrix=[];
for t=1:200 
  
   
  if v>=30;
  timings=[timings; t];
  v=c;
  u=u+d; 
  end
 
  
  v=v+(0.04*v.^2+5*v+140-u+I);   
  u=u+a.*(b.*v-u);    
  v_matrix=[v_matrix v];
  I=0;
  
  %Send the input at t=100
  if t==100
     I=weight; 
  end  
  
  timings_buffer(trials)= numel(timings);
  
end
end

penalty=0;

%Find any timings before 100ms where we apply the stimulus. These are
%autonomous spikes which are not desirable
if ~isempty(timings)
dummy=timings(:,1);
penalty=numel(find(dummy<100));
end

%Check if we are looking for monotonic or non-monotonic patterns

if monotonic==1
for j=2:numel(timings_buffer)
%If we are looking for monotonic patterns then check whether the timings
%are sorted

   for l=1:j-1
      if timings_buffer(j)<=timings_buffer(l)
         penalty=penalty+1; 
      end
   end
   
   
   
end
else
for item1=1:numel(timings_buffer)
    %if we are not looking for monotonic patterns we just want the timings
    %to be different
    for item2=1:numel(timings_buffer)
        if timings_buffer(item1)==timings_buffer(item2)
           
            if item1~=item2
              penalty=penalty+1; 
            end
            
        end
    end

    
end
    
%If the neuron has fired too many spikes penalize it in order to avoid
%having a neuron that never stops spiking after the initial stimulation
   if max(timings_buffer)>=80
      penalty=penalty+max(timings_buffer); 
   end  

end


res=penalty;

end





