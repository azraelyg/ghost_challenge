%--------------------------------------------------------------------------
% initializeBoard.m
% Picks an initial position for our ghosts and initializes the ghost data
% structure with location and nature estimates.
%
% For compatibility with the Geister competition server, board coordinates
% begin at (0,0) in the lower-left (home) corner and increase to (5,5) in
% the upper-right (opponent) corner. First index is the row, second is the
% column.
%
%    *       ---------------------
%    *       ||    PLAYER 2     ||
%    *  -------------------------------
%    *  | 50 | 51 | 52 | 53 | 54 | 55 |
%    *  -------------------------------
%    *  | 40 | 41 | 42 | 43 | 44 | 45 |
%    *  -------------------------------
%    *  | 30 | 31 | 32 | 33 | 34 | 35 |
%    *  ------------------------------
%    *  | 20 | 21 | 22 | 23 | 24 | 25 |
%    *  -------------------------------
%    *  | 10 | 11 | 12 | 13 | 14 | 15 |
%    *  -------------------------------
%    *  | 00 | 01 | 02 | 03 | 04 | 05 |
%    *  -------------------------------
%    *       ||    PLAYER 1     ||
%    *       ---------------------
%
%--------------------------------------------------------------------------

function gameState = initializeBoard()

% Pick a random initial position for our own ghosts
initialPosition = reshape(randperm(8) > 4, 2, 4);

% Add good ghosts to the ghost list
[row, col] = find(initialPosition == 0);
for i = 1:4
    thisGhost = [];
    
    % Position
    thisGhost.row = row(i) - 1;
    thisGhost.col = col(i);
    
    % Goals
    thisGhost.goals = [];
    
    % Moves
    thisGhost.moves.up = 0;
    thisGhost.moves.down = 0;
    thisGhost.moves.left = 0;
    thisGhost.moves.right = 0;
    
    % Features
    thisGhost.features.ClosestGhostDist = nan;
    thisGhost.features.ClosestGhostGoodConf = nan;
    thisGhost.features.ClosestGhostEvilConf = nan;
    thisGhost.features.ClosestGhostRow = nan;
    thisGhost.features.ClosestGhostCol = nan;
    thisGhost.features.DistToOpponentExit = nan;
    thisGhost.features.ExitCongestion = nan;
    thisGhost.features.OpponentDistToHomeExit = nan;
    thisGhost.features.OpponentClosestToExitLR = nan;
    thisGhost.features.DistToHomeExit = nan;
    
    gameState.ghosts.good(i) = thisGhost;
end

% Add evil ghosts to the ghost list
[row, col] = find(initialPosition == 1);
for i = 1:4
    thisGhost = [];
    
    % Position
    thisGhost.row = row(i) - 1;
    thisGhost.col = col(i);
    
    % Goals
    thisGhost.goals = [];
    
    % Features
    thisGhost.features.ClosestGhostDist = nan;
    thisGhost.features.ClosestGhostGoodConf = nan;
    thisGhost.features.ClosestGhostEvilConf = nan;
    thisGhost.features.ClosestGhostRow = nan;
    thisGhost.features.ClosestGhostCol = nan;
    thisGhost.features.DistToOpponentExit = nan;
    thisGhost.features.ExitCongestion = nan;
    thisGhost.features.OpponentDistToHomeExit = nan;
    thisGhost.features.OpponentClosestToExitLR = nan;
    thisGhost.features.DistToHomeExit = nan;

    
    % Moves
    thisGhost.moves.up = 0;
    thisGhost.moves.down = 0;
    thisGhost.moves.left = 0;
    thisGhost.moves.right = 0;
    
    gameState.ghosts.evil(i) = thisGhost;
end

% Add opponent ghosts to the ghost list
for i = 1:8
    thisGhost = [];
    
    thisGhost.id = i;
    thisGhost.row = floor((i-1)/4) + 4;
    thisGhost.col = mod(i-1,4) + 1;
    thisGhost.goodConf = 0.5; % Initial confidence is 0.5 for now
    thisGhost.evilConf = 0.5; % Initial confidence is 0.5 for now
    
    gameState.ghosts.opponent(i) = thisGhost;
    
    gameState.features.opponent(i).startPosition = zeros(2,4);
    gameState.features.opponent(i).startPosition(6 - thisGhost.row, thisGhost.col) = 1;
    gameState.features.opponent(i).firstMoved = 0;
    gameState.features.opponent(i).secondMoved = 0;
    gameState.features.opponent(i).backwardMoves = 0;
    gameState.features.opponent(i).forwardMoves = 0;
    gameState.features.opponent(i).lateralMoves = 0;
    gameState.features.opponent(i).captureWhenThreatened = 0;
    gameState.features.opponent(i).escapeWhenThreatened = 0;
    gameState.features.opponent(i).remainWhenThreatened = 0;
    gameState.features.opponent(i).threatWhenThreatened = 0;
end

% Initialize other game state variables
gameState.features.CapturedGood = 0;
gameState.features.CapturedEvil = 0;
gameState.features.LostGood = 0;
gameState.features.LostEvil = 0;

% Create initial board image
[gameState.board, gameState.finished] = ghosts2board(gameState.ghosts);

% Update natures
gameState = estimateNatures(gameState);