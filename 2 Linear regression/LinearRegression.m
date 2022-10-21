% Data
load('Turkish.csv');

CarsData = readmatrix('CarsData.csv');
% Remove the 1st column
CarsData(:,1) = [];

Perc = 0.1;

%% One dimension linear regression without the Intercept

% Mean value = 0
[x,y] = OneDimNoIntercept(Turkish);

subplot(2,2,1);
hold on;

plot(Turkish(:,1),Turkish(:,2),'.','LineWidth',2);
plot(x,y,'LineWidth',2);

xlabel('x values');
ylabel('y values');

legend('Entire data set','Linear regression');
title('One dimension without the Intercept')

%% Subset of dimension x% of the original one

[SubSet] = SubSetCreation(Turkish,Perc);

%% One dimension linear regression of a random subset with x% the dimension of the original one

[xS,yS] = OneDimNoIntercept(SubSet);

subplot(2,2,2);
hold on;

plot(Turkish(:,1),Turkish(:,2),'.','LineWidth',2);
plot(x,y,'LineWidth',2);
plot(SubSet(:,1),SubSet(:,2),'.','LineWidth',2);
plot(xS,yS,'LineWidth',2);

xlabel('x values');
ylabel('y values');

legend('Data set points','Linear regression','Sub set points','Linear regression of the subset')
title(['Comparison with sub set of dimension ' num2str(Perc*100) '% of the total'])

%% One dimensiom linear regression with Intercept

[xI,yI,yIc] = OneDimIntercept(CarsData);

subplot(2,2,3);
hold on;

plot(xI,yI,'.','LineWidth',2);
plot(xI,yIc,'LineWidth',2);

xlabel('mpg (Miles per gallon)');
ylabel('Weigth');

legend('Data set','Linear regression with intercept');
title('Linear regression with Intercept');

%% Multi dimensional problem

[yM,t] = MultiDim(CarsData);

subplot(2,2,4);
hold on;

plot(t,yM,'.','LineWidth',2);
plot(yM,yM,'-','LineWidth',2);

legend('Approssimation of the diagonal of the square','Diagonal of the square');
title('Multi variable regression model');

%% 5% of the total as train and 95% as test

Perc2 = 0.05;
Len = 10;
ErrTest1 = zeros(Len,1);
ErrTrain1 = zeros(Len,1);

for k = 1:Len
    [SubSet1_5,SubSet1_95] = SetSplit(Turkish,Perc2);
    [x,y] = OneDimNoIntercept(SubSet1_5);
    
    w = SubSet1_5(:,1)\SubSet1_5(:,2);
    Target1_95 = SubSet1_95(:,2);
    yC1_95 = w * SubSet1_95(:,1);
    ErrTest1(k) = immse(yC1_95,Target1_95);
    
    Target1_5 = SubSet1_5(:,2);
    y1_5 = w * SubSet1_5(:,1);
    ErrTrain1(k) = immse(y1_5,Target1_5);
end

Mse1 = [ErrTrain1 ErrTest1];

figure
subplot(3,2,1);
diag = bar(ErrTrain1);
diag(1).FaceColor = 'g';

ylabel('MSE');
legend('MSE train set')

subplot(3,2,2);
diag = bar(ErrTest1);
diag(1).FaceColor = 'r';

ylabel('MSE');
legend('MSE test set')

ErrTest3 = zeros(Len,1);
ErrTrain3 = zeros(Len,1);

for j = 1:Len
    [SubSet2_5,SubSet2_95] = SetSplit(CarsData,Perc2);
    [xn,yn,ynC] = OneDimIntercept(SubSet2_5);
    
    xSub_95 = SubSet2_95(:,4);
    ySub_95 = SubSet2_95(:,1);
    xSub_5 = SubSet2_5(:,4);
    ySub_5 = SubSet2_5(:,1);
    
    w1_95 = (sum((xSub_5-mean(xSub_5)).*(ySub_5-mean(ySub_5))))./(sum((xSub_5-mean(xSub_5)).^2));
    w0_95 = mean(ySub_5) - w1_95 * mean(xSub_5);
    yCalc2_95 = w0_95 + w1_95 .* xSub_95;
    
    ErrTest3(j) = immse(yCalc2_95,ySub_95);
    ErrTrain3(j) = immse(ynC,yn);
end

Mse3 = [ErrTrain3 ErrTest3];

subplot(3,2,3);
diag = bar(ErrTrain3);
diag(1).FaceColor = 'g';

ylabel('MSE');
legend('MSE train set')

subplot(3,2,4);
diag = bar(ErrTest3);
diag(1).FaceColor = 'r';

ylabel('MSE');
legend('MSE test set')


ErrTest4 = zeros(Len,1);
ErrTrain4 = zeros(Len,1);

for h = 1:Len
    [SubSet4_5,SubSet4_95] = SetSplit(CarsData,Perc2);
    
    [y4,t4,w4] = MultiDim(SubSet4_5);
    Target4_95 = SubSet4_95(:,1);
    x_95 =SubSet4_95(:,2:end);
    yCalc4_95 = x_95 * w4;
    
    ErrTest4(h) = immse(yCalc4_95,Target4_95);
    ErrTrain4(h) = immse(y4,t4);
end

Mse4 = ErrTrain4;

subplot(3,2,5);
diag = bar(ErrTrain4);
diag(1).FaceColor = 'g';

ylabel('MSE');
legend('MSE train set')

subplot(3,2,6);
diag = bar(ErrTest4);
diag(1).FaceColor = 'r';

ylabel('MSE');
legend('MSE test set')
