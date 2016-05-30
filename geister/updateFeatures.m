%--------------------------------------------------------------------------
% updateFeatures.m
% Upates the features for each of our own ghosts. Returns an updated
% gameState data structure.
%--------------------------------------------------------------------------

function gameState = updateFeatures(gameState)

% Loop through all good ghosts
for i = 1:length(gameState.ghosts.good)
    thisGhost = gameState.ghosts.good(i);
    numOpponentGhosts = length(gameState.ghosts.opponent);
    
    %--------------------------
    % Distance to other ghosts
    %--------------------------
    
    % Get distance to and nature of each opponent ghost
    opponentDistances = zeros(numOpponentGhosts,1);
    opponentGoodConf = zeros(numOpponentGhosts,1);
    opponentEvilConf = zeros(numOpponentGhosts,1);
    opponentRow = zeros(numOpponentGhosts,1);
    opponentCol = zeros(numOpponentGhosts,1);
    for j = 1:numOpponentGhosts
        opponentGhost = gameState.ghosts.opponent(j);
        opponentDistances(j) = distBetweenGhosts(thisGhost, opponentGhost);
        opponentGoodConf(j) = opponentGhost.goodConf;
        opponentEvilConf(j) = opponentGhost.evilConf;
        opponentRow(j) = opponentGhost.row;
        opponentCol(j) = opponentGhost.col;
    end
    
    % Get index of the closest ghost
    [~, ind] = min(opponentDistances);
    
    % Pick a gost randomly if there is more than one closest
    if length(ind) > 1
        ind = ind(randi(length(ind)));
    end
    
    % Set features for the closest opponent ghost
    thisGhost.features.ClosestGhostDist = opponentDistances(ind);
    thisGhost.features.ClosestGhostGoodConf = opponentGoodConf(ind);
    thisGhost.features.ClosestGhostEvilConf = opponentEvilConf(ind);
    thisGhost.features.ClosestGhostRow = opponentRow(ind);
    thisGhost.features.ClosestGhostCol = opponentCol(ind);
    
    %---------------------------
    % Distance to opponent exit
    %---------------------------
    
    thisGhost.features.DistToOpponentExit = distToOpponentExit(thisGhost);
    thisGhost.features.ExitCongestion = exitCongestion(thisGhost, gameState.board);
    
    %-----------------------
    % Distance to home exit
    %-----------------------
    oppDistancesToHomeExit = zeros(numOpponentGhosts,2);
    for j = 1:numOpponentGhosts
        [dist, lr] = distToHomeExit(gameState.ghosts.opponent(j));
        oppDistancesToHomeExit(j,:) = [dist, lr];
    end
    
    % Get index of ghost closest to a home exit
    [~, ind] = min(oppDistancesToHomeExit(:,1));
    
    % Pick a gost randomly if there is more than one closest
    if length(ind) > 1
        ind = ind(randi(length(ind)));
    end
    
    thisGhost.features.OpponentDistToHomeExit = oppDistancesToHomeExit(ind,1);
    thisGhost.features.OpponentClosestToExitLR = oppDistancesToHomeExit(ind,2);
    thisGhost.features.DistToHomeExit = distToBlockExit(thisGhost, oppDistancesToHomeExit(ind,2));
    
    % Save updated features
    gameState.ghosts.good(i) = thisGhost;
    
end


% Loop through all evil ghosts
for i = 1:length(gameState.ghosts.evil)
    thisGhost = gameState.ghosts.evil(i);
    numOpponentGhosts = length(gameState.ghosts.opponent);
    
    %--------------------------
    % Distance to other ghosts
    %--------------------------
    
    % Get distance to and nature of each opponent ghost
    opponentDistances = zeros(numOpponentGhosts,1);
    opponentGoodConf = zeros(numOpponentGhosts,1);
    opponentEvilConf = zeros(numOpponentGhosts,1);
    opponentRow = zeros(numOpponentGhosts,1);
    opponentCol = zeros(numOpponentGhosts,1);
    for j = 1:numOpponentGhosts
        opponentGhost = gameState.ghosts.opponent(j);
        opponentDistances(j) = distBetweenGhosts(thisGhost, opponentGhost);
        opponentGoodConf(j) = opponentGhost.goodConf;
        opponentEvilConf(j) = opponentGhost.evilConf;
        opponentRow(j) = opponentGhost.row;
        opponentCol(j) = opponentGhost.col;
    end
    
    % Get index of the closest ghost
    [~, ind] = min(opponentDistances);
    
    % Pick a gost randomly if there is more than one closest
    if length(ind) > 1
        ind = ind(randi(length(ind)));
    end
    
    % Set features for the closest opponent ghost
    thisGhost.features.ClosestGhostDist = opponentDistances(ind);
    thisGhost.features.ClosestGhostGoodConf = opponentGoodConf(ind);
    thisGhost.features.ClosestGhostEvilConf = opponentEvilConf(ind);
    thisGhost.features.ClosestGhostRow = opponentRow(ind);
    thisGhost.features.ClosestGhostCol = opponentCol(ind);
    
    %---------------------------
    % Distance to opponent exit
    %---------------------------
    
    thisGhost.features.DistToOpponentExit = distToOpponentExit(thisGhost);
    thisGhost.features.ExitCongestion = exitCongestion(thisGhost, gameState.board);
    
    %-----------------------
    % Distance to home exit
    %-----------------------
    oppDistancesToHomeExit = zeros(numOpponentGhosts,2);
    for j = 1:numOpponentGhosts
        [dist, lr] = distToHomeExit(gameState.ghosts.opponent(j));
        oppDistancesToHomeExit(j,:) = [dist, lr];
    end
    
    % Get index of ghost closest to a home exit
    [~, ind] = min(oppDistancesToHomeExit(:,1));
    
    % Pick a gost randomly if there is more than one closest
    if length(ind) > 1
        ind = ind(randi(length(ind)));
    end
    
    thisGhost.features.OpponentDistToHomeExit = oppDistancesToHomeExit(ind,1);
    thisGhost.features.OpponentClosestToExitLR = oppDistancesToHomeExit(ind,2);
    thisGhost.features.DistToHomeExit = distToBlockExit(thisGhost, oppDistancesToHomeExit(ind,2));
    
    % Save updated features
    try
        gameState.ghosts.evil(i) = thisGhost;
    catch
        disp(i);
        disp(thisGhost.row);
        disp(thisGhost.col);
        continue;
    end
    
end



%--------------------------------------------------------------------------
% Returns the Manhattan distance between two ghosts.
%--------------------------------------------------------------------------
function dist = distBetweenGhosts(ghost1, ghost2)

dist = abs(ghost1.row - ghost2.row) + abs(ghost1.col - ghost2.col);



%--------------------------------------------------------------------------
% Returns the number of moves required to win the game by exiting from the
% nearest opponent exit.
%--------------------------------------------------------------------------
function dist = distToOpponentExit(ghost)

if ghost.col < 3
    % Closest to left exit
    dist = (6 - ghost.row) + ghost.col;
else
    % Closest to right exit
    dist = (6 - ghost.row) + (5 - ghost.col);
end



%--------------------------------------------------------------------------
% Returns the number of opponent ghosts in the space between the ghost and
% the nearest opponent exit.
%--------------------------------------------------------------------------
function congestion = exitCongestion(ghost, board)

if ghost.col < 3
    % Closest to left exit
    congestion = nnz(board(1:(6-ghost.row), 1:(ghost.col + 1)) == 3);
else
    % Closest to right exit
    congestion = nnz(board(1:(6-ghost.row), (ghost.col + 1):6) == 3);
end



%--------------------------------------------------------------------------
% Returns the number of moves required for the opponent to win the game by
% exiting from the nearest home exit.
%    dist = Number of moves
%    lr = 0 for left exit; 1 for right exit
%--------------------------------------------------------------------------
function [dist, lr] = distToHomeExit(ghost)

if ghost.col < 3
    % Closest to left exit
    dist = (ghost.row + 1) + ghost.col;
    lr = 0;
else
    % Closest to right exit
    dist = (ghost.row + 1) + (5 - ghost.col);
    lr = 1;
end



%--------------------------------------------------------------------------
% Returns the number of moves required to block the home exit.
%     lr = 0 for left exit; 1 for right exit;
%--------------------------------------------------------------------------
function dist = distToBlockExit(ghost, lr)

if lr == 0
    % Left exit
    dist = ghost.row + ghost.col;
else
    % Right exit
    dist = ghost.row + (5 - ghost.col);
end