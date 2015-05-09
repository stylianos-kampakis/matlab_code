function []=plot_raster(raster_matrix,neurons)

figure
raster_matrix=cell2mat(raster_matrix);
plot(raster_matrix(:,2),raster_matrix(:,1),'.','MarkerSize',20)
xlabel('Time (in ms)');
ylabel('Neuron');
if(nargin<2)
set(gca,'YTick',min(raster_matrix(:,1)):1:max(raster_matrix(:,2)))
else
   set(gca,'YTick',min(raster_matrix(:,1)):1:neurons) 
    
end
end