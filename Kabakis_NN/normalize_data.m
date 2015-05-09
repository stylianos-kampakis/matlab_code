function x=normalize_data(x,data)

if nargin<2
   data=x; 
end

x=(x-min(data))./(max(data)-min(data));

end