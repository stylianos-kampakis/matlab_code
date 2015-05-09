%Create the dataset
[irisp irist]=iris();

sepal_length=normalize_data(irisp(1,:));
sepal_width=normalize_data(irisp(2,:));
petal_length=normalize_data(irisp(3,:));
petal_width=normalize_data(irisp(4,:));

%We use only the features that have been found to be relevant
%irisp=[sepal_length;sepal_width;petal_length;petal_width];

irisp=[petal_length;petal_width];

%Sample the dataset
[irisp2 positions]=sample_rand(irisp,100);
irist2=irist(:,positions);

%Initialize the net
net=init_kn([40 3],[],[],10,2);
net.ms=150;
net.amplifier=20;

%Train the net
net_iris=trn_knet(irisp2,irist2,net)

%Evaluate results
result=[];

for i=1:size(irisp,2)
    
   result=[result eval_knet(net_iris,irisp(:,i))];
    
end

total_results=(result==irist);
error=1-sum(sum(total_results))/numel(total_results)
success=sum(sum(total_results))/numel(total_results)
