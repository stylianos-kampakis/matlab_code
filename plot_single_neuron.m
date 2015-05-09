% Created by Eugene M. Izhikevich, February 25, 2003
% Excitatory neurons    Inhibitory neurons

input=100;

layer=1;
neuron=2;
     
a=net_iris.a{layer}(neuron);
b=net_iris.b{layer}(neuron);
c=net_iris.c{layer}(neuron);
d=net_iris.d{layer}(neuron);
S=1;

I=0;
v=-65;    % Initial values of v
u=b.*v;                 % Initial values of u
             % spike timings
v_matrix=[];
for t=1:100            % simulation of 1000 ms

  if(t==50)
     I=input; 
  end
  
  v=v+(0.04*v.^2+5*v+140-u+I); % 
  u=u+a.*(b.*v-u);                 % stability
  
  if(v==30)
      v=c;
      u=u+d;
  end
  
  if(v>30)
      v=30;
  end
  
  v_matrix=[v_matrix v];
  I=0;
end;

plot(v_matrix)