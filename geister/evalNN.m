function O = evalNN(X, NN)

%Define parameters
actFunc = @(x)1./(1+exp(-x));

%Load weights
w1 = NN.w1;
b1 = NN.b1;
w2 = NN.w2;
b2 = NN.b2;

x = X;

v1 = w1*x + repmat(b1,1,size(x,2));
y1 = arrayfun(actFunc,v1);

v2 = w2*y1 + repmat(b2,1,size(y1,2));
y2 = arrayfun(actFunc,v2);

O = y2;