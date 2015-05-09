function x=unique_no_sort(x)

i=1;

while i<=numel(x)
    j=1;
   while j<=numel(x)
      if x(i)==x(j) && i~=j
          x(j)=[];
          j=j-1;
      end
      j=j+1;
   end
   i=i+1;
end

end