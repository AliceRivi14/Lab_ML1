function [Target, Error] = kNN(XTrain,TTrain,XTest,k,TTest)

% Dimension
if nargin() == 5
    t = 1;
elseif nargin() == 4
    t = 0;
else
    disp("Incorrect number of inputs");
    return
end

[n,d] = size(XTrain);
[m,d1] = size(XTest);
[n1,c] = size(TTrain);

if t
    [m1,c1] = size(TTest);
end

if t
    if n == n1 && m == m1 && d == d1 && c == c1 && c == 1
    else
        disp("Incorrect column number");
        return
    end
else
    if n == n1 && d == d1 && c == 1
    else
        disp("Incorrect row number");
        return
    end
end

if k <= 0
    disp("Invalid k");
elseif k > n
    disp("k too big");
end

% Train
Target = zeros(m,1);

for i = 1:m
    Labels = zeros(k,1);
    Distances = zeros(n,1);

    for j = 1:n
        Distances(j) = norm(XTrain(j,:)- XTest(i,:));
    end

    [~, Indexes] = mink(Distances,k);

    for h = 1:k
        Labels(h) = TTrain(Indexes(h));
    end

    Target(i) = mode(Labels);
end

Error = 0;

if t
   for l = 1:m
       if Target(l) ~= TTest(l)
           Error = Error + 1/m;
       end
   end
end
