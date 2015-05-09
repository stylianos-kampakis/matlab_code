clear all
close all

n=1;


%%%% neuron parameters ,time in ms%%%
vrest	= -60;
vreset 	= -60;
vthr	= -50;
taum 	= 20;
rm		= 1;

%%%%synapse parameters %%%
vrev	= 0;
vrev 	= -80;
 
trefr	= 5;


tend	= 500; % total time msec
dt		= 0.1; % smaller would be better, but is slow
ndt		= round(tend/dt);
tau_e=80;
% Initialize variables
vm 		= vrest*ones(n,1);
g		= zeros(n,1);

spikes 	= zeros(n,ndt,'uint8');  % binary array of spikes vs time
lastspiketime	= -1000*ones(1,n); % time since last spike, for refractoriness
sptimes = zeros(n,round(tend*10e-3),'single'); % guess 10Hz av rate
nsp		= zeros(n,1); % # spikes for each neuron







% simulate
tmin=0; % don't measure spikes before tmin
ntmin=round(tmin/dt);
I=100;
firstspiketime=[];
skata=[];
for idt=1:ndt-1
    t=idt*dt;


    vmnext = vm + dt /taum*(vrest-vm+I*rm);

   
    refr= find(lastspiketime> t-trefr);
    vmnext(refr)=vreset;
    
    sp=(vmnext > vthr); % vector with spikes
    spi=find(sp); % indices
    if (size(spi)>0)
        spikes(spi,idt+1)=1*(t>tmin);
        vmnext(spi) = vreset;
        lastspiketime(spi) = t;
        if isempty(firstspiketime)
           firstspiketime=t; 
        end
        for j=1:length(spi)*(t>tmin)
            k=spi(j);
            nsp(k)=nsp(k)+1;
            sptimes(k,nsp(k))=t;
        end


    end
    %ge = ge*(1-dt/tau_e);
%I=I*(1-dt/tau_e);
if idt>1000
   I=50; 
end

skata=[skata I];
    vm=vmnext;
end
