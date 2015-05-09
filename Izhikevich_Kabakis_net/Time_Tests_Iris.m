
MLP_iris_time=0;
net_time=0;

for i=1:100
MLP_iris=newpr(irisp,irist,4);
MLP_iris=train(MLP_iris,irisp,irist);
tic
for i=1:size(irisp,2)
    
   sim(MLP_iris,irisp(:,i)); 
end
MLP_iris_time=MLP_iris_time+toc;
end

MLP_iris_time=MLP_iris_time/i;
for i=1:100
tic
for i=1:size(irisp,2)
    
   eval_izknet(net_iris,irisp(:,i));
end
net_time=net_time+toc;
end
net_time=net_time/i;


difference=MLP_iris_time-net_time