total_iterations=1;
time=[];
all_success=[];
total_epochs=[];


for iterations=1:total_iterations
options_for_training=pure_train_optionset('Epochs', 1000, ...
'Inhibitory','true', ...
'Excitatory','true', ...
'Inhibitory_function','tansig', ...
'Excitatory_function','tansig', ...
'Inhibitory_momentum',0.02, ...
'Excitatory_momentum',0.02, ...
'Inhibitory_momentum_degradation',0, ...
'Excitatory_momentum_degradation',0, ...
'Inhibitory_learning_rate',0.02, ...
'Excitatory_learning_rate',0.02, ...
'Target_success',0.95, ...
'Randomize_batch','true', ...
'Renew_weights','true',...
'Epochs_for_renewal',10,...
'Report','false');

disp('Testing logic gates networks')
tic
net_XOR=izknet([2 1]);

[net_XOR success]=pure_train_izknet3(net_XOR,[0 1 1 0;1 0 1 0],[1 1 0 0],options_for_training);
all_success=[all_success success(numel(success))];
total_epochs=[total_epochs numel(success)];

net_AND=izknet([2 1]);

[net_AND success]=pure_train_izknet3(net_AND,[0 1 1 0;1 0 1 0],[0 0 1 0],options_for_training);
all_success=[all_success success(numel(success))];
total_epochs=[total_epochs numel(success)];

net_OR=izknet([2 1]);

[net_OR success]=pure_train_izknet3(net_OR,[0 1 1 0;1 0 1 0],[1 1 1 0],options_for_training);
all_success=[all_success success(numel(success))];
total_epochs=[total_epochs numel(success)];


net_NAND=izknet([2 1]);

[net_NAND success]=pure_train_izknet3(net_NAND,[0 1 1 0;1 0 1 0],[1 1 0 1],options_for_training);
all_success=[all_success success(numel(success))];
total_epochs=[total_epochs numel(success)];

net_NOR=izknet([2 1]);

[net_NOR success]=pure_train_izknet3(net_NOR,[0 1 1 0;1 0 1 0],[0 0 0 1],options_for_training);
all_succcess=[all_success success(numel(success))];
total_epochs=[total_epochs numel(success)];

net_XNOR=izknet([2 1]);

[net_XNOR success]=pure_train_izknet3(net_XNOR,[0 1 1 0;1 0 1 0],[0 0 1 1],options_for_training);
all_success=[all_success success(numel(success))];
total_epochs=[total_epochs numel(success)];
time=[time toc];


end


total_epochs=mean(total_epochs)
all_success=mean(all_success)
time=mean(time)