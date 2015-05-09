%This file runs many times the genetic algorithm for parameter optimization
%for the rebound spiking neurons and saves the results

total_trials=1000;
fid = fopen('rebound_data_k.bin', 'a+');
for iterations=1:total_trials
    disp('rebound k')
    disp(iterations)
%%
low_th=-randi(400,1,1);
up_th=randi(400,1,1);

object_func=@(x) min_rebound_k(x,low_th,up_th);
%This part runs the genetic algorithm
options = gaoptimset('PopulationSize',100,'FitnessLimit',0,'StallGenLimit',7,'Generations',15,...
    'UseParallel','always','Vectorized','off');

lb=[-10;-10;-90;-10];
ub=[10;10;-40;10];
[x,fval] = ga(object_func,5,[],[],[],[],lb,ub,[],options);
x

%%
firings_buffer=zeros(10,1);


%Save the results
if fval==0  
    fprintf(fid,'%f %f %f %f %f %f %i %i\r\n',[x fval low_th up_th]);
end

end
fclose(fid);
