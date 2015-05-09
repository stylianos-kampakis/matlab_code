%This file runs many times the genetic algorithm for parameter optimization
%for the resonator neurons and saves the results

fid = fopen('resonate_k.bin', 'a+');
%%
for kk=1:100
    disp('Resonator k')
    kk
%This part runs the genetic algorithm
options = gaoptimset('PopulationSize',100,'StallGenLimit',7,'Generations',15,...
    'UseParallel','always','Vectorized','off');


lb=[-10;-10;-85;-10];
ub=[10;10;-50;10];
[x,fval] = ga(@min_resonator_k,5,[],[],[],[],lb,ub,[],options);

%% 
%Save the results
fprintf(fid,'%f %f %f %f %f %f \r\n',[x fval]);
end
fclose(fid)