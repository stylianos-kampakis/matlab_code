function res=garebound(input,neurons,numin,inputs)

weights=neurons*numin;
pos=neurons;
neg=neurons;

w=reshape(input(1:weights),neurons,numin);
input(1:weights)=[];
pos=input(1:neurons)';
input(1:neurons)=[];
neg=input';



res=rebound(w,pos,neg,inputs);

end