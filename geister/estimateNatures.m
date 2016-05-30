function gameState = estimateNatures(gameState)

load('NN.mat');
    
X = zeros(17,8);
for i = 1:8
    X(1:4,i) = gameState.features.opponent(i).startPosition(2,:);
    X(5:8,i) = gameState.features.opponent(i).startPosition(1,:);
    X(9,i) = gameState.features.opponent(i).firstMoved;
    X(10,i) = gameState.features.opponent(i).secondMoved;
    X(11,i) = gameState.features.opponent(i).backwardMoves;
    X(12,i) = gameState.features.opponent(i).forwardMoves;
    X(13,i) = gameState.features.opponent(i).lateralMoves;
    X(14,i) = gameState.features.opponent(i).captureWhenThreatened;
    X(15,i) = gameState.features.opponent(i).escapeWhenThreatened;
    X(16,i) = gameState.features.opponent(i).remainWhenThreatened;
    X(17,i) = gameState.features.opponent(i).threatWhenThreatened;
end

O = evalNN(X,NN);

for i = 1:length(gameState.ghosts.opponent)
    id = gameState.ghosts.opponent(i).id;
    gameState.ghosts.opponent(i).goodConf = O(1,id);
    gameState.ghosts.opponent(i).evilConf = O(2,id);
end