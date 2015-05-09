function res=min_rebound(INPUT,lower_th,upper_th)


a=INPUT(1);
b=INPUT(2);
c=INPUT(3);
d=INPUT(4);
total_timings=[];
res=0;

%%
%This part of the code is basically a copy of the Izhikevich's simulation.
%It simulates the model for 300ms 


for trial=1:4
I=0;
v=-65; 
u=b.*v; 
timings=[];
v_matrix=[];
for t=1:150 

  
   
  if v>=30;
  timings=[timings; t];
  v=c;
  u=u+d; 
  end
  v=v+INPUT(5)*(0.04*v.^2+5*v+140-u+I); 
  u=u+a.*(b.*v-u);              

  
  
  v_matrix=[v_matrix v];
  I=0;
  
  %Send the input at t=100
  if t==100
    if trial==1      
        I=upper_th;      
    end
    
    if trial==2      
        I=lower_th;      
    end
    
    if trial==3
       I=upper_th-abs(upper_th)/2; 
    end
    
    if trial==4
       I=lower_th+abs(lower_th)/2; 
    end
    
    if trial==5
       I=upper_th-abs(upper_th)/4; 
    end
    
    if trial==6
       I=lower_th+abs(lower_th)/4; 
    end
    
    if trial==7
       I=upper_th-1; 
    end
    
    if trial==8
       I=lower_th+1; 
    end
    
  end   
  
end

if trial<=2
res=res+abs(size(timings,1)-1)*4;
elseif trial>2 && trial<=4
res=res+size(timings,1)*3; 
elseif trial>4 && trial<=6
res=res+size(timings,1)*2; 
else
res=res+size(timings,1); 
end



end





end





