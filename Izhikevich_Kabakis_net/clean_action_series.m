function action_series=clean_action_series(action_series,numin,numout)

if iscell(action_series)
   action_series=cell2mat(action_series); 
end

[~,x]=find(action_series(numin+1:numin+numout,:)==1);
if ~(isempty(x))
y=x(1);

if y<size(action_series,2)
action_series(1:numin+numout,y+1:size(action_series,2))=zeros(numin+numout,size(action_series,2)-y);
end


end



end