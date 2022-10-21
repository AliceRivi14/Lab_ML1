% Initialising the split fraction according to the neural networks standard
Split = 0.7;

% Loading the dataset
load('Data.mat');

% Initilising both training set and data set
Random = randperm(14);
Training = numericdataset(Random(1:int64(end*Split)),:);
Test = numericdataset(Random(int64(end*Split)+1:end),:);

% Function
[Target,ClassificationNoLp,ClassificationLp,Error] = NaiveBayesClassifier(Training,Test);

% Results
if Target ~= -1
    disp("Target without Laplace:");
    disp(Target(1,:));

    disp("Target with Laplace:");
    disp(Target(2,:));
end
disp("Classification without Laplace:");
disp(ClassificationNoLp);

disp("Classification Laplace:");
disp(ClassificationLp);

if Error ~= -1
    disp("Error Rate without Laplace: "+num2str(Error(1,1)));
    disp("Error Rate with Laplace: "+num2str(Error(2,1)));
end
