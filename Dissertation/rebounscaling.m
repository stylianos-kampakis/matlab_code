x=1:50;
res=[];

for i=1:numel(x)
   res=[res rebscale(x(i))]; 
end
close all
plot(res)