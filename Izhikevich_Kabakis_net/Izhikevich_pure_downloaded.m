% Created by Eugene M. Izhikevich, February 25, 2003
% Excitatory neurons    Inhibitory neurons
clear all
close all
INPUT_VOLTAGE=5;

Ne=800;                 Ni=200;
re=rand(Ne,1);          ri=rand(Ni,1);
a=[0.02*ones(Ne,1);     0.02+0.08*ri];
b=[0.2*ones(Ne,1);      0.25-0.05*ri];
c=[-65+15*re.^2;        -65*ones(Ni,1)];
d=[8-6*re.^2;           2*ones(Ni,1)];
S=[0.5*rand(Ne+Ni,Ne),  -rand(Ne+Ni,Ni)];

v=-65*ones(Ne+Ni,1);    % Initial values of v
u=b.*v;                 % Initial values of u
firings=[];             % spike timings
v_matrix=[];
for t=1:100            % simulation of 1000 ms
  I=[ones(Ne,1)*INPUT_VOLTAGE;ones(Ni,1)*INPUT_VOLTAGE]; % thalamic input
  fired=find(v>=30);    % indices of spikes
  firings=[firings; t+0*fired,fired];
  v(fired)=c(fired);
  u(fired)=u(fired)+d(fired);
  I=I+sum(S(:,fired),2);
  v=v+0.5*(0.04*v.^2+5*v+140-u+I); % step 0.5 ms
  v=v+0.5*(0.04*v.^2+5*v+140-u+I); % for numerical
  u=u+a.*(b.*v-u);                 % stability
  v_matrix=[v_matrix v];
end;
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