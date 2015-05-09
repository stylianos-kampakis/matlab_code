% Created by Eugene M. Izhikevich, February 25, 2003
% Excitatory neurons    Inhibitory neurons
%close all
Ne=1;                 Ni=0;
re=rand(Ne,1);          ri=rand(Ni,1);
a=[0.02;     0.02+0.08*ri];
b=[0.256;      0.25-0.05*ri];
c=[-55;        -65*ones(Ni,1)];
d=[0.05;           2*ones(Ni,1)];
S=[0.5*rand(Ne+Ni,Ne),  -rand(Ne+Ni,Ni)];

total_firings=[];

freq_of_input=0;
noise=0;
frequencies=[];


weight=255;

I=0;
v=-65;    % Initial values of v
u=b.*v; 
firings=[];             % spike timings
v_matrix=[];
for t=1:800            % simulation of 1000 ms
  % thalamic input  
  
   
  fired=find(v>=30);    % indices of spikes
  firings=[firings; t+0*fired,fired];
  v(fired)=c(fired);
  u(fired)=u(fired)+d(fired);

  v=v+0.5*(0.04*v.^2+5*v+140-u+I); % step 0.5 ms

  u=u+a.*(b.*v-u);                 % stability
  v_matrix=[v_matrix v];
  I=0;
  

%   if t>99 && mod(t,10)==0
%     if rand>noise
%       I=weight;
%       freq_of_input=freq_of_input+1;
%     end
%   end

if t==300
   I=weight; 
end

end

if isempty(firings)
firings=Inf;  
end
total_firings=[total_firings;firings(1)];

count_spikes=v_matrix(100:200);
count_spikes=round(count_spikes);
count_spikes(count_spikes==max(count_spikes))=1;
count_spikes(count_spikes==min(count_spikes))=-1;






% close all
% 
plot(1:t,v_matrix);
numel(firings)


