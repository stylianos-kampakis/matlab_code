options=izknet_optionset('Initialization','whatever');

net=izknet([2 1],options);
% net.layer_weights{1}=net.layer_weights{1}*122;
% net.layer_weights{2}=net.layer_weights{2}*70;
% [x y c]=eval_izknet_old(net,[0.4;0.4;0.3;0.1;0]);
% plot(1:1:100,cell2mat(c(3,:)));
% x

net_XOR=trn_izknet([0 1 1 0;1 0 1 0],[1 1 0 0],net)

%net_XOR=trn_izknet([0 1;1 0;0 0;1 1],[1;1 ;0; 0],net)


[x]=eval_izknet(net_XOR,[1;1])
[x]=eval_izknet(net_XOR,[0;0])
[x]=eval_izknet(net_XOR,[0;1])
[x]=eval_izknet(net_XOR,[1;0])

net_AND=trn_izknet([0 1 1 0;1 0 1 0],[0 0 1 0],net)

[x]=eval_izknet(net_AND,[1;1])
[x]=eval_izknet(net_AND,[0;0])
[x]=eval_izknet(net_AND,[0;1])
[x]=eval_izknet(net_AND,[1;0])

net_OR=trn_izknet([0 1 1 0;1 0 1 0],[1 1 1 0],net)

[x]=eval_izknet(net_OR,[1;1])
[x]=eval_izknet(net_OR,[0;0])
[x]=eval_izknet(net_OR,[0;1])
[x]=eval_izknet(net_OR,[1;0])

net_NAND=trn_izknet([0 1 1 0;1 0 1 0],[1 1 0 1],net)

[x]=eval_izknet(net_NAND,[1;1])
[x]=eval_izknet(net_NAND,[0;0])
[x]=eval_izknet(net_NAND,[0;1])
[x]=eval_izknet(net_NAND,[1;0])

net_NOR=trn_izknet([0 1 1 0;1 0 1 0],[0 0 0 1],net)

[x]=eval_izknet(net_NOR,[1;1])
[x]=eval_izknet(net_NOR,[0;0])
[x]=eval_izknet(net_NOR,[0;1])
[x]=eval_izknet(net_NOR,[1;0])

net_XNOR=trn_izknet([0 1 1 0;1 0 1 0],[0 0 1 1],net)

[x]=eval_izknet(net_XNOR,[1;1])
[x]=eval_izknet(net_XNOR,[0;0])
[x]=eval_izknet(net_XNOR,[0;1])
[x]=eval_izknet(net_XNOR,[1;0])
