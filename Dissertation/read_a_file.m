fid=fopen('resonate_k.bin');

buffer=[];

tline = fgetl(fid);
while ischar(tline)
    buffer=[buffer;str2num(tline)];
    tline = fgetl(fid);
end

fclose(fid);

g1=sum(buffer(:,1:2),2)/2;
g2=sum(buffer(:,3:4),2)/2;
% hist(g1,20);
% 
% h = findobj(gca,'Type','patch');
% set(h,'FaceColor','r','EdgeColor','w')
% 
% hold on
% hist(g2,20);

buffer2=buffer;
all=[g1 g2];
numel(find(all(:,1)>all(:,2)))
indices=find(all(:,1)>all(:,2));
buffer2(indices,3:4)=buffer(indices,1:2);

g11=sum(buffer2(:,1:2),2)/2;
g22=sum(buffer2(:,3:4),2)/2;