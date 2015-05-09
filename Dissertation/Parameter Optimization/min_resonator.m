function res=min_resonator(INPUT)

%Read the input
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

  v=v+(0.04*v.^2+5*v+140-u+I); 
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
cutoffpoint=115;


voltages=v_matrix(cutoffpoint:numel(v_matrix));

%Normalize the voltage values
voltages=(voltages-min(voltages))./(max(voltages)-min(voltages));

derivatives=diff(voltages)./diff(1:301-cutoffpoint);


res=zeros(10,1);

%This is the code that looks for symmetrical patterns

for results=1:10

    for hh=results+1:numel(derivatives)-results
        if checksign(derivatives(hh:hh+results-1))>0 && checksign(derivatives(hh-results:hh-1))<0
            res(results)=res(results)-1;
        elseif checksign(derivatives(hh))<0 && checksign(derivatives(hh-results))>0
            res(results)=res(results)-1;
        end   
    end   
    divider=hh/(results+1);
    res(results)=res(results)/divider;
end

%The objective function will keep only the score for the best interval. The
%reason is that some intervals exclude others. For example, if the
%derivative changes sign every three timesteps, we would actually expect a
%higher score for that pattern, rather than the case where we check whether
%the derivative changes its sign on every timestep.

res=min(res)+size(firings,1);



end





