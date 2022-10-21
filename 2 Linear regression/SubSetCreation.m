% Input
% Turkish: dataset with 2 colums (column 1 is the input, colums 2 is the output)
% Perc: percentage taken from the entire data set to form a new sub set. Number expressed in the interval [0,1]

% Output
% SubSet: dataset with 2 columns as the input but dimension of x% of the input

function [SubSet] = SubSetCreation(Turkish,Perc)
    [R,C] = size(Turkish);
    Rs = round(Perc * R);
    RandomSubset = randperm(R,Rs);
    SubSet = zeros(Rs,C);
    
    for i=1:length(RandomSubset)
        SubSet(i,:) = Turkish(RandomSubset(i),:);
    end
end
