addpath('./mnist');

% Load data
[XTrain, TTrain] = loadMNIST(0,0:9);
[XTest, TTest] = loadMNIST(1,0:9);

%% Testing the classifier for differnt Ks

Karray = [1:5,9,16,25]; 
Accuracy = zeros(10,length(Karray));

for cl = 1:10
    TTrain_cl = double(TTrain == cl);
    TTest_cl = double(TTest == cl);
    
    % 5% of the data set
    rows = randperm(60000,floor(0.05*60000));
    XTrain_sub = XTrain(rows,:);
    TTrain_sub = TTrain(rows,:);
   
    % 15% of the data set
    rows = randperm(10000,floor(0.15*10000));
    XTest_sub = XTest(rows,:);
    TTest_sub = TTest(rows,:);
    
    
    i=1;
    for j = 1:length(Karray)
        [Target, Error] = kNN(XTrain_sub,TTrain_sub,XTest_sub,Karray(j),TTest_sub);
        Accuracy(cl,i) = 1-Error;
        i = i+1;
    end
end

figure;
hold on;
plot(Karray,Accuracy(10,:),'DisplayName','Class 0', 'LineWidth', 2);

for i = 1:9
    plot(Karray,Accuracy(i,:),'LineWidth', 2);
end

title('Accuracy');
xlabel('K');
ylabel('Accuracy in percentage');
legend('Class 0','Class 1','Class 2','Class 3','Class 4','Class 5','Class 6','Class 7','Class 8','Class 9')
grid;

lgd = legend;

figure;
bar(1-Accuracy);
title('Error computed for each class, on x axis, for each number of neighbours required (each set)');
xlabel('Classes');
ylabel('Error');
legend('Class 1','Class 2','Class 3','Class 4','Class 5','Class 6','Class 7','Class 8','Class 9','Class 10');
