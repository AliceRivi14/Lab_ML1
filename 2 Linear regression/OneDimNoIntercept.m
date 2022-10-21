% Input
% Turkish: dataset with 2 colums (column 1 is the input, colums 2 is the output)

% Output
% x: values taken as input
% y: values calculated by y = w * x with w the angular coefficient of the regression


function [x,y] = OneDimNoIntercept(Turkish)
    w = (Turkish(:,1))\(Turkish(:,2));
    x = Turkish(:,1);
    y = w * x;
end
