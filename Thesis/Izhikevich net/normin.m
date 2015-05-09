function [input output]=normin(in,out)

all_data=[reshape(in,1,numel(in)) reshape(out,1,numel(out))];

input=normalize_data(in,all_data);
output=normalize_data(out,all_data);

end