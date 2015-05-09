function [x positions]=sample_rand(data,n,a,b)

if nargin<4 || b==[]
   b=size(data,2);   
end

if nargin<3 || a==[]
   a=1;   
end

r = a + (b-a).*rand(n,1);
r=round(r);

x=data(:,r);
positions=r;

end