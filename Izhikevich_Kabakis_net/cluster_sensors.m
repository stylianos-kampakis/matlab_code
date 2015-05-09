function net=cluster_sensors(net,data,clusters)

try
[~,x]=kmeans(data,clusters);
catch
[~,x]=kmeans(data,clusters);
end

x=reshape(x,numel(x),1);

net.sensor_parameters(:,2)=x;


end