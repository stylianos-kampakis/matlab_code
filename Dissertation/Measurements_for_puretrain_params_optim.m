gg=cell2mat(buffer);
gg=sum(gg)/2;

data=zeros(numel(gg),1)/2;

for i=1:numel(gg)/2
    data(i)=gg(i+1)-gg(i);
end

hist(data,15);

%Select only those with success<0.97
gg=cell2mat(buffer);

index=size(gg,2);
i=1;

while i<index
    
   if gg(1,i)>0.95 && mod(2,i)~=0;
      gg(:,i:i+1)=[];
      i=i-1;
   end
 
   i=i+1;
   index=size(gg,2);
end

gg=sum(gg)/2;

data=zeros(numel(gg),1)/2;

for i=1:numel(gg)/2
    data(i)=gg(i+1)-gg(i);
end

hist(data,15);