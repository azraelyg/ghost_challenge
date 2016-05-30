%--------------------------------------------------------------------------
% applyMove.m
% Applies a move to a gameState data structure.
%--------------------------------------------------------------------------

function [gameState, lostType] = applyMove(gameState, oldRow, oldCol, newRow, newCol)

moveType = gameState.board(6 - oldRow, oldCol + 1);
lostType = 0;

if moveType == 1
    
    % Move good ghost 
    for i = 1:length(gameState.ghosts.good)
        if gameState.ghosts.good(i).row == oldRow && ...
           gameState.ghosts.good(i).col == oldCol
            
            gameState.ghosts.good(i).row = newRow;
            gameState.ghosts.good(i).col = newCol;
        end
    end
    
    % Check if an opponent was captured
    ind = 0;
    for i = 1:length(gameState.ghosts.opponent)
        if gameState.ghosts.opponent(i).row == newRow && ...
           gameState.ghosts.opponent(i).col == newCol
       
            ind = i;
        end
    end
    if ind > 0
        gameState.ghosts.opponent = [gameState.ghosts.opponent(1:ind-1), gameState.ghosts.opponent(ind+1:end)];
    end
        
elseif moveType == 2
    
    % Move evil ghost
    for i = 1:length(gameState.ghosts.evil)
        if gameState.ghosts.evil(i).row == oldRow && ...
           gameState.ghosts.evil(i).col == oldCol
            
            gameState.ghosts.evil(i).row = newRow;
            gameState.ghosts.evil(i).col = newCol;
        end
    end
    
    % Check if an opponent was captured
    ind = 0;
    for i = 1:length(gameState.ghosts.opponent)
        if gameState.ghosts.opponent(i).row == newRow && ...
           gameState.ghosts.opponent(i).col == newCol
       
            ind = i;
        end
    end
    if ind > 0
        gameState.ghosts.opponent = [gameState.ghosts.opponent(1:ind-1), gameState.ghosts.opponent(ind+1:end)];
    end
    
else
    
    % Loop over all opponent ghosts to see if they are being threatened
    opponentThreatened = zeros(1, length(gameState.ghosts.opponent));
    for i = 1:length(gameState.ghosts.opponent)

        row = gameState.ghosts.opponent(i).row;
        col = gameState.ghosts.opponent(i).col;

        % Check for threats from above
        if row < 5
            if gameState.board(5 - row, col + 1) == 1 || gameState.board(5 - row, col + 1) == 2
                opponentThreatened(i) = 1;
            end
        end

        % Check for threats from below
        if row > 0
            if gameState.board(7 - row, col + 1) == 1 || gameState.board(7 - row, col + 1) == 2
                opponentThreatened(i) = 1;
            end
        end

        % Check for threats from the left
        if col > 0
            if gameState.board(6 - row, col) == 1 || gameState.board(6 - row, col) == 2
                opponentThreatened(i) = 1;
            end
        end

        % Check for threats from the right
        if col < 5
            if gameState.board(6 - row, col + 2) == 1 || gameState.board(6 - row, col + 2) == 2
                opponentThreatened(i) = 1;
            end
        end

    end
    
    % Move opponent ghost
    threatenedIndex = 0;
    opponentID = 0;
    for i = 1:length(gameState.ghosts.opponent)
        if gameState.ghosts.opponent(i).row == oldRow && ...
           gameState.ghosts.opponent(i).col == oldCol
            
            gameState.ghosts.opponent(i).row = newRow;
            gameState.ghosts.opponent(i).col = newCol;
            threatenedIndex = i;
            opponentID = gameState.ghosts.opponent(i).id;
        end
    end
    
    % Check if this is the first opponent ghost to be moved
    firstMove = true;
    for i = 1:length(gameState.ghosts.opponent)
        if gameState.features.opponent(i).firstMoved ~= 0
            firstMove = false;            
        end
    end
    if firstMove
        gameState.features.opponent(opponentID).firstMoved = 1;
    end
    
    % Check if this is the second opponent ghost to be moved
    secondMove = true;
    if gameState.features.opponent(opponentID).firstMoved == 1;
        secondMove = false;
    else
        for i = 1:length(gameState.ghosts.opponent)
            if gameState.features.opponent(i).secondMoved ~= 0
                secondMove = false;            
            end
        end
    end
    if secondMove
        gameState.features.opponent(opponentID).secondMoved = 1;
    end
    
    % Update the direction moved features
    if newCol == oldCol
        if newRow > oldRow
            gameState.features.opponent(opponentID).backwardMoves = gameState.features.opponent(opponentID).backwardMoves + 1;
        else
            gameState.features.opponent(opponentID).forwardMoves = gameState.features.opponent(opponentID).forwardMoves + 1;
        end
    else
        gameState.features.opponent(opponentID).lateralMoves = gameState.features.opponent(opponentID).lateralMoves + 1;
    end
    
    % Check if a good ghost was captured
    ind = 0;
    for i = 1:length(gameState.ghosts.good)
        if gameState.ghosts.good(i).row == newRow && ...
           gameState.ghosts.good(i).col == newCol
       
            ind = i;
        end
    end
    if ind > 0
        gameState.ghosts.good = [gameState.ghosts.good(1:ind-1), gameState.ghosts.good(ind+1:end)];
        lostType = 1;
        gameState.features.opponent(opponentID).captureWhenThreatened = gameState.features.opponent(opponentID).captureWhenThreatened + 1;
    end
    
    % Check if an evil ghost was captured
    ind = 0;
    for i = 1:length(gameState.ghosts.evil)
        if gameState.ghosts.evil(i).row == newRow && ...
           gameState.ghosts.evil(i).col == newCol
       
            ind = i;
        end
    end
    if ind > 0
        gameState.ghosts.evil = [gameState.ghosts.evil(1:ind-1), gameState.ghosts.evil(ind+1:end)];
        lostType = 2;
        gameState.features.opponent(opponentID).captureWhenThreatened = gameState.features.opponent(opponentID).captureWhenThreatened + 1;
    end
    
    % Check if this opponent ghost escaped a threat or forced a new one
    if opponentThreatened(threatenedIndex)
        
        row = newRow;
        col = newCol;
        safe = true;

        if col >= 0 && col <= 5
            % Check if the ghost moved off the board
                  
            % Check for threats from above
            if row < 5
                if gameState.board(5 - row, col + 1) == 1 || gameState.board(5 - row, col + 1) == 2
                    safe = false;
                end
            end

            % Check for threats from below
            if row > 0
                if gameState.board(7 - row, col + 1) == 1 || gameState.board(7 - row, col + 1) == 2
                    safe = false;
                end
            end

            % Check for threats from the left
            if col > 0
                if gameState.board(6 - row, col) == 1 || gameState.board(6 - row, col) == 2
                    safe = false;
                end
            end

            % Check for threats from the right
            if col < 5
                if gameState.board(6 - row, col + 2) == 1 || gameState.board(6 - row, col + 2) == 2
                    safe = false;
                end
            end

            % Update features
            if lostType == 0
                if safe
                    gameState.features.opponent(opponentID).escapeWhenThreatened = gameState.features.opponent(opponentID).escapeWhenThreatened + 1;
                else
                    gameState.features.opponent(opponentID).threatWhenThreatened = gameState.features.opponent(opponentID).threatWhenThreatened + 1;
                end
            end
        end
        
    end
    
    % Update the remainWhenThreatened feature for opponent ghosts
    for i = 1:length(opponentThreatened)
        if opponentThreatened(i) == 1 && i ~= threatenedIndex
            gameState.features.opponent(i).remainWhenThreatened = gameState.features.opponent(i).remainWhenThreatened + 1;
        end
    end
    
    % Re-estimate the natures of the opponent ghosts
    gameState = estimateNatures(gameState);
    
    
end

% Update the board
[gameState.board, gameState.finished] = ghosts2board(gameState.ghosts);