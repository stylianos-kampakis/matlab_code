%Genetic optimization for the rebound spiking neuron
%%
low_th=-100;
up_th=100;

object_func=@(x) min_rebound_k(x,low_th,up_th);
%This part runs the genetic algorithm
options = gaoptimset('Generations',15,'PlotFcns',@gaplotbestf,'PopulationSize',[100],'FitnessLimit',0);

lb=[-10;-10;-90;-10];
ub=[10;10;-40;10];
[x,fval] = ga(object_func,5,[],[],[],[],lb,ub,[],options);

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



timings_buffer=zeros(10,1);
I=0;

for kk=1:2
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
    if kk==1  
      
     I=low_th;
     
    end
    
    if kk==2
        I=up_th;
    end
    
    
  end  
  
%Plot the results
if kk==1

  plot(v_matrix)
else
    hold on
    plot(v_matrix,'red');
 end

end


end

title(['Upper threshold: ' num2str(up_th) ' , lower threshold: ' , num2str(low_th)])
xlabel('time (ms)')
ylabel('voltage (mV)')
disp(x)