
%%

%This part runs the genetic algorithm
options = gaoptimset('PlotFcns',@gaplotbestf,'PopulationSize',150);

lb=[-10;-10;-85;-10];
ub=[10;10;-40;10];
[x,fval] = ga(@min_resonator_k,5,[],[],[],[],lb,ub,[],options);

%% 
%This part of the script reads the solution, simulates the neuron and plots
%the membrane voltage.

close all
Ne=1;  
a=x(1);
b=x(2);
c=x(3);
d=x(4);
re=rand(Ne,1);      
total_firings=[];

%This part of the code is actually based on the simulation provided by
%Izhikevich
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

  v=v+x(5)*(0.04*v.^2+5*v+140-u+I); % step 0.5 ms

  u=u+a.*(b.*v-u);                 % stability
  v_matrix=[v_matrix v];
  I=0;
  
  %Send an input at t=100
  if t==100
     I=100; 
  end  
  
end

if isempty(firings)
firings=Inf;  
end
total_firings=[total_firings;firings(1)];

%Here I calculate the derivative from t=130 up to t=300
cutoffpoint=115;


voltages=v_matrix(cutoffpoint:numel(v_matrix));
volt=voltages;
%Normalize the voltage values
voltages=(voltages-min(voltages))./(max(voltages)-min(voltages));

derivatives=diff(voltages)./diff(1:301-cutoffpoint);

%Plot the results

close all
plot(1:t,v_matrix);
firings
x
xlabel('time (ms)')
ylabel('voltage (mV)')