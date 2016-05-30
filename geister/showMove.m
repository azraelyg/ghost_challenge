function figHandle = showMove(handle, flipped, oldRow, oldCol, newRow, newCol)

% Set figure
figHandle = figure(handle);

if ~flipped
    
    line([oldCol+0.5 newCol+0.5], [5.5-oldRow, 5.5-newRow], 'LineWidth', 3, 'Color', [0.2 0.2 0.2]);
    
else
    
    line([oldCol+0.5 newCol+0.5], [5.5-oldRow 5.5-newRow], 'LineWidth', 3, 'Color', [0.2 0.2 0.2]);
    
end

drawnow;