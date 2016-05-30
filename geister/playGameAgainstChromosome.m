function victoryType = playGameAgainstChromosome(chromosome, cheat) 

% close all; clear all; clc;
% chromosome =  createPopulationTrapezoid();
% cheat = true;

moves1 = [];
moves2=[];
moves=[];
gameState = [];

turn = 0;
finished = false;
victoryType = 0;

fig1 = figure(1);
set(fig1, 'Position', [100, 200, 800, 800]); 


% Create a new game
fig1 = figure(1);

gameState2 = initializeBoard();
if cheat
    fig2 = figure(2);
    set(fig2, 'Position', [950, 200, 800, 800]);
    
    fig2 = drawGameStateCheat(gameState2, false, fig2);
end

gameState1 = initializeBoardPlayer(fig1);

oldRow = 0;
oldCol = 0;
newRow = 0;
newCol = 0;

strategy = 3; % 1 is good, 2 is evil, 3 combination
while ~finished

    if mod(turn, 2) == 0

        if cheat
            fig2 = drawGameState(gameState2, true, true, fig2);
            fig2 = showMove(fig2, true, oldRow, oldCol, newRow, newCol);
        end
        
        % Ask for move

        valid = false;
        while ~valid

            disp(['Captured Good: ' num2str(gameState1.features.CapturedGood)]);
            disp(['Captured Evil: ' num2str(gameState1.features.CapturedEvil)]);
            
            disp('Pick ghost to move');
            pos = getPosition(fig1);
            col = pos(1);
            row = pos(2);
            
            %Check validity
            if col >= 0 && col <= 5 && row >= 0 && row <= 5
                if gameState1.board(6-row, col+1) == 1 || gameState1.board(6-row, col+1) == 2;
                    valid = true;
                end
            end
            
            if ~valid
                disp('Illeagal ghost');
            end
            
        end
        
        oldCol = col;
        oldRow = row;
            
        valid = false;
        while ~valid

            disp('Pick a destination');
            pos = getPosition(fig1);
            col = pos(1);
            row = pos(2);
            
            %Check validity
            if col >= 0 && col <= 5 && row >= 0 && row <= 5
                if gameState1.board(6-row, col+1) == 0 || gameState1.board(6-row, col+1) == 3;
                    if (row == oldRow && abs(col-oldCol) == 1) || (col == oldCol && abs(row-oldRow) == 1)
                        valid = true;
                    end
                end
            end
            
            %Check exit condition
            if oldCol == 0 && oldRow == 5
                if gameState1.board(6-oldRow, oldCol+1) == 1
                    if col == -1 && row == 5
                        valid = true;
                    end
                end
            elseif oldCol == 5 && oldRow ==5
                if gameState1.board(6-oldRow, oldCol+1) == 1
                    if col == 6 && row == 5
                        valid = true;
                    end
                end                    
            end
            
            if ~valid
                disp('Illeagal move');
            end
            
        end
        
        newCol = col;
        newRow = row;
            
        gameState = gameState1;
        moves = moves1;

    else

        gameState = gameState2;
        moves = moves2;

        gameState = updateMoves(gameState,chromosome);     

        %Find the best move
        valEx =  anyExit(gameState);
        if ~isempty(valEx)
            bestMove = valEx;
        else
            [bestMoves, bestValue] = getListBestMoves(gameState,strategy,0,0);
            %         Calling Roulette wheel with a list of possible moves
            bestMove = rouletteWheel(bestMoves);

            % if same ghost has played 5 times, time to switch things...
            moves = [moves,bestMove(1,1)];
            dMoves = diff(moves);
            if length(dMoves) > 6
                if (max(abs(dMoves(end-5:end))) == 0) % trying to deal with same move issue
                    [bestMove2, bestValue2] = getBestMove(gameState,strategy,moves(end));

                    % Make sure that the new best move is valid
                    if ~isempty(bestMove2) && bestValue > 0
                        bestMove = bestMove2;
                        bestValue = bestValue2;
                    end
                end
            end

        end

        % Pick a move randomly if more than one has the best value
        if size(bestMove,1) > 1
            bestMove = bestMove(randi(size(bestMove,1)),:);
        end

        if bestMove(1) < 5
            oldRow = gameState.ghosts.good(bestMove(1)).row;
            oldCol = gameState.ghosts.good(bestMove(1)).col;
        else

            oldRow = gameState.ghosts.evil(bestMove(1)-4).row;
            oldCol = gameState.ghosts.evil(bestMove(1)-4).col;
        end

        % Move history=> to prevent infinite loop
        if mod(turn, 2) == 0
            moves1 = moves;
        else
            moves2 = moves;
        end

        % Format as a board move
        newRow = oldRow;
        newCol = oldCol;
        if bestMove(2) == 1
            newRow = newRow + 1;
        elseif bestMove(2) == 2
            newRow = newRow - 1;
        elseif bestMove(2) == 3
            newCol = newCol - 1;
        else
            newCol = newCol + 1;
        end

    end


    % Apply the move
    lost1 = 0;
    lost2 = 0;
    if mod(turn, 2) == 0
        gameState1 = gameState;
        try
            [gameState1, lost1] = applyMove(gameState1, oldRow, oldCol, newRow, newCol);
            [gameState2, lost2] = applyMove(gameState2, 5-oldRow, 5-oldCol, 5-newRow, 5-newCol);
        catch
        end
    else
        try
            gameState2 = gameState;
            [gameState2, lost2]= applyMove(gameState2, oldRow, oldCol, newRow, newCol);
            [gameState1, lost1]= applyMove(gameState1, 5-oldRow, 5-oldCol, 5-newRow, 5-newCol);
        catch
        end
    end

    % Update game state features
    if lost1 == 1
        % Player 1 lost a good ghost
        gameState1.features.LostGood = gameState1.features.LostGood + 1;
        gameState2.features.CapturedGood = gameState2.features.CapturedGood + 1;
        disp('Player 1 lost a good ghost.');
    elseif lost1 == 2
        % Player 1 lost an evil ghost
        gameState1.features.LostEvil = gameState1.features.LostEvil + 1;
        gameState2.features.CapturedEvil = gameState2.features.CapturedEvil + 1;
        disp('Player 1 lost an evil ghost.');
    elseif lost2 == 1
        % Player 2 lost a good ghost
        gameState2.features.LostGood = gameState2.features.LostGood + 1;
        gameState1.features.CapturedGood = gameState1.features.CapturedGood + 1;
        disp('Player 2 lost a good ghost.');
    elseif lost2 == 2
        % Player 2 lost an evil ghost
        gameState2.features.LostEvil = gameState2.features.LostEvil + 1;
        gameState1.features.CapturedEvil = gameState1.features.CapturedEvil + 1;
        disp('Player 2 lost an evil ghost.');
    end



    % Check for winning condition
    if gameState1.features.CapturedGood == 4 || gameState2.features.LostGood == 4
        finished = true;
        victoryType = 1;
        disp('Player 1 wins! All opponent good ghosts captured.');
    elseif gameState2.features.CapturedGood == 4 || gameState1.features.LostGood == 4
        finished = true;
        victoryType = 4;
        disp('Player 2 wins! All opponent good ghosts captured.');
    elseif gameState1.features.LostEvil == 4 || gameState2.features.CapturedEvil == 4
        finished = true;
        victoryType = 2;
        disp('Player 1 wins! All evil ghosts captured.');
    elseif gameState2.features.LostEvil == 4 || gameState1.features.CapturedEvil == 4
        finished = true;
        victoryType = 5;
        disp('Player 2 wins! All evil ghosts captured.');
    elseif gameState1.finished == 1
        finished = true;
        victoryType = 3;
        disp('Player 1 wins! A good ghost has left the board.');
    elseif gameState2.finished == 1
        finished = true;
        victoryType = 6;
        disp('Player 2 wins! A good ghost has left the board.');
    end

    % Draw the board

    fig1 = drawBoard(gameState1.board, fig1);

    % Increment the turn counter
    turn = turn + 1;
    if turn == 100
        finished = true;
        victoryType = 7;
            disp('Draw.');
    end     


end

