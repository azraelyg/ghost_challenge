%--------------------------------------------------------------------------
% drawBoard.m
% Draws the game board
%--------------------------------------------------------------------------

function figHandle = drawBoard(board, handle)
        
% Create figure
figHandle = figure(handle);

% Create axes
axesHandle = axes;
set(axesHandle, 'box', 'on');
set(axesHandle, 'xtick', []);
set(axesHandle, 'ytick', []);
set(axesHandle, 'xtick', 0.5:5.5);
set(axesHandle, 'ytick', 0.5:5.5);
set(axesHandle, 'xticklabel', {'0';'1';'2';'3';'4';'5'});
set(axesHandle, 'yticklabel', {'5';'4';'3';'2';'1';'0'});
set(axesHandle, 'TickLength', [0 0]);
axis([0 6 0 6]);
axis square;
axis ij;

            
% Clear board
cla;

% Draw grid
for i = 0:6
    line([i i], [0 6], 'color', 'k');
    line([0 6], [i i], 'color', 'k');
end

% Draw escape arrows
patch([0.2 0.4 0.4 0.8 0.8 0.4 0.4], [0.5 0.35 0.45 0.45 0.55 0.55 0.65], [1 1 0.7]);
patch([0.2 0.4 0.4 0.8 0.8 0.4 0.4], [5.5 5.35 5.45 5.45 5.55 5.55 5.65], [1 1 0.7]);
patch([5.8 5.6 5.6 5.2 5.2 5.6 5.6], [0.5 0.35 0.45 0.45 0.55 0.55 0.65], [1 1 0.7]);
patch([5.8 5.6 5.6 5.2 5.2 5.6 5.6], [5.5 5.35 5.45 5.45 5.55 5.55 5.65], [1 1 0.7]);

% Draw ghosts
for i = 1:6
    for j = 1:6
        if board(i,j) == 1
            % Self good
            patch([j-0.75 j-0.5 j-0.25], [i-0.25 i-0.75 i-0.25], [0 0 1]);
        elseif board(i,j) == 2
            % Self evil
            patch([j-0.75 j-0.5 j-0.25], [i-0.25 i-0.75 i-0.25], [1 0 0]);
        elseif board(i,j) == 3
            % Opponent
            patch([j-0.75 j-0.5 j-0.25], [i-0.75 i-0.25 i-0.75], [0.5 0.5 0.5]);
        end
    end
end
drawnow;