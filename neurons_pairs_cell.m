%%%In this file you can match neurons pairs in 04(Real horizontal) and 05(real vertical) protocols to find Receptive fields 
%%%each paris is an (1x2)array [x y], in which x is the neurons's index in
%%%04 and y is neuron index in 05


%%

%%number of sorted neurons%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% below lines find the number of neurons 
[m_Neurons_num n]=size(neurons);
Neurons_num = m_Neurons_num;
neurons_pairs=cell(Neurons_num,1);


for i=1:Neurons_num
    
    neurons_pairs{i}=[i,i];

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
