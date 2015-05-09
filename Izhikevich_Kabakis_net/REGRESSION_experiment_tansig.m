%Regression experiment
pure_data=[-10:0.5:10 tansig(-10:0.5:10)];

all_data=normalize_data(pure_data,[-10:0.5:10 tansig(-10:0.5:10)]);

in=normalize_data(-10:0.5:10,pure_data);
out=normalize_data(tansig(-10:0.5:10),pure_data);

%net=init_izkn([41 41],[],'regression',50,[1 1 1 1],[],[],[],[],60,60,[0 1;0.4579 1],[],[],sort(out'));
options=izknet_optionset('Purpose','regression','Sensor_ranges',[0 1;min(out) max(out)]);
net=izknet([121 121],options)

in_t=truth_table(net,in,0);
out_t=truth_table(net,out,1);

%net=trn_izknet(truth_table(net,in,0),truth_table(net,out,1),net)
net=fit_train_izknet(in_t,out_t,net);

out_net=[];
for i=1:numel(in)
out_net=[out_net eval_izknet(net,in(i))];
end

% for i=1:numel(in)
%     x=eval_izknet(net,in(i));
%     x=x(1);
% out_net=[out_net x];
% end
% 
% if (out_net(1))
% out_net(1)=0;
% end
% 
% for i=2:numel(out_net)
%    if isnan(out_net(i))
%       out_net(i)=out_net(i-1); 
%    end
% end
figure(1)
plot(in,out_net);
title('Neural');
figure(2)
plot(in,out);
title('True Function');

a=0;
b=1;

%r = a + (b-a).*rand(50,1);

r=0:0.01:1;
in=sort(r);
out_net=[];
for i=1:numel(in)
out_net=[out_net eval_izknet(net,in(i))];
end

if (isnan(out_net(1)))
out_net(1)=0;
end

for i=2:numel(out_net)
   if isnan(out_net(i))
      out_net(i)=out_net(i-1); 
   end
end



figure(3)
plot(in,out_net);
title('Generalization Test');


figure(4)

in=denormalize_data(in,pure_data);
out=normalize_data(tansig(in),pure_data);
in=sort(r);
plot(in,out)
title('Generalization Correct');
%net.layer_weights{1}