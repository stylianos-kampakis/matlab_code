function res=min_resonator2(INPUT)


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

for s=1:20
   if derivatives(s)>0
      res=res-3; 
   end
end

for s=21:40
   if derivatives(s)<0
      res=res-3; 
   end
end

for s=41:50
   if derivatives(s)>0
       res=res-5;
   end
end

for s=51:60
   if derivatives(s)<0
      res=res-5; 
   end
end

for s=61:65
   if derivatives(s)>0
       res=res-7;
   end
end

for s=66:70
   if derivatives(s)<0
      res=res-7; 
   end
end


res1=res-0.5*sum(abs(derivatives(1:30)))+size(firings,1);

derivatives(1:70)=[];
res=zeros(10,1);




%The objective function will subtract one point for every consecutive
%intervals that had changing signs. We keep a record for 10 different
%intervals.
for results=1:10

    for hh=results+1:numel(derivatives)-results
        if sum(derivatives(hh:hh+results-1))>0 && sum(derivatives(hh-results:hh-1))<0
            res(results)=res(results)-1;
        elseif sum(derivatives(hh))<0 && sum(derivatives(hh-results))>0
            res(results)=res(results)-1;
        end   
    end   
   
end



%The objective function will keep only the score for the best interval. The
%reason is that some intervals exclude others. For example, if the
%derivative changes sign every three timesteps, we would actually expect a
%higher score for that pattern, rather than the case where we check whether
%the derivative changes its sign on every timestep.

res2=min(res)-0.7*sum(abs(derivatives));

res=[res1 res2];

end





