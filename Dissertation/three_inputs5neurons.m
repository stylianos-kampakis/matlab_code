numinputs=3;
neurons=5;

inputs=combn([0 1],numinputs);

myfunc=@(x)garebound(x,neurons,numinputs,inputs);

options = gaoptimset('PlotFcns',@gaplotbestf,'PopulationSize',[100;100],'StallGenLimit',...
    200,'CrossoverFraction',0.6);

total_in=neurons*numinputs+2*neurons;

lb=[];
ub=[];
[x,fval] = ga(myfunc,total_in,[],[],[],[],lb,ub,[],options);

input=x;

w=reshape(input(1:numinputs*neurons),neurons,numinputs);
input(1:numinputs*neurons)=[];
pos=input(1:neurons)';
input(1:neurons)=[];
neg=input';

w

pos
neg

for i=1:size(inputs,1)
    
    res=w*inputs(i,:)';
    res(res>pos)=1;
    res(res<neg)=1;
    res(res~=1)=0;
    
    res=sum(res);
    
    
    [num2str(inputs(i,:)) ,' results in ' ,num2str(res)]
end