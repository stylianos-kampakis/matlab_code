% Created by Eugene M. Izhikevich, February 25, 2003
% Excitatory neurons    Inhibitory neurons

close all

INITIAL_VOLTAGE=5;

Ne=800;                 Ni=200;
re=rand(Ne,1);          ri=rand(Ni,1);
a=[0.02*ones(Ne,1);     0.02+0.08*ri];
b=[0.2*ones(Ne,1);      0.25-0.05*ri];
c=[-65+15*re.^2;        -65*ones(Ni,1)];
d=[8-6*re.^2;           2*ones(Ni,1)];
S=[0.5*rand(Ne+Ni,Ne),  -rand(Ne+Ni,Ni)];

total_firings=[];
firings=[];             % spike timings
v_matrix=[];
v=[];
u=[];
I=[];
for NNeurons=1:(Ne+Ni)
I=[I;INITIAL_VOLTAGE];
v=[v;-65];    % Initial values of v
u=[u;b(NNeurons).*v(NNeurons)]; 
end

for t=1:100           % simulation of 1000 ms
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
  
  
 I=zeros(Ne+Ni,1);

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
