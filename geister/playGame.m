close all; clear all; clc;

system('del featureData.mat');
system('del victoryTypes.mat');

for gameNum = 1:50

    fprintf('Game %d: ', gameNum);
    
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
        else
            gameState = gameState2;
            moves = moves2;
        end

        gameState = updateMoves(gameState);

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

%         % Draw the board
%         if draw
%             fig1 = drawBoard(gameState1.board, fig1);
%             fig2 = drawBoard(gameState2.board, fig2);
%         end

        % Increment the turn counter
        turn = turn + 1;
        if turn == 100
            finished = true;
            victoryType = 7;
            disp('Draw.');
        end     
        
        if verbose
            disp('Ghost choice of player in previous moves:');
            disp(moves);
        end
    end

    featureData = [];
    if exist('featureData.mat', 'file')
        fd = load('featureData.mat');
        featureData = fd.featureData;
    end
    
    newFeatureData = zeros(16, 18);
    for i = 1:8
        newFeatureData(i,1) = gameState1.features.opponent(i).nature;
        newFeatureData(i,2:5) = gameState1.features.opponent(i).startPosition(2,:);
        newFeatureData(i,6:9) = gameState1.features.opponent(i).startPosition(1,:);
        newFeatureData(i,10) = gameState1.features.opponent(i).firstMoved;
        newFeatureData(i,11) = gameState1.features.opponent(i).secondMoved;
        newFeatureData(i,12) = gameState1.features.opponent(i).backwardMoves;
        newFeatureData(i,13) = gameState1.features.opponent(i).forwardMoves;
        newFeatureData(i,14) = gameState1.features.opponent(i).lateralMoves;
        newFeatureData(i,15) = gameState1.features.opponent(i).captureWhenThreatened;
        newFeatureData(i,16) = gameState1.features.opponent(i).escapeWhenThreatened;
        newFeatureData(i,17) = gameState1.features.opponent(i).remainWhenThreatened;
        newFeatureData(i,18) = gameState1.features.opponent(i).threatWhenThreatened;
    end
    for i = 1:8
        newFeatureData(i+8,1) = gameState2.features.opponent(i).nature;
        newFeatureData(i+8,2:5) = gameState2.features.opponent(i).startPosition(2,:);
        newFeatureData(i+8,6:9) = gameState2.features.opponent(i).startPosition(1,:);
        newFeatureData(i+8,10) = gameState2.features.opponent(i).firstMoved;
        newFeatureData(i+8,11) = gameState2.features.opponent(i).secondMoved;
        newFeatureData(i+8,12) = gameState2.features.opponent(i).backwardMoves;
        newFeatureData(i+8,13) = gameState2.features.opponent(i).forwardMoves;
        newFeatureData(i+8,14) = gameState2.features.opponent(i).lateralMoves;
        newFeatureData(i+8,15) = gameState2.features.opponent(i).captureWhenThreatened;
        newFeatureData(i+8,16) = gameState2.features.opponent(i).escapeWhenThreatened;
        newFeatureData(i+8,17) = gameState2.features.opponent(i).remainWhenThreatened;
        newFeatureData(i+8,18) = gameState2.features.opponent(i).threatWhenThreatened;
    end

    featureData = [featureData; newFeatureData];
    save('featureData.mat', 'featureData');
    
    % Save victory types
    victoryTypes = [];
    if exist('victoryTypes.mat', 'file')
        vt = load('victoryTypes.mat');
        victoryTypes = vt.victoryTypes;
    end
    victoryTypes = [victoryTypes; victoryType];
    save('victoryTypes.mat', 'victoryTypes');
    
end

% Analyze victory types
vt = load('victoryTypes.mat');
victoryTypes = vt.victoryTypes;

games = length(victoryTypes);
p1wins = nnz(victoryTypes <= 3);
p2wins = nnz(victoryTypes >= 4 & victoryTypes <= 6);
draws = nnz(victoryTypes == 7);

disp(['Player 1 won ' num2str(p1wins) ' out of ' num2str(games) ' games (' num2str(p1wins/games*100, 2) '%)']);
disp(['Player 2 won ' num2str(p2wins) ' out of ' num2str(games) ' games (' num2str(p2wins/games*100, 2) '%)']);
disp([num2str(draws) ' games were draws (' num2str(draws/games*100, 2) '%)']);
disp(' ');
disp('Victory Type Breakdown:');
disp([num2str(nnz(victoryTypes == 1)) '/' num2str(games) ' (' num2str(nnz(victoryTypes == 1)/games*100, 2) '%) Player 1 wins! All opponent good ghosts captured.']);
disp([num2str(nnz(victoryTypes == 2)) '/' num2str(games) ' (' num2str(nnz(victoryTypes == 2)/games*100, 2) '%) Player 1 wins! All evil ghosts captured.']);
disp([num2str(nnz(victoryTypes == 3)) '/' num2str(games) ' (' num2str(nnz(victoryTypes == 3)/games*100, 2) '%) Player 1 wins! A good ghost has left the board.']);
disp([num2str(nnz(victoryTypes == 4)) '/' num2str(games) ' (' num2str(nnz(victoryTypes == 4)/games*100, 2) '%) Player 2 wins! All opponent good ghosts captured.']);
disp([num2str(nnz(victoryTypes == 5)) '/' num2str(games) ' (' num2str(nnz(victoryTypes == 5)/games*100, 2) '%) Player 2 wins! All evil ghosts captured.']);
disp([num2str(nnz(victoryTypes == 6)) '/' num2str(games) ' (' num2str(nnz(victoryTypes == 6)/games*100, 2) '%) Player 2 wins! A good ghost has left the board.']);
disp([num2str(nnz(victoryTypes == 7)) '/' num2str(games) ' (' num2str(nnz(victoryTypes == 7)/games*100, 2) '%) Draw']);

figure(3);
hist(victoryTypes, 7);

