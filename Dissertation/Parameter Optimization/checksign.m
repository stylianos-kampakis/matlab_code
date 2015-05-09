function y=checksign(x)
%this function checks whether all elements in an array have the same sign
%it returns 1 if they are positive, -1 if they are negative and 0 otherwise
dummy=0;
for i=1:numel(x)
    if x(i)>0
       dummy=dummy+1; 
    end
    
    if x(i)<0
       dummy=dummy-1; 
    end
end

if dummy==numel(x)
   y=1;
elseif dummy==-1*numel(x)
   y=-1;
else
   y=0;
end


end