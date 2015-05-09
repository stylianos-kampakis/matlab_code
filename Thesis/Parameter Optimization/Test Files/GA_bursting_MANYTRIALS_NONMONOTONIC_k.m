%This file runs many times the genetic algorithm for parameter optimization
%for the bursting neurons and saves the results. Nonmonotonic case.
%NONMONOTONIC CASE

fid = fopen('nonmonotonic_k.bin', 'a+');

for trials=47:50
%%
disp('non monotonic k')
trials
for k=1:5
num_inputs=trials;
%This part runs the genetic algorithm
options = gaoptimset('PopulationSize',100,'FitnessLimit',0,'StallGenLimit',7,'Generations',15,...
    'UseParallel','always','Vectorized','off');
objective_func=@(x)min_burst_k(x,num_inputs,1);

lb=[-10;-10;-90;-10;10];
ub=[10;10;-40;10;500];
[x,fval] = ga(objective_func,6,[],[],[],[],lb,ub,[],options);

%% 
%Save the results
fprintf(fid,'%f %f %f %f %f %f %i %i\r\n',[x trials fval]);
end

end
fclose(fid)