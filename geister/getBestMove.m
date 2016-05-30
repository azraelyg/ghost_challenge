function [bestMove, bestValue] = getBestMove(gameState,strategy,ghostNo)
% strategy: 1: good, 2: evil, 3: both

if nargin < 3
    ghostNo=0;
end

bestMove=[];   
bestValue = 0;

switch strategy
    case 1
        for i = 1:length(gameState.ghosts.good)
            if (gameState.ghosts.good(i).moves.up > bestValue) && (ghostNo~=i)
                bestMove = [i, 1];
                bestValue = gameState.ghosts.good(i).moves.up;
            elseif (gameState.ghosts.good(i).moves.up == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 1];
            end
            if (gameState.ghosts.good(i).moves.down > bestValue)&& (ghostNo~=i)
                bestMove = [i, 2];
                bestValue = gameState.ghosts.good(i).moves.down;
            elseif (gameState.ghosts.good(i).moves.down == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 2];
            end
            if (gameState.ghosts.good(i).moves.left > bestValue)&& (ghostNo~=i)
                bestMove = [i, 3];
                bestValue = gameState.ghosts.good(i).moves.left;
            elseif (gameState.ghosts.good(i).moves.left == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 3];
            end
            if (gameState.ghosts.good(i).moves.right > bestValue)&& (ghostNo~=i)
                bestMove = [i, 4];
                bestValue = gameState.ghosts.good(i).moves.right;
            elseif (gameState.ghosts.good(i).moves.right == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 4];
            end
        end
    case 2
        for i = 1:length(gameState.ghosts.evil)
            if (gameState.ghosts.evil(i).moves.up > bestValue)&& (ghostNo~=i)
                bestMove = [i+4, 1];
                bestValue = gameState.ghosts.evil(i).moves.up;
            elseif (gameState.ghosts.evil(i).moves.up == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 1];
            end
            if (gameState.ghosts.evil(i).moves.down > bestValue)&& (ghostNo~=i)
                bestMove = [i+4, 2];
                bestValue = gameState.ghosts.evil(i).moves.down;
            elseif (gameState.ghosts.evil(i).moves.down == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 2];
            end
            if (gameState.ghosts.evil(i).moves.left > bestValue)&& (ghostNo~=i)
                bestMove = [i+4, 3];
                bestValue = gameState.ghosts.evil(i).moves.left;
            elseif (gameState.ghosts.evil(i).moves.left == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 3];
            end
            if (gameState.ghosts.evil(i).moves.right > bestValue)&& (ghostNo~=i)
                bestMove = [i+4, 4];
                bestValue = gameState.ghosts.evil(i).moves.right;
            elseif (gameState.ghosts.evil(i).moves.right == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 4];
            end
        end
    case 3
        for i = 1:length(gameState.ghosts.good)
            if (gameState.ghosts.good(i).moves.up > bestValue)&& (ghostNo~=i)
                bestMove = [i, 1];
                bestValue = gameState.ghosts.good(i).moves.up;
            elseif (gameState.ghosts.good(i).moves.up == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 1];
            end
            if (gameState.ghosts.good(i).moves.down > bestValue)&& (ghostNo~=i)
                bestMove = [i, 2];
                bestValue = gameState.ghosts.good(i).moves.down;
            elseif (gameState.ghosts.good(i).moves.down == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 2];
            end
            if (gameState.ghosts.good(i).moves.left > bestValue)&& (ghostNo~=i)
                bestMove = [i, 3];
                bestValue = gameState.ghosts.good(i).moves.left;
            elseif (gameState.ghosts.good(i).moves.left == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 3];
            end
            if (gameState.ghosts.good(i).moves.right > bestValue)&& (ghostNo~=i)
                bestMove = [i, 4];
                bestValue = gameState.ghosts.good(i).moves.right;
            elseif (gameState.ghosts.good(i).moves.right == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 4];
            end
        end
        
        
        for i = 1:length(gameState.ghosts.evil)
            if (gameState.ghosts.evil(i).moves.up > bestValue)&& (ghostNo~=i)
                bestMove = [i+4, 1];
                bestValue = gameState.ghosts.evil(i).moves.up;
            elseif (gameState.ghosts.evil(i).moves.up == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 1];
            end
            if (gameState.ghosts.evil(i).moves.down > bestValue)&& (ghostNo~=i)
                bestMove = [i+4, 2];
                bestValue = gameState.ghosts.evil(i).moves.down;
            elseif (gameState.ghosts.evil(i).moves.down == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 2];
            end
            if (gameState.ghosts.evil(i).moves.left > bestValue)&& (ghostNo~=i)
                bestMove = [i+4, 3];
                bestValue = gameState.ghosts.evil(i).moves.left;
            elseif (gameState.ghosts.evil(i).moves.left == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 3];
            end
            if (gameState.ghosts.evil(i).moves.right > bestValue)&& (ghostNo~=i)
                bestMove = [i+4, 4];
                bestValue = gameState.ghosts.evil(i).moves.right;
            elseif (gameState.ghosts.evil(i).moves.right == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 4];
            end
        end
        
    otherwise
        disp('unknown strategy!!');
end

