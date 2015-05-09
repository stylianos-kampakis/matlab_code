function y=myseq(n)
adder=2;
counter=0;
y=2;
for i=6:n
  y=y+adder;
  counter=counter+1;
  if counter==2
     counter=0;
     adder=adder+1;
  end
  
end

end