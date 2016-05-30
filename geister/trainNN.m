% function NN = trainNN(X, D)

%Define parameters
HLSize = 10;
actFunc = @(x)1./(1+exp(-x));
dactFunc = @(x)actFunc(x).*(1-actFunc(x));
lr = .7;
momentum = .3;
maxEpochs = 1000;
dEThresh = 0;
maxVal = 20;

%Load data
featureData = load('featureData.mat');
featureData = featureData.featureData;
X = featureData(:,2:18);
D = featureData(:,1);
X = X';
D = 1-D';
D(2,:) = 1-D(1,:);


inputSize = size(X,1);
outputSize = size(D,1);
numSamples = size(X,2);

%Randomize the samples
perm = randperm(numSamples);
X = X(:,perm);
D = D(:,perm);

%Initialize weights
w1 = (rand(HLSize,inputSize)*4.8 - 2.4)/inputSize;
b1 = (rand(HLSize,1)*4.8 - 2.4)/inputSize;
w2 = (rand(outputSize,HLSize)*4.8 - 2.4)/inputSize;
b2 = (rand(outputSize,1)*4.8 - 2.4)/inputSize;

%Initialize variables
dw1 = zeros(size(w1));
db1 = zeros(size(b1));
dw2 = zeros(size(w2));
db2 = zeros(size(b2));
lastE = inf;

%Create sets
% ind = 1:numSamples;
% testSet = ind([1:100, Dind:Dind+99]);
% valSet = ind([101:200, Dind+100:Dind+199]);
% estSet = ind([201:Dind-1, Dind+200:end]);

ind = round(numSamples*0.15);
testSet = 1:ind;
valSet = ind+1:ind*2;
estSet = ind*2+1:numSamples;

estEhist = [];
valEhist = [];
testEhist = [];

%Loop until convergence
epoch = 1;
valCount = 0;
lastValE = inf;
stop = false;
while ~stop
    
    %Reset error energy for the epoch
    estE = 0;
    valE = 0;
    testE = 0;
    
    %Randomize the next presentation order of the samples
    estSet = estSet(randperm(length(estSet)));
    
    %Evaluate each sample
    estOutput = zeros(size(D,1),length(estSet));
    for k = 1:length(estSet)

        %Feed-forward
        x = X(:,estSet(k));
        d = D(:,estSet(k));
        v1 = w1*x + b1;
        y1 = arrayfun(actFunc,v1);
        v2 = w2*y1 + b2;
        y2 = arrayfun(actFunc,v2);

        %Calculate error
        e = d - y2;
        estE = estE + sum(e.^2)/2;

        %Backpropagation
        d2 = e.*dactFunc(v2);
        d1 = dactFunc(v1).*(d2'*w2)';

        %Update change in weights
        dw1 = momentum*dw1 + lr*d1*x';
        db1 = momentum*db1 + lr*d1;
        dw2 = momentum*dw2 + lr*d2*y1';
        db2 = momentum*db2 + lr*d2;
        
        %Update weights
        w1 = w1 + dw1;
        b1 = b1 + db1;
        w2 = w2 + dw2;
        b2 = b2 + db2;
        
        estOutput(:,k) = y2;
    end
    
    valOutput = zeros(size(D,1),length(valSet));
    for k = 1:length(valSet)

        x = X(:,valSet(k));
        d = D(:,valSet(k));

        v1 = w1*x + b1;
        y1 = arrayfun(actFunc,v1);

        v2 = w2*y1 + b2;
        y2 = arrayfun(actFunc,v2);

        e = d - y2;
        valE = valE + sum(e.^2)/2;
        
        valOutput(:,k) = y2;
    end
    
    testOutput = zeros(size(D,1),length(testSet));
    for k = 1:length(testSet)

        x = X(:,testSet(k));
        d = D(:,testSet(k));

        v1 = w1*x + b1;
        y1 = arrayfun(actFunc,v1);

        v2 = w2*y1 + b2;
        y2 = arrayfun(actFunc,v2);

        e = d - y2;
        testE = testE + sum(e.^2)/2;
        
        testOutput(:,k) = y2;
    end
    
    %Calculate average error energy for the epoch
    estE = estE/length(estSet);
    valE = valE/length(valSet);
    testE = testE/length(testSet);
    estEhist = [estEhist;estE];
    valEhist = [valEhist;valE];
    testEhist = [testEhist;testE];
    disp(['Epoch ' num2str(epoch) '  estE: ' num2str(estE) '  valE: ' num2str(valE) '  testE: ' num2str(testE)]);
    
%     %Plot average error energy
%     figure(1);
%     hold on;
%     plot(0:length(estEhist)-1,estEhist,'b');
%     plot(0:length(valEhist)-1,valEhist,'g');
%     plot(0:length(testEhist)-1,testEhist,'r');
%     hold off;
%     xlabel('Epoch');
%     ylabel('Average Error Energy');
%     drawnow;
%     
%     figure(2);
%     plotconfusion(D(:,estSet),estOutput,'Estimation Set',D(:,valSet),valOutput,'Validation Set', ...
%         D(:,testSet),testOutput,'Test Set',[D(:,estSet),D(:,valSet),D(:,testSet)],[estOutput,valOutput,testOutput],'Overall');    
    
    if valE <= lastValE
        lastValE = valE;
        valCount = 0;
    else
        valCount = valCount + 1;
    end
    
    %Check for stopping condition
    epoch = epoch + 1; 
    if  epoch > maxEpochs || abs(lastE - estE) < dEThresh || valCount > maxVal
        stop = true;
    end
    lastE = estE;
end

NN.w1 = w1;
NN.b1 = b1;
NN.w2 = w2;
NN.b2 = b2;