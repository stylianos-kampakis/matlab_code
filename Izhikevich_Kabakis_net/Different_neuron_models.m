% Created by Eugene M. Izhikevich, February 25, 2003
% Excitatory neurons    Inhibitory neurons
clear all
close all

INITIAL_VOLTAGE=0;

Ne=1;                 
end_of_input=5;

a=[0.03*ones(Ne,1)];   
b=[0.25*ones(Ne,1)];     
c=[-65*ones(Ne,1)];
d=[4*ones(Ne,1)];   


total_firings=[];
firings=[];             % spike timings
v_matrix=[];
v=[];
u=[];
I=[];
for NNeurons=1:(Ne)
I=[I;INITIAL_VOLTAGE];
v=[v;-65];    % Initial values of v
u=[u;b(NNeurons).*v(NNeurons)]; 
end

for t=1:1000           % simulation of 1000 ms
  % thalamic input 
   
   for j=1:numel(v)
       
         x=v(j)+0.04*v(j).^2+5*v(j)+140-u(j)+I(j); 
         if ((x<30) && ((v(j))~=30))
             
                 %The model uses a timestep of 1 ms in case of smaller
                 %steps like 0.5, the model shows some unrealistic
                 %behavior with spikes exceeding 30mV.
                 v(j)=v(j)+1*(0.04*v(j).^2+5*v(j)+140-u(j)+I(j)); 
%                   v(j)=v(j)+0.5*(0.04*v(j).^2+5*v(j)+140-u(j)+I(j)); 
%                   v(j)=v(j)+0.5*(0.04*v(j).^2+5*v(j)+140-u(j)+I(j)); 
                  
               
                 u(j)=u(j)+a(j).*(b(j).*v(j)-u(j));  
                               
           %If the voltage is 30 update it to the post-firing condition
              elseif v(j)==30
              
                  v(j)=c(j);
                  u(j)=u(j)+d(j);
            %If the new voltage will get over 30 then make it 30 
              elseif x>30
                  
                  v(j)=30;
          end
   end
              
  fired=find(v==30);    % indices of spikes
  firings=[firings; t+0*fired,fired];
  v_matrix=[v_matrix v]; 
  
  if(t<end_of_input)      
    I=t*ones(Ne,1);
  end
end


figure
plot(firings(:,1),firings(:,2),'.');
xlabel('Time (in ms)');
ylabel('Neuron');
title('Raster plot');


figure
plot(1:t,v_matrix);
xlabel('Time (in ms)');
ylabel('Voltage');
title('Neuron voltage over time');
%Display the number of firings.
disp(['There was a total of ' num2str(numel(firings)) ' firings']);
