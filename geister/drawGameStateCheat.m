%--------------------------------------------------------------------------
% drawGameState.m
% Draws the game board and the relative utility value of each possible
% move.
%--------------------------------------------------------------------------

function figHandle = drawGameStateCheat(gameState, drawOpponents, handle)
        
drawMoves = false;
flipped = true;

% Create figure
figHandle = figure(handle);

% Create axes
axesHandle = axes;
set(axesHandle, 'box', 'on');
set(axesHandle, 'xtick', []);
set(axesHandle, 'ytick', []);
% set(axesHandle, 'xtick', 0.5:5.5);
% set(axesHandle, 'ytick', 0.5:5.5);
% set(axesHandle, 'xticklabel', {'0';'1';'2';'3';'4';'5'});
% set(axesHandle, 'yticklabel', {'5';'4';'3';'2';'1';'0'});
% set(axesHandle, 'TickLength', [.01 .01]);
% set(axesHandle, 'TickDir', 'out');
% if ~flipped    
%    
% else
%    set(axesHandle, 'XAxisLocation', 'top');
% %    set(axesHandle, 'YAxisLocation', 'right');
% end
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

if ~flipped

    % Draw ghosts
    for i = 1:6
        for j = 1:6
            if gameState.board(i,j) == 1
                % Self good
                patch([j-0.75 j-0.5 j-0.25], [i-0.25 i-0.75 i-0.25], [0 0 1]);
            elseif gameState.board(i,j) == 2
                % Self evil
                patch([j-0.75 j-0.5 j-0.25], [i-0.25 i-0.75 i-0.25], [1 0 0]);
            elseif gameState.board(i,j) == 3
                % Opponent
    %             patch([j-0.75 j-0.5 j-0.25], [i-0.75 i-0.25 i-0.75], [0.5 0.5 0.5]);
            end
        end
    end

    % Draw opponents
    for i = 1:length(gameState.ghosts.opponent)

        ghost = gameState.ghosts.opponent(i);
        row = 6 - ghost.row;
        col = ghost.col + 1;

        good = ghost.goodConf;
        evil = ghost.evilConf;

        color = hsv2rgb( (((evil-good)+1)*0.5)/3 + 2/3 , abs(evil - good), 0.9);
        patch([col-0.75 col-0.5 col-0.25], [row-0.75 row-0.25 row-0.75], color);

        text(col-0.95, row-0.95, num2str(ghost.goodConf, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Top');
        text(col-0.05, row-0.95, num2str(ghost.evilConf, 2), 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Top');

    end

    if drawMoves

        % Determine the max utility value
        maxval = 0;
        for i = 1:length(gameState.ghosts.good)
            if gameState.ghosts.good(i).moves.up > maxval
                maxval = gameState.ghosts.good(i).moves.up;
            end
            if gameState.ghosts.good(i).moves.down > maxval
                maxval = gameState.ghosts.good(i).moves.down;
            end
            if gameState.ghosts.good(i).moves.left > maxval
                maxval = gameState.ghosts.good(i).moves.left;
            end
            if gameState.ghosts.good(i).moves.right > maxval
                maxval = gameState.ghosts.good(i).moves.right;
            end
        end
        % Determine the max utility value evil ghosts
%         maxval = 0;
        for i = 1:length(gameState.ghosts.evil)
            if gameState.ghosts.evil(i).moves.up > maxval
                maxval = gameState.ghosts.evil(i).moves.up;
            end
            if gameState.ghosts.evil(i).moves.down > maxval
                maxval = gameState.ghosts.evil(i).moves.down;
            end
            if gameState.ghosts.evil(i).moves.left > maxval
                maxval = gameState.ghosts.evil(i).moves.left;
            end
            if gameState.ghosts.evil(i).moves.right > maxval
                maxval = gameState.ghosts.evil(i).moves.right;
            end
        end

        % Draw move utility values
        for i = 1:length(gameState.ghosts.good)
            ghost = gameState.ghosts.good(i);
            row = 6 - ghost.row;
            col = ghost.col + 1;
            if ghost.moves.up > 0
                color = hsv2rgb([ghost.moves.up/(maxval*3) 1 1]);
        %         patch([col-1 col-0.5 col], [row-1 row-1.2 row-1], color);
                patch([col-0.6 col-0.5 col-0.4], [row-0.8 row-1 row-0.8], color);
                if ghost.moves.up == maxval
                    text(col-0.4, row-0.9, num2str(ghost.moves.up, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'FontWeight', 'Bold');
                else
                    text(col-0.4, row-0.9, num2str(ghost.moves.up, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle');
                end
            end
            if ghost.moves.down > 0
                color = hsv2rgb([ghost.moves.down/(maxval*3) 1 1]);
        %         patch([col-1 col-0.5 col], [row row+0.2 row], color);
                patch([col-0.6 col-0.5 col-0.4], [row-0.2 row row-0.2], color);
                if ghost.moves.down == maxval
                    text(col-0.6, row-0.1, num2str(ghost.moves.down, 2), 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle', 'FontWeight', 'Bold');
                else
                    text(col-0.6, row-0.1, num2str(ghost.moves.down, 2), 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle');
                end
            end
            if ghost.moves.left > 0
                color = hsv2rgb([ghost.moves.left/(maxval*3) 1 1]);
        %         patch([col-1 col-1.2 col-1], [row-1 row-0.5 row], color);
                patch([col-0.8 col-1 col-0.8], [row-0.6 row-0.5 row-0.4], color);
                if ghost.moves.left == maxval
                    text(col-0.9, row-0.6, num2str(ghost.moves.left, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 90, 'FontWeight', 'Bold');
                else
                    text(col-0.9, row-0.6, num2str(ghost.moves.left, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 90);
                end
            end
            if ghost.moves.right > 0
                color = hsv2rgb([ghost.moves.right/(maxval*3) 1 1]);
        %         patch([col col+0.2 col], [row-1 row-0.5 row], color);
                patch([col-0.2 col col-0.2], [row-0.6 row-0.5 row-0.4], color);
                if ghost.moves.right == maxval
                    text(col-0.1, row-0.4, num2str(ghost.moves.right, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 270, 'FontWeight', 'Bold');
                else
                    text(col-0.1, row-0.4, num2str(ghost.moves.right, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 270);
                end
            end
        end



        

        % Draw move utility values
        for i = 1:length(gameState.ghosts.evil)
            ghost = gameState.ghosts.evil(i);
            row = 6 - ghost.row;
            col = ghost.col + 1;
            if ghost.moves.up > 0
                color = hsv2rgb([ghost.moves.up/(maxval*3) 1 1]);
        %         patch([col-1 col-0.5 col], [row-1 row-1.2 row-1], color);
                patch([col-0.6 col-0.5 col-0.4], [row-0.8 row-1 row-0.8], color);
                if ghost.moves.up == maxval
                    text(col-0.4, row-0.9, num2str(ghost.moves.up, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'FontWeight', 'Bold');
                else
                    text(col-0.4, row-0.9, num2str(ghost.moves.up, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle');
                end
            end
            if ghost.moves.down > 0
                color = hsv2rgb([ghost.moves.down/(maxval*3) 1 1]);
        %         patch([col-1 col-0.5 col], [row row+0.2 row], color);
                patch([col-0.6 col-0.5 col-0.4], [row-0.2 row row-0.2], color);
                if ghost.moves.down == maxval
                    text(col-0.6, row-0.1, num2str(ghost.moves.down, 2), 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle', 'FontWeight', 'Bold');
                else
                    text(col-0.6, row-0.1, num2str(ghost.moves.down, 2), 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle');
                end
            end
            if ghost.moves.left > 0
                color = hsv2rgb([ghost.moves.left/(maxval*3) 1 1]);
        %         patch([col-1 col-1.2 col-1], [row-1 row-0.5 row], color);
                patch([col-0.8 col-1 col-0.8], [row-0.6 row-0.5 row-0.4], color);
                if ghost.moves.left == maxval
                    text(col-0.9, row-0.6, num2str(ghost.moves.left, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 90, 'FontWeight', 'Bold');
                else
                    text(col-0.9, row-0.6, num2str(ghost.moves.left, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 90);
                end
            end
            if ghost.moves.right > 0
                color = hsv2rgb([ghost.moves.right/(maxval*3) 1 1]);
        %         patch([col col+0.2 col], [row-1 row-0.5 row], color);
                patch([col-0.2 col col-0.2], [row-0.6 row-0.5 row-0.4], color);
                if ghost.moves.right == maxval
                    text(col-0.1, row-0.4, num2str(ghost.moves.right, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 270, 'FontWeight', 'Bold');
                else
                    text(col-0.1, row-0.4, num2str(ghost.moves.right, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 270);
                end
            end
        end

    end

else
    
    % Draw flipped version of the board
    
    set(gca, 'CameraUpVector', [0 1 0])
    
    % Draw ghosts
    for i = 1:6
        for j = 1:6
            if gameState.board(i,j) == 1
                % Self good
                patch([j-0.75 j-0.5 j-0.25], [i-0.25 i-0.75 i-0.25], [0 0 1]);
            elseif gameState.board(i,j) == 2
                % Self evil
                patch([j-0.75 j-0.5 j-0.25], [i-0.25 i-0.75 i-0.25], [1 0 0]);
            elseif gameState.board(i,j) == 3
                % Opponent
    %             patch([j-0.75 j-0.5 j-0.25], [i-0.75 i-0.25 i-0.75], [0.5 0.5 0.5]);
            end
        end
    end

    % Draw opponents
    if drawOpponents
        for i = 1:length(gameState.ghosts.opponent)

            ghost = gameState.ghosts.opponent(i);
            row = 6 - ghost.row;
            col = ghost.col + 1;

            good = ghost.goodConf;
            evil = ghost.evilConf;

            color = hsv2rgb( (((evil-good)+1)*0.5)/3 + 2/3 , abs(evil - good), 0.9);
            patch([col-0.75 col-0.5 col-0.25], [row-0.75 row-0.25 row-0.75], color);

            if drawMoves
                text(col-0.05, row-0.95, num2str(ghost.goodConf, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Bottom');
                text(col-0.95, row-0.95, num2str(ghost.evilConf, 2), 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Bottom');
            end

        end
    end

    if drawMoves

        % Determine the max utility value
        maxval = 0;
        for i = 1:length(gameState.ghosts.good)
            if gameState.ghosts.good(i).moves.up > maxval
                maxval = gameState.ghosts.good(i).moves.up;
            end
            if gameState.ghosts.good(i).moves.down > maxval
                maxval = gameState.ghosts.good(i).moves.down;
            end
            if gameState.ghosts.good(i).moves.left > maxval
                maxval = gameState.ghosts.good(i).moves.left;
            end
            if gameState.ghosts.good(i).moves.right > maxval
                maxval = gameState.ghosts.good(i).moves.right;
            end
        end
        % Determine the max utility value evil ghosts
%         maxval = 0;
        for i = 1:length(gameState.ghosts.evil)
            if gameState.ghosts.evil(i).moves.up > maxval
                maxval = gameState.ghosts.evil(i).moves.up;
            end
            if gameState.ghosts.evil(i).moves.down > maxval
                maxval = gameState.ghosts.evil(i).moves.down;
            end
            if gameState.ghosts.evil(i).moves.left > maxval
                maxval = gameState.ghosts.evil(i).moves.left;
            end
            if gameState.ghosts.evil(i).moves.right > maxval
                maxval = gameState.ghosts.evil(i).moves.right;
            end
        end
        
        % Draw move utility values
        for i = 1:length(gameState.ghosts.good)
            ghost = gameState.ghosts.good(i);
            row = 6 - ghost.row;
            col = ghost.col + 1;
            if ghost.moves.up > 0
                color = hsv2rgb([ghost.moves.up/(maxval*3) 1 1]);
        %         patch([col-1 col-0.5 col], [row-1 row-1.2 row-1], color);
                patch([col-0.6 col-0.5 col-0.4], [row-0.8 row-1 row-0.8], color);
                if ghost.moves.up == maxval
                    text(col-0.4, row-0.9, num2str(ghost.moves.up, 2), 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle', 'FontWeight', 'Bold');
                else
                    text(col-0.4, row-0.9, num2str(ghost.moves.up, 2), 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle');
                end
            end
            if ghost.moves.down > 0
                color = hsv2rgb([ghost.moves.down/(maxval*3) 1 1]);
        %         patch([col-1 col-0.5 col], [row row+0.2 row], color);
                patch([col-0.6 col-0.5 col-0.4], [row-0.2 row row-0.2], color);
                if ghost.moves.down == maxval
                    text(col-0.6, row-0.1, num2str(ghost.moves.down, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'FontWeight', 'Bold');
                else
                    text(col-0.6, row-0.1, num2str(ghost.moves.down, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle');
                end
            end
            if ghost.moves.left > 0
                color = hsv2rgb([ghost.moves.left/(maxval*3) 1 1]);
        %         patch([col-1 col-1.2 col-1], [row-1 row-0.5 row], color);
                patch([col-0.8 col-1 col-0.8], [row-0.6 row-0.5 row-0.4], color);
                if ghost.moves.left == maxval
                    text(col-0.9, row-0.6, num2str(ghost.moves.left, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 270, 'FontWeight', 'Bold');
                else
                    text(col-0.9, row-0.6, num2str(ghost.moves.left, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 270);
                end
            end
            if ghost.moves.right > 0
                color = hsv2rgb([ghost.moves.right/(maxval*3) 1 1]);
        %         patch([col col+0.2 col], [row-1 row-0.5 row], color);
                patch([col-0.2 col col-0.2], [row-0.6 row-0.5 row-0.4], color);
                if ghost.moves.right == maxval
                    text(col-0.1, row-0.4, num2str(ghost.moves.right, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 90, 'FontWeight', 'Bold');
                else
                    text(col-0.1, row-0.4, num2str(ghost.moves.right, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 90);
                end
            end
        end



        

        % Draw move utility values
        for i = 1:length(gameState.ghosts.evil)
            ghost = gameState.ghosts.evil(i);
            row = 6 - ghost.row;
            col = ghost.col + 1;
            if ghost.moves.up > 0
                color = hsv2rgb([ghost.moves.up/(maxval*3) 1 1]);
        %         patch([col-1 col-0.5 col], [row-1 row-1.2 row-1], color);
                patch([col-0.6 col-0.5 col-0.4], [row-0.8 row-1 row-0.8], color);
                if ghost.moves.up == maxval
                    text(col-0.4, row-0.9, num2str(ghost.moves.up, 2), 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle', 'FontWeight', 'Bold');
                else
                    text(col-0.4, row-0.9, num2str(ghost.moves.up, 2), 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle');
                end
            end
            if ghost.moves.down > 0
                color = hsv2rgb([ghost.moves.down/(maxval*3) 1 1]);
        %         patch([col-1 col-0.5 col], [row row+0.2 row], color);
                patch([col-0.6 col-0.5 col-0.4], [row-0.2 row row-0.2], color);
                if ghost.moves.down == maxval
                    text(col-0.6, row-0.1, num2str(ghost.moves.down, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'FontWeight', 'Bold');
                else
                    text(col-0.6, row-0.1, num2str(ghost.moves.down, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle');
                end
            end
            if ghost.moves.left > 0
                color = hsv2rgb([ghost.moves.left/(maxval*3) 1 1]);
        %         patch([col-1 col-1.2 col-1], [row-1 row-0.5 row], color);
                patch([col-0.8 col-1 col-0.8], [row-0.6 row-0.5 row-0.4], color);
                if ghost.moves.left == maxval
                    text(col-0.9, row-0.6, num2str(ghost.moves.left, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 270, 'FontWeight', 'Bold');
                else
                    text(col-0.9, row-0.6, num2str(ghost.moves.left, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 270);
                end
            end
            if ghost.moves.right > 0
                color = hsv2rgb([ghost.moves.right/(maxval*3) 1 1]);
        %         patch([col col+0.2 col], [row-1 row-0.5 row], color);
                patch([col-0.2 col col-0.2], [row-0.6 row-0.5 row-0.4], color);
                if ghost.moves.right == maxval
                    text(col-0.1, row-0.4, num2str(ghost.moves.right, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 90, 'FontWeight', 'Bold');
                else
                    text(col-0.1, row-0.4, num2str(ghost.moves.right, 2), 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle', 'Rotation', 90);
                end
            end
        end

    end
end


drawnow;