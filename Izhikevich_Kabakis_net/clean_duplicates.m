function action_series=clean_duplicates(action_series)

for i=1:size(action_series,1)
   x=find(action_series(i,:)==1);
   
   if ~isempty(x)&&numel(x)>1
       x(1)=[];
       for j=1:numel(x)
          action_series(i,x(j))=0; 
       end
   end
   
end

end