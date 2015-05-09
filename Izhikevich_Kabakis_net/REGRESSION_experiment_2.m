%Regression experiment
f=@(x)x.^2;
pure_data=[-10:0.5:10 f(-10:0.5:10)];

all_data=normalize_data(pure_data,[-10:0.5:10 f(-10:0.5:10)]);

in=normalize_data(-10:0.5:10,pure_data);
out=normalize_data(f(-10:0.5:10),pure_data);


options=izknet_optionset('Purpose','regression','Sensor_ranges',[0 1;min(out) max(out)]);
net=izknet([121 121],options)

in_t=truth_table(net,in,0);
out_t=truth_table(net,out,1);

%net=trn_izknet(truth_table(net,in,0),truth_table(net,out,1),net)
net=fit_train_izknet(in_t,out_t,net);


%Plot the data from the NN
figure(1)

out_net=[];
for i=1:numel(in)
    x=eval_izknet(net,in(i));
    x=x(1);
out_net=[out_net x];
end

plot(in,out_net);
title('Neural');

%Plot the true function
figure(2)
plot(in,out);
title('True Function');





%Plot the NN data from the generalization test
figure(3)

r=0:0.01:0.17;
in=sort(r);
out_net=[];
for i=1:numel(in)
x=eval_izknet(net,in(i));
    x=x(1);
out_net=[out_net x];
end

if (isnan(out_net(1)))
out_net(1)=0;
end

for i=2:numel(out_net)
   if isnan(out_net(i))
      out_net(i)=out_net(i-1); 
   end
end



plot(in,out_net);
title('Generalization Test');

%Plot the true generalization function
figure(4)

in=denormalize_data(in,pure_data);
out=normalize_data(f(in),pure_data);
in=sort(r);
plot(in,out)
title('Generalization Correct');
