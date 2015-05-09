function x=denormalize_data(x,original_data)

x=x.*(max(original_data)-min(original_data))+min(original_data);

end