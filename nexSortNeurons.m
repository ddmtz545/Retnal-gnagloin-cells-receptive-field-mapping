function [neuronsSorted,neuronsNamesSorted,namesAllChar,namesAll]=nexSortNeurons(neurons)

%%%%nexSortNeurons just extracts neurons names for my data

neuronsNum=size(neurons,1);

%%%%%%this loop is to extract all of the names
namesAll=cell(neuronsNum,1);
for j=1:neuronsNum
    %%%%namesAll ia a cell contains names of neurons
    namesAll{j,1}=neurons{j}.name;
    
end
namesAllChar=char(namesAll);%%%%convert cell array to char


neuronsSorted=neurons;
neuronsNamesSorted=namesAll;


end