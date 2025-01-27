average_difference=0;
average_time=0;
MLP_time=0;

for i=1:100

tic
[x]=eval_izknet(net_XOR,[1;1])
[x]=eval_izknet(net_XOR,[0;0])
[x]=eval_izknet(net_XOR,[0;1])
[x]=eval_izknet(net_XOR,[1;0])
time_XOR=toc


tic

[x]=eval_izknet(net_AND,[1;1])
[x]=eval_izknet(net_AND,[0;0])
[x]=eval_izknet(net_AND,[0;1])
[x]=eval_izknet(net_AND,[1;0])
time_AND=toc


tic
[x]=eval_izknet(net_OR,[1;1])
[x]=eval_izknet(net_OR,[0;0])
[x]=eval_izknet(net_OR,[0;1])
[x]=eval_izknet(net_OR,[1;0])
time_OR=toc

tic
[x]=eval_izknet(net_NAND,[1;1])
[x]=eval_izknet(net_NAND,[0;0])
[x]=eval_izknet(net_NAND,[0;1])
[x]=eval_izknet(net_NAND,[1;0])
time_NAND=toc

tic
[x]=eval_izknet(net_NOR,[1;1])
[x]=eval_izknet(net_NOR,[0;0])
[x]=eval_izknet(net_NOR,[0;1])
[x]=eval_izknet(net_NOR,[1;0])
time_NOR=toc

tic
[x]=eval_izknet(net_XNOR,[1;1])
[x]=eval_izknet(net_XNOR,[0;0])
[x]=eval_izknet(net_XNOR,[0;1])
[x]=eval_izknet(net_XNOR,[1;0])
time_XNOR=toc

average_time=average_time+(time_XOR+time_AND+time_OR+time_NAND+time_NOR+time_XNOR)/6

%MULTILAYER PECEPTRON
%XOR
in=[0 0 1 1;1 0 1 0]
out=[1 0 0 1]
netff=newff(in,out,2)
netff.divideParam.trainRatio=100;
init(netff)
[netff,~,~,E]=train(netff,in,out)
tic
sim(netff,[0;0])
sim(netff,[1;1])
sim(netff,[0;1])
sim(netff,[1;0])
MLP_XOR=toc

%OR
in=[0 0 1 1;1 0 1 0]
out=[1 0 1 1]
netff=newff(in,out,2)
netff.divideParam.trainRatio=100;
init(netff)
[netff,~,~,E]=train(netff,in,out)
tic
sim(netff,[0;0])
sim(netff,[1;1])
sim(netff,[0;1])
sim(netff,[1;0])
MLP_OR=toc

%AND
in=[0 0 1 1;1 0 1 0]
out=[0 0 1 0]
netff=newff(in,out,2)
netff.divideParam.trainRatio=100;
init(netff)
[netff,~,~,E]=train(netff,in,out)
tic
sim(netff,[0;0])
sim(netff,[1;1])
sim(netff,[0;1])
sim(netff,[1;0])
MLP_AND=toc

%NAND
in=[0 0 1 1;1 0 1 0]
out=[1 1 0 1]
netff=newff(in,out,2)
netff.divideParam.trainRatio=100;
init(netff)
[netff,~,~,E]=train(netff,in,out)
tic
sim(netff,[0;0])
sim(netff,[1;1])
sim(netff,[0;1])
sim(netff,[1;0])
MLP_NAND=toc

%NOR
in=[0 0 1 1;1 0 1 0]
out=[0 1 0 0]
netff=newff(in,out,2)
netff.divideParam.trainRatio=100;
init(netff)
[netff,~,~,E]=train(netff,in,out)
tic
sim(netff,[0;0])
sim(netff,[1;1])
sim(netff,[0;1])
sim(netff,[1;0])
MLP_NOR=toc

%XNOR
in=[0 0 1 1;1 0 1 0]
out=[0 1 1 0]
netff=newff(in,out,2)
netff.divideParam.trainRatio=100;
init(netff)
[netff,~,~,E]=train(netff,in,out)
tic
sim(netff,[0;0])
sim(netff,[1;1])
sim(netff,[0;1])
sim(netff,[1;0])
MLP_XNOR=toc

MLP_time=MLP_time+(MLP_XOR+MLP_NOR+MLP_XNOR+MLP_AND+MLP_NAND+MLP_OR)/6

end

average_time=average_time/i
MLP_time=MLP_time/i

average_difference=average_time-MLP_time
