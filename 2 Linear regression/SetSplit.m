function [SubSet,SubSet2] = SetSplit(Data,Perc)
    [R,~] = size(Data);
    R_s = ceil(Perc * R);
    RandomSubRet = randperm(R);
    
    SubSet = Data(RandomSubRet(1:R_s),:);
    
    SubSet2 = Data(RandomSubRet(R_s+1:end),:);

end
