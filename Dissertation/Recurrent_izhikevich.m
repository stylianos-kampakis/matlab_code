% Created by Eugene M. Izhikevich, February 25, 2003
% Excitatory neurons    Inhibitory neurons
Ne=800;                 Ni=200;
re=rand(Ne,1);          ri=rand(Ni,1);
a=[0.03*ones(Ne,1);     0.03*ones(Ni,1)];
b=[0.25*ones(Ne,1);      0.25*ones(Ni,1)];
c=[-60*ones(Ne,1);        -60*ones(Ni,1)];
d=[4*ones(Ne,1);           4*ones(Ni,1)];
S=[0.5*rand(Ne+Ni,Ne),  -rand(Ne+Ni,Ni)];

v=-65*ones(Ne+Ni,1);    % Initial values of v
u=b.*v;                 % Initial values of u
firings=[];             % spike timings

weights=rand(Ne+Ni);

connectivity=0.01;

weights(rand(Ne+Ni)>connectivity)=0;

for i=1:Ne+Ni
   weights(i,i)=0; 
   if i>800
   weights(i,:)=-2*weights(i,:);   
   end    
end




wI=zeros(Ne+Ni,1);
I=[100*rand(Ne+Ni,1)];
for t=1:1000            % simulation of 1000 ms
   % thalamic input
  fired=find(v>=30);    % indices of spikes
  firings=[firings; t+0*fired,fired];
  v(fired)=c(fired);
  u(fired)=u(fired)+d(fired);
  %I=I+sum(S(:,fired),2);
  v=v+0.5*(0.04*v.^2+5*v+140-u+I+wI); % step 0.5 ms
  
  u=u+a.*(b.*v-u);                 % stability

  action_matrix=v;
  action_matrix(action_matrix>=30)=1;
  action_matrix(action_matrix~=1)=0;
  
  wI=weights*action_matrix;
  I=0;
end;

close all
plot(firings(:,1),firings(:,2),'.');
figure
hist(firings(:,2))

