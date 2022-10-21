% Input
% Training = matrix [n,d+1]
% Test = matrix [m,c]

% Output
% Target:
% Classification = function g obtained
% Error = the error computed among the results

function[Target,ClassificationNoLp,ClassificationLp,Error] = NaiveBayesClassifier(Training, Test)

% Matrices dimensions
[Rtrain,Ctrain]=size(Training);
[Rtest,Ctest]=size(Test);

% Check the correct data set's dimensions
if(Ctest >= Ctrain - 1)
    
    % Check elements different form -1
    for i=1:Rtrain
        for k=1:Ctrain
            if(Training(i,k)==-1)
                disp('Error value in the training set');
            end
        end
    end
    for i=1:Rtest
        for k=1:Ctest
            if(Test(i,k)==-1)
                disp('Error value in the test set');
            end
        end
    end
    
    % Check values inside test set equals to the ones in the training set
    Reliminated = -ones(Rtest,1);
    for q=1:Rtest
        for w = 1:Ctest
            b = ismember(Test(q,w),unique(Training(:,w)));
            if(b == false)
                Reliminated(q,1) = q;
            elseif(Reliminated(q,1) == -1)
                Reliminated(q,1) = 0;
            end
        end
    end
    for e = 1:length(Reliminated)
        if(Reliminated(e) ~= 0)
            Test(Reliminated(e),:) = [];
            Rtest = Rtest - 1;
        end
    end
    
    %% Naive Bayes classifier
    
    % Number of classes and the classes
    Classes = unique(Training(:,Ctrain));
    NClasses = length(Classes);
    NVariables = Ctrain - 1;
    
    % Compute the probability of outlook, temperature, humidity and wind of
    % both classes
    % Save the probability using cells array; each cell has to have a
    % properly dimension according to the probabilities calculated
    
    % Cell array for the probabilities
    P = cell(NClasses,NVariables);
    PLaplace = cell(NClasses,NVariables);
    Pclass = zeros(1,NClasses);
    
    % Number of values assumed by a variable
    Var = zeros(1,NVariables);
    
    % Fill the probabilities cell array with the corrisponding v
    for i=1:NClasses
        NTot = sum(Training(:,Ctrain) == Classes(i));
        Pclass(1,i) = NTot/Rtrain;

        for j=1:NVariables
            Values = unique(Training(:,j));
            for k=1:length(Values)
                Count = 0;
                for l=1:Rtrain
                    if(Training(l,j) == Values(k) && Training(l,Ctrain) == Classes(i))
                        Count = Count + 1;
                    end
                end
                P{i,j}(k) = Count / NTot;
                % Probabilities computed with Laplace smoothing
                a = 1;
                PLaplace{i,j}(k) = (Count + a) / (NTot + a * Var(j));
            end
        end
    end
    
    %% Target

    Product = ones(Rtest,NClasses);
    ProductLP = ones(Rtest,NClasses);

    g = zeros(Rtest,NClasses);
    gLaplace = zeros(Rtest,NClasses);

    TargetNOLp = -ones(1,Rtest);
    TargetLp = -ones(1,Rtest);

    for Row=1:Rtest
        for Column=1:NClasses
            for Col=1:Ctest-1
                Pvar = P{Column,Col};
                PvarLP = PLaplace{Column,Col};
                Product(Row,Column) = Product(Row,Column)*Pvar(1,Test(Row,Col));
                ProductLP(Row,Column) = ProductLP(Row,Column)*PvarLP(1,Test(Row,Col));
            end

            g(Row,Column) = Pclass(1,Column)*Product(Row,Column);
            gLaplace(Row,Column) = Pclass(1,Column)*ProductLP(Row,Column);
            
            if Ctest == Ctrain
                if(Column == 1)
                    TargetNOLp(1,Row) = Column;
                elseif (g(Row,Column) > g(Row,Column-1)) % Minimum error
                    TargetNOLp(1,Row)=Column;
                end
            end
            if Ctest == Ctrain
                if(Column == 1)
                    TargetLp(1,Row) = Column;
                elseif (gLaplace(Row,Column) > gLaplace(Row,Column-1)) % Minimun error
                    TargetLp(1,Row)=Column;
                end
            end
        end
    end

    Target = [TargetNOLp;TargetLp];
    ClassificationNoLp = g;
    ClassificationLp = gLaplace;
    
    
    %% Error-rate
    
    if (Ctest ~= Ctrain)
        Error = -1;
        return;
    end
    
    Err = 0;
    ErrLp = 0;
    for h = 1:Rtest
        if(Test(h,Ctest) ~= TargetNOLp(1,h))
            Err = Err + 1;
        end
        if(Test(h,Ctest) ~= TargetLp(1,h))
            ErrLp = ErrLp + 1;
        end
    end

    Error = [Err/Rtest ; ErrLp/Rtest];
else
    disp('Test set matrix^s size is not correc');
end

end