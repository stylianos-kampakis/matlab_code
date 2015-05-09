% Created by Eugene M. Izhikevich, February 25, 2003
% Excitatory neurons    Inhibitory neurons
%close all
Ne=1;                 Ni=0;

a=x(1);
b=x(2);
c=x(3);
d=x(4);

total_firings=[];

freq_of_input=0;
noise=0.1;
frequencies=[];
modder=10;

weights=[];

for trial=1:100
weight=100+10*trial;

I=0;
v=-65;    % Initial values of v
u=b.*v; 
firings=[];             % spike timings
v_matrix=[];
weights=[weights weight];
for t=1:1100            % simulation of 1000 ms
  % thalamic input  
  
   
  fired=find(v>=30);    % indices of spikes
  firings=[firings; t+0*fired,fired];
  v(fired)=c(fired);
  u(fired)=u(fired)+d(fired);

  v=v+0.5*(0.04*v.^2+5*v+140-u+I); % step 0.5 ms

  u=u+a.*(b.*v-u);                 % stability
  v_matrix=[v_matrix v];
  I=0;
  

  if (t>99 && mod(t,modder)==0)
    
      I=weight;
      freq_of_input=freq_of_input+1;
  elseif (t>99) && rand<noise
      I=150;
       freq_of_input=freq_of_input+1;
      
  end
% 
% if rand<0.25
%     I=weight;
% end
 
end

if isempty(firings)
firings=Inf;  
end
total_firings=[total_firings;firings(1)];

count_spikes=v_matrix(100:200);
count_spikes=round(count_spikes);
count_spikes(count_spikes==max(count_spikes))=1;
count_spikes(count_spikes==min(count_spikes))=-1;

freq=numel(find(count_spikes==1));

%desired_freq=modder/700
freq_of_input=freq_of_input/(t-100)
newfreq=size(firings,1)/(t-100)

frequencies=[frequencies newfreq];
end

% close all
% 
% plot(1:t,v_matrix);
% numel(firings)

%hold on
plot(weights,frequencies);
xlabel('current (mV)')
ylabel('frequency (Hz)')