% Created by Eugene M. Izhikevich, February 25, 2003
% Excitatory neurons    Inhibitory neurons
%close all
ne=1;

a=net_iris.a{1}(ne)
b=net_iris.b{1}(ne)
c=net_iris.c{1}(ne)
d=net_iris.d{1}(ne)

total_firings=[];


I=0;
v=-65;    % Initial values of v
u=b.*v; 
firings=[];             % spike timings
v_matrix=[];
for t=1:250            % simulation of 1000 ms
  % thalamic input  
  
  fired=find(v>=30);    % indices of spikes
  firings=[firings; t+0*fired,fired];
 

  x=v+0.04*v.^2+5*v+140-u+I; % step 0.5 ms
  
  if x<30 && v~=30
   v=x;
   u=u+a.*(b.*v-u);

   elseif v==30
     v=c;
     u=u+d;
  elseif x>30
      v=30;  

  end 
 
    v
  v_matrix=[v_matrix v];
  I=0;
  
  if t==100
     I=-300; 
  end  
  

end

if isempty(firings)
firings=Inf;  
end
total_firings=[total_firings;firings(1)];



% if (numel(firings)>0
% figure
% plot(firings(:,1),firings(:,2),'.');
% end

%figure
close all
hold on
plot(1:t,v_matrix);
firings;

%plot(0:0.1:75,total_firings)
xlabel('time (ms)')
ylabel('voltage (mV)')
