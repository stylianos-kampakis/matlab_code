%Approximate the sequence for resonator neurons

y=[];
y2=[];
for n=1:10000
    y(n)=myseq(n);
end

y2(1)=myseq(1);
for n=1:2000
    y2(n)=myseq(n*5);
end

%plot(1:10000,y);
k=1:5:10000;
p=polyfit(k,y2,2);
res=polyval(p,1:10000);

plot(1:10000,y)
hold on
plot(1:10000,res,'red')

res=sqrt(sum((res-y).^2)/10000)

