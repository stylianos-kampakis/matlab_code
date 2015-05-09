%Initialize the izknet
net=izknet([2 2]);

options=gaoptimset('PlotFcns',@gaplotbestf,'Generations',150,...
    'PopInitRange',[-50;50],'PopulationSize',[50;50],...
    'CrossoverFraction',0.6,'Elite',0,'FitnessLimit',0,...
    'UseParallel','always');

net_XOR=trn_izknet([0 1 1 0;1 0 1 0],[1 1 0 0;0 0 1 1],net,options,-15,15)

[x]=eval_izknet(net_XOR,[1;1])
[x]=eval_izknet(net_XOR,[0;0])
[x]=eval_izknet(net_XOR,[0;1])
[x]=eval_izknet(net_XOR,[1;0])

net_AND=trn_izknet([0 1 1 0;1 0 1 0],[0 0 1 0;1 1 0 1],net)

[x]=eval_izknet(net_AND,[1;1])
[x]=eval_izknet(net_AND,[0;0])
[x]=eval_izknet(net_AND,[0;1])
[x]=eval_izknet(net_AND,[1;0])

net_OR=trn_izknet([0 1 1 0;1 0 1 0],[1 1 1 0;0 0 0 1],net)

[x]=eval_izknet(net_OR,[1;1])
[x]=eval_izknet(net_OR,[0;0])
[x]=eval_izknet(net_OR,[0;1])
[x]=eval_izknet(net_OR,[1;0])

net_NAND=trn_izknet([0 1 1 0;1 0 1 0],[1 1 0 1;0 0 1 0],net)

[x]=eval_izknet(net_NAND,[1;1])
[x]=eval_izknet(net_NAND,[0;0])
[x]=eval_izknet(net_NAND,[0;1])
[x]=eval_izknet(net_NAND,[1;0])

net_NOR=trn_izknet([0 1 1 0;1 0 1 0],[0 0 0 1;1 1 1 0],net)

[x]=eval_izknet(net_NOR,[1;1])
[x]=eval_izknet(net_NOR,[0;0])
[x]=eval_izknet(net_NOR,[0;1])
[x]=eval_izknet(net_NOR,[1;0])

net_XNOR=trn_izknet([0 1 1 0;1 0 1 0],[0 0 1 1;1 1 0 0],net)

[x]=eval_izknet(net_XNOR,[1;1])
[x]=eval_izknet(net_XNOR,[0;0])
[x]=eval_izknet(net_XNOR,[0;1])
[x]=eval_izknet(net_XNOR,[1;0])
