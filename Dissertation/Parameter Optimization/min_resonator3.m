function res=min_resonator3(INPUT)


a=INPUT(1);
b=INPUT(2);
c=INPUT(3);
d=INPUT(4);
total_firings=[];


%%
%This part of the code is basically a copy of the Izhikevich's simulation.
%It simulates the model for 300ms 

I=0;
v=-65;    % Initial values of v
u=b.*v; 
firings=[];             % spike timings
v_matrix=[];
for t=1:300            % simulation of 1000 ms
  % thalamic input  
  
   
  fired=find(v>=30);    % indices of spikes
  firings=[firings; t+0*fired,fired];
  v(fired)=c(fired);
  u(fired)=u(fired)+d(fired);

  v=v+0.5*(0.04*v.^2+5*v+140-u+I); 
%    if v>30
%       v=30; 
%    end 
  u=u+a.*(b.*v-u);                 
  v_matrix=[v_matrix v];
  I=0;
  
  %Send the input at t=100
  if t==100
     I=100; 
  end  
  
end
%%
%In this part I calculate the objective function


%Here I calculate the derivative from t=130 up to t=300
cutoffpoint=120;


voltages=v_matrix(cutoffpoint:numel(v_matrix));

%Normalize the voltage values
voltages=(voltages-min(voltages))./(max(voltages)-min(voltages));

derivatives=diff(voltages)./diff(1:301-cutoffpoint);


res=0;

for s=1:2
   if derivatives(s)>0
      res=res-3; 
   end
end

for s=3:4
   if derivatives(s)<0
      res=res-3; 
   end
end

for s=5:6
   if derivatives(s)>0
       res=res-4;
   end
end

for s=7:8
   if derivatives(s)<0
      res=res-4; 
   end
end

for s=9:10
   if derivatives(s)>0
       res=res-8;
   end
end

for s=11:12
   if derivatives(s)<0
      res=res-8; 
   end
end


res=res-0.5*sum(abs(derivatives(1:30)))+size(firings,1)*0.5-0.5;

derivatives(1:70)=[];




end





