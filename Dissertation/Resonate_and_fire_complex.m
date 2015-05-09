total_time=1000;
Input=50;
b=-0.2;
omega=0.54;
zs=[];
z_1=0;

for t=1:total_time
z=z_1+(b+i*omega)*z_1+Input;
Input=0;



if t==50;
   Input=0; 
end

z_1=z;
zs=[zs z];
end



plot(real(zs))