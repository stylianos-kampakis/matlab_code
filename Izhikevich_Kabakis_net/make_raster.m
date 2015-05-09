function plot_matrix=make_raster(action_series)

matrix=cell2mat(action_series);
plot_matrix=[];

for i=1:size(matrix,1)
    for j=1:size(matrix,2)
   
        if matrix(i,j)==1
            plot_matrix=[plot_matrix;i j];
        end
        
    end
    
end

end