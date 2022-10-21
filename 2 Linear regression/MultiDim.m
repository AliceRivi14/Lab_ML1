function [y,t,w] = MultiDim(CarsData)
    t = CarsData(:,1);
    x = CarsData(:,2:end);
    w = (pinv(x'*x))*x'*t;
    y = x * w;
end