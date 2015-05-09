function y=rebscale(x)

if mod(x,2)==0
   y=2^(x-1);
else
   y=2^(x-2);
end

end