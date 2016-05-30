function [bestMove, bestValue] = getListBestMoves(gameState,strategy,ghostNo,threshold)
% strategy: 1: good, 2: evil, 3: both
% list of posiible best moves above a certain threshold for further 

if nargin < 3
    ghostNo=0;
end

bestMove=[];   
bestValue = threshold;

switch strategy
    case 1
        for i = 1:length(gameState.ghosts.good)
            if (gameState.ghosts.good(i).moves.up > bestValue) && (ghostNo~=i)
                bestMove = [bestMove;i, 1,gameState.ghosts.good(i).moves.up];
%                 bestValue = gameState.ghosts.good(i).moves.up;
            elseif (gameState.ghosts.good(i).moves.up == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 1,gameState.ghosts.good(i).moves.up];
            end
            if (gameState.ghosts.good(i).moves.down > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i, 2,gameState.ghosts.good(i).moves.down];
%                 bestValue = gameState.ghosts.good(i).moves.down;
            elseif (gameState.ghosts.good(i).moves.down == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 2,gameState.ghosts.good(i).moves.down];
            end
            if (gameState.ghosts.good(i).moves.left > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i, 3, gameState.ghosts.good(i).moves.left];
%                 bestValue = gameState.ghosts.good(i).moves.left;
            elseif (gameState.ghosts.good(i).moves.left == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 3,gameState.ghosts.good(i).moves.left];
            end
            if (gameState.ghosts.good(i).moves.right > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i, 4,gameState.ghosts.good(i).moves.right];
%                 bestValue = gameState.ghosts.good(i).moves.right;
            elseif (gameState.ghosts.good(i).moves.right == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 4,gameState.ghosts.good(i).moves.right];
            end
        end
    case 2
        for i = 1:length(gameState.ghosts.evil)
            if (gameState.ghosts.evil(i).moves.up > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i+4, 1,gameState.ghosts.evil(i).moves.up];
%                 bestValue = gameState.ghosts.evil(i).moves.up;
            elseif (gameState.ghosts.evil(i).moves.up == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 1,gameState.ghosts.evil(i).moves.up];
            end
            if (gameState.ghosts.evil(i).moves.down > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i+4, 2,gameState.ghosts.evil(i).moves.down];
%                 bestValue = gameState.ghosts.evil(i).moves.down;
            elseif (gameState.ghosts.evil(i).moves.down == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 2,gameState.ghosts.evil(i).moves.down];
            end
            if (gameState.ghosts.evil(i).moves.left > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i+4, 3,gameState.ghosts.evil(i).moves.left];
%                 bestValue = gameState.ghosts.evil(i).moves.left;
            elseif (gameState.ghosts.evil(i).moves.left == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 3,gameState.ghosts.evil(i).moves.left];
            end
            if (gameState.ghosts.evil(i).moves.right > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i+4, 4,gameState.ghosts.evil(i).moves.right];
%                 bestValue = gameState.ghosts.evil(i).moves.right;
            elseif (gameState.ghosts.evil(i).moves.right == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 4,gameState.ghosts.evil(i).moves.right];
            end
        end
    case 3
        for i = 1:length(gameState.ghosts.good)
            if (gameState.ghosts.good(i).moves.up > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i, 1,gameState.ghosts.good(i).moves.up];
%                 bestValue = gameState.ghosts.good(i).moves.up;
            elseif (gameState.ghosts.good(i).moves.up == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 1,gameState.ghosts.good(i).moves.up];
            end
            if (gameState.ghosts.good(i).moves.down > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i, 2,gameState.ghosts.good(i).moves.down];
%                 bestValue = gameState.ghosts.good(i).moves.down;
            elseif (gameState.ghosts.good(i).moves.down == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 2,gameState.ghosts.good(i).moves.down];
            end
            if (gameState.ghosts.good(i).moves.left > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i, 3,gameState.ghosts.good(i).moves.left];
%                 bestValue = gameState.ghosts.good(i).moves.left;
            elseif (gameState.ghosts.good(i).moves.left == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 3,gameState.ghosts.good(i).moves.left];
            end
            if (gameState.ghosts.good(i).moves.right > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i, 4,gameState.ghosts.good(i).moves.right];
%                 bestValue = gameState.ghosts.good(i).moves.right;
            elseif (gameState.ghosts.good(i).moves.right == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i, 4,gameState.ghosts.good(i).moves.right];
            end
        end
        
        
        for i = 1:length(gameState.ghosts.evil)
            if (gameState.ghosts.evil(i).moves.up > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i+4, 1,gameState.ghosts.evil(i).moves.up];
%                 bestValue = gameState.ghosts.evil(i).moves.up;
            elseif (gameState.ghosts.evil(i).moves.up == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 1,gameState.ghosts.evil(i).moves.up];
            end
            if (gameState.ghosts.evil(i).moves.down > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i+4, 2,gameState.ghosts.evil(i).moves.down];
%                 bestValue = gameState.ghosts.evil(i).moves.down;
            elseif (gameState.ghosts.evil(i).moves.down == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 2,gameState.ghosts.evil(i).moves.down];
            end
            if (gameState.ghosts.evil(i).moves.left > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i+4, 3,gameState.ghosts.evil(i).moves.left];
%                 bestValue = gameState.ghosts.evil(i).moves.left;
            elseif (gameState.ghosts.evil(i).moves.left == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 3,gameState.ghosts.evil(i).moves.left];
            end
            if (gameState.ghosts.evil(i).moves.right > bestValue)&& (ghostNo~=i)
                bestMove = [bestMove;i+4, 4,gameState.ghosts.evil(i).moves.right];
%                 bestValue = gameState.ghosts.evil(i).moves.right;
            elseif (gameState.ghosts.evil(i).moves.right == bestValue)&& (ghostNo~=i)
                bestMove = [bestMove; i+4, 4,gameState.ghosts.evil(i).moves.right];
            end
        end
        
    otherwise
        disp('unknown strategy!!');
end

