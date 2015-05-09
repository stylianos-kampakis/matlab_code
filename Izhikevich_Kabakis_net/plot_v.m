function []=plot_v(net,results,layer)

if nargin<3
   layer=1; 
end

plot(1:1:net.ms,cell2mat(results(layer,:)))
xlabel('Time in ms');
ylabel('Voltage in mV');
end