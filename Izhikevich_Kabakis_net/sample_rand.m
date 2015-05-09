function [x positions]=sample_rand(data,n,a,b,noreplacement)

if nargin<4 || isempty(b)
   b=size(data,2);   
end

if nargin<3 || isempty(a)
   a=1;   
end

if noreplacement==1
choose=randperm(b);
choose=choose(1:n);
x=data(:,choose);
positions=choose;
    
else
r = a + (b-a).*rand(n,1);
r=round(r);

x=data(:,r);
positions=r;
end

end