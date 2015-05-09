function x=check_time(input)
input=cell2mat(input);
[x,z]=find(input==1);

if numel(x)==1 && z==size(input,2)
   x=1;
else
   x=0;
end

end