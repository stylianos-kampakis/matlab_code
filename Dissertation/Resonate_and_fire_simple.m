%The code that is commented out is basically some ideas I was trying to
%implement. You can ignore it.


total_time=500;
Input=50;
b=-1;
omega=10;
ys=[];
xs=[];


close all

x_1=0;
y_1=0;
for t=1:total_time
   x=x_1+b*x_1-omega*y_1;
   y=y_1+omega*x_1+b*y_1+Input;
   
   y_1=y;
   x_1=x;
   Input=0;
   ys=[ys y];
   xs=[xs x]; 
     
end

plot(ys)
% hold on
% p=polyfit(1:total_time,ys,20);
% res=polyval(p,1:total_time);
% plot(res,'red')
% 
% 
% gg=ys;
% gg=(gg-min(gg))./(max(gg)-min(gg));
% derivatives=diff(gg)./diff(1:numel(gg))

% close all
% plot(gg)
% hold on
% plot(derivatives,'red')
% 
% second_der=diff(derivatives)./diff(1:numel(derivatives));
% hold on
% plot(second_der,'green')