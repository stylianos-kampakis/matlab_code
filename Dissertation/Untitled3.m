fclose(fid);

buffer=[];
fid = fopen('rebound_data_k.bin');



current=fgetl(fid);
while current~=-1
buffer=[buffer;str2num(current)];
current=fgetl(fid);
end

scatter(buffer(:,5),buffer(:,6),'.')