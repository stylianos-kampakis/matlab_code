function series=derive_action(matrix)
column=[];
%Take the action matrix
if iscell(matrix)
  series=cell2mat(matrix);
else
    series=matrix;
end


 
 %Keep only the columns up to and including the first firing

for i=1:size(series,1)
   x=find(series(i,:)==1);
   if ~(isempty(x))
   column(i)=x(1);
   end
end

column=unique_no_sort(column);

if ~isempty(column)
for p=1:numel(column)
   if column(p)~=0
    series(:,column(p))=series(:,column(p))./column(p);          
   end
end

series=(series-min(min(series)))./(max(max(series))-min(min(series)));
series(:,max(column)+1:size(series,2))=[];

series=sum(series,2);
else
series=zeros(size(matrix,1),1);
end





 
 %Transpose the action_series_inputs in order to use later for
 %multiplication
  series=series';

end