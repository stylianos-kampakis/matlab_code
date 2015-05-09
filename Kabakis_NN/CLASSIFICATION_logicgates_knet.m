%Initialize the network
net=init_kn([2 1])
net.ms=10;
net_XOR=trn_knet([0 1 1 0;1 0 1 0],[1 1 0 0],net)

[x]=eval_knet(net_XOR,[1;1])
[x]=eval_knet(net_XOR,[0;0])
[x]=eval_knet(net_XOR,[0;1])
[x]=eval_knet(net_XOR,[1;0])

net_AND=trn_knet([0 1 1 0;1 0 1 0],[0 0 1 0],net)

[x]=eval_knet(net_AND,[1;1])
[x]=eval_knet(net_AND,[0;0])
[x]=eval_knet(net_AND,[0;1])
[x]=eval_knet(net_AND,[1;0])

net_OR=trn_knet([0 1 1 0;1 0 1 0],[1 1 1 0],net)

[x]=eval_knet(net_OR,[1;1])
[x]=eval_knet(net_OR,[0;0])
[x]=eval_knet(net_OR,[0;1])
[x]=eval_knet(net_OR,[1;0])

net_NAND=trn_knet([0 1 1 0;1 0 1 0],[1 1 0 1],net)

[x]=eval_knet(net_NAND,[1;1])
[x]=eval_knet(net_NAND,[0;0])
[x]=eval_knet(net_NAND,[0;1])
[x]=eval_knet(net_NAND,[1;0])

net_NOR=trn_knet([0 1 1 0;1 0 1 0],[0 0 0 1],net)

[x]=eval_knet(net_NOR,[1;1])
[x]=eval_knet(net_NOR,[0;0])
[x]=eval_knet(net_NOR,[0;1])
[x]=eval_knet(net_NOR,[1;0])

net_XNOR=trn_knet([0 1 1 0;1 0 1 0],[0 0 1 1],net)

[x]=eval_knet(net_XNOR,[1;1])
[x]=eval_knet(net_XNOR,[0;0])
[x]=eval_knet(net_XNOR,[0;1])
[x]=eval_knet(net_XNOR,[1;0])
