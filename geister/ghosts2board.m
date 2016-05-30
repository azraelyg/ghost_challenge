%--------------------------------------------------------------------------
% ghosts2board.m
% Creates a displayable matrix of the board state from a ghost data
% structure. The following values are used:
%     0 = Empty
%     1 = Good Ghost
%     2 = Evil Ghost
%     3 = Opponent Ghost
%
% The finished variable is 0 if the game is not finished, 1 if player 1 has
% won by exiting the board, and 2 if player 2 has won by exiting the board.
%
% Note that the indicies of the board matrix are NOT the same as the grid
% coordinates in the ghost data structure.
%--------------------------------------------------------------------------

function [board, finished] = ghosts2board(ghosts)

% Create empty board
board = zeros(6);
finished = 0;

% Add good ghosts
for i = 1:length(ghosts.good)
    if ghosts.good(i).col >= 0 && ghosts.good(i).col <= 5
        board(6 - ghosts.good(i).row, ghosts.good(i).col + 1) = 1;
    else
        finished = 1;
    end
end

% Add evil ghosts
for i = 1:length(ghosts.evil)
    if ghosts.evil(i).col >= 0 && ghosts.evil(i).col <= 5
        board(6 - ghosts.evil(i).row, ghosts.evil(i).col + 1) = 2;
    else
        error('Evil ghost has moved off the board.');
    end
end

% Add opponent ghosts
for i = 1:length(ghosts.opponent)
    if ghosts.opponent(i).col >= 0 && ghosts.opponent(i).col <= 5
        board(6 - ghosts.opponent(i).row, ghosts.opponent(i).col + 1) = 3;
    else
        finished = 2;
    end
end