%This code runs the optimization procedure for the bursting neuron
%%
num_inputs=10;
%This part runs the genetic algorithm
options = gaoptimset('PlotFcns',@gaplotbestf,'PopulationSize',[100],'FitnessLimit',0);

objective_func=@(x)min_burst(x,num_inputs,0);

lb=[-10;-10;-90;-10;10];
ub=[10;10;-40;10;200];
[x,fval] = ga(objective_func,5,[],[],[],[],lb,ub,[],options);

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
total_timings=[];

timings_buffer=zeros(num_inputs,1);

for trials=1:num_inputs
I=0;
weight=x(5)*trials;
v=-65;
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

if isempty(timings)
timings=Inf;  
end
total_timings=[total_timings;timings(1)];

%Plot the results

hist(timings_buffer,40)

xlabel('number of timings')
ylabel('frequency')

figure
p=1:10;
p=p*x(5);
plot(p,timings_buffer)
xlabel('current')
ylabel('number of timings')