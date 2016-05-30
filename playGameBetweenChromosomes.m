function victoryType = playGameBetweenChromosomes(chromosome1,chromosome2)


victoryType = 0;
try
    
    verbose = false;
    draw = false;
    noPause = true;
    

    % Create a new game
    gameState1 = initializeBoard();
    gameState2 = initializeBoard();

    moves1 = [];
    moves2=[];
    moves=[];
    gameState = [];

    % Set ground truth opponent ghost natures
    for i = 1:8
        row = floor((i-1)/4) + 4;
        col = mod(i-1,4) + 1;

        gameState1.features.opponent(i).nature = gameState2.board(row + 1, 6 - col) - 1;
        gameState2.features.opponent(i).nature = gameState1.board(row + 1, 6 - col) - 1;
    end

    turn = 0;
    finished = false;
    victoryType = 0;

    if draw
        fig1 = figure(1);
        set(fig1, 'Position', [100, 100, 800, 800]);
        fig2 = figure(2);
        set(fig2, 'Position', [950, 100, 800, 800]);

    end

    strategy = 3; % 1 is good, 2 is evil, 3 combination
    while ~finished

        if mod(turn, 2) == 0
            gameState = gameState1;
            moves = moves1;
            chromosome = chromosome1;
        else
            gameState = gameState2;
            moves = moves2;
            chromosome = chromosome2;

        end

        gameState = updateMoves(gameState,chromosome);

        if verbose
            disp('--------------------------------------------------------------');
        end

        if mod(turn, 2) == 0
            if verbose
                disp('Player 1 Board Evaluation:');
            end
            if draw
                fig1 = drawGameState(gameState, true, false, fig1);
                fig2 = drawGameState(gameState2, false, true, fig2);
            end
        else
            if verbose
                disp('Player 2 Board Evaluation:');
            end
            if draw
                fig1 = drawGameState(gameState1, false, false, fig1);
                fig2 = drawGameState(gameState, true, true, fig2);
            end
        end

        if verbose
            clc;
            displayBoardEvaluation(gameState);
            disp(' ');
        end
        

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

        if verbose
            disp(bestMove)
        end

        % Pick a move randomly if more than one has the best value
        if size(bestMove,1) > 1
            bestMove = bestMove(randi(size(bestMove,1)),:);
        end

        if bestMove(1) < 5
            oldRow = gameState.ghosts.good(bestMove(1)).row;
            oldCol = gameState.ghosts.good(bestMove(1)).col;
        else
            if verbose
                disp('evil move..')
            end

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

        if verbose
            disp(['Chosen Move: (' num2str(oldCol) ',' num2str(oldRow) ') -> (' num2str(newCol) ',' num2str(newRow) ')']);
        end
        
        if draw
            if mod(turn, 2) == 0
                fig1 = showMove(fig1, false, oldRow, oldCol, newRow, newCol);
            else
                fig2 = showMove(fig2, true, oldRow, oldCol, newRow, newCol);
            end
        end
        
        if ~noPause
            pause;
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
        elseif lost1 == 2
            % Player 1 lost an evil ghost
            gameState1.features.LostEvil = gameState1.features.LostEvil + 1;
            gameState2.features.CapturedEvil = gameState2.features.CapturedEvil + 1;
        elseif lost2 == 1
            % Player 2 lost a good ghost
            gameState2.features.LostGood = gameState2.features.LostGood + 1;
            gameState1.features.CapturedGood = gameState1.features.CapturedGood + 1;
        elseif lost2 == 2
            % Player 2 lost an evil ghost
            gameState2.features.LostEvil = gameState2.features.LostEvil + 1;
            gameState1.features.CapturedEvil = gameState1.features.CapturedEvil + 1;
        end

        % Display opponent features
        if verbose
            disp('Features for the ghosts of Player 2:')
            displayOpponentFeatures(gameState1);
            disp(' ');
            disp('Features for the ghosts of Player 1:')
            displayOpponentFeatures(gameState2);
            disp(' ');
        end

        % Check for winning condition
        if gameState1.features.CapturedGood == 4 || gameState2.features.LostGood == 4
            finished = true;
            victoryType = 1;
            if verbose
                disp('Player 1 wins! All opponent good ghosts captured.');
            end
        elseif gameState2.features.CapturedGood == 4 || gameState1.features.LostGood == 4
            finished = true;
            victoryType = 4;
            if verbose
                disp('Player 2 wins! All opponent good ghosts captured.');
            end
        elseif gameState1.features.LostEvil == 4 || gameState2.features.CapturedEvil == 4
            finished = true;
            victoryType = 2;
            if verbose
                disp('Player 1 wins! All evil ghosts captured.');
            end
        elseif gameState2.features.LostEvil == 4 || gameState1.features.CapturedEvil == 4
            finished = true;
            victoryType = 5;
            if verbose
                disp('Player 2 wins! All evil ghosts captured.');
            end
        elseif gameState1.finished == 1
            finished = true;
            victoryType = 3;
            if verbose
                disp('Player 1 wins! A good ghost has left the board.');
            end
        elseif gameState2.finished == 1
            finished = true;
            victoryType = 6;
            if verbose
                disp('Player 2 wins! A good ghost has left the board.');
            end
        end

        % Increment the turn counter
        turn = turn + 1;
        if turn == 100
            finished = true;
            victoryType = 7;
            if verbose
                disp('Draw.');
            end
        end     
        
        if verbose
            disp('Ghost choice of player in previous moves:');
            disp(moves);
        end
    end
    
catch
    
    disp('An error occurred');
    fid = fopen('errors.txt', 'a');
    fprintf(fid, '%s\n', datestr(now));
    fclose(fid);
    display(chromosome1.good);
    display(chromosome1.evil);
    display(chromosome1.both);
    display(chromosome2.good);
    display(chromosome2.evil);
    display(chromosome2.both);
    
end

