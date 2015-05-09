function score=rebound(weights,pos,neg,inputs)

score=0;


for i=1:size(inputs,1)
    
    res=weights*inputs(i,:)';
    res(res>pos)=1;
    res(res<neg)=1;
    res(res~=1)=0;
    
    res=sum(res);
    
    if mod(sum(inputs(i,:)),2)==0
       if res>=1
          score=score+res; 
       end
    elseif sum(inputs(i,:))==0
        if res>=1
          score=score+1; 
        end
    else
       if res==0
          score=score+sum(inputs(i,:));
       end       
    end  
    
    
end


end