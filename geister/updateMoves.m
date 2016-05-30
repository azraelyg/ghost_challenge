%--------------------------------------------------------------------------
% updateMoves.m
% Updates the value of each possible move for all ghosts. Returns an
% updated gameState data structure.
%--------------------------------------------------------------------------

function gameState = updateMoves(gameState,chromosome)

% Update goals
if nargin ==1
    gameState = updateGoals(gameState);
    gameState = updateGoalsEvil(gameState);
else
    % user provided chromosomes
    [fis1,fis2]  = createRuleBaseTrapezoid(chromosome);
    gameState = updateGoodGoalsWithRules(gameState,fis1);
    gameState = updateEvilGoalsWithRules(gameState,fis2);
end

% Loop through all good ghosts
for i = 1:length(gameState.ghosts.good)
    thisGhost = gameState.ghosts.good(i);
    
    % Initialize move values to zero
    thisGhost.moves.up = 0;
    thisGhost.moves.down = 0;
    thisGhost.moves.left = 0;
    thisGhost.moves.right = 0;
    
    %Check which moves are vaild
    upValid = false;
    if thisGhost.row < 5
        type = gameState.board(5 - thisGhost.row, thisGhost.col + 1);
        if  type == 0 || type == 3
            upValid = true;
        end
    end
    downValid = false;
    if thisGhost.row > 0
        type = gameState.board(7 - thisGhost.row, thisGhost.col + 1);
        if type == 0 || type == 3
            downValid = true;
        end
    end
    leftValid = false;
    if thisGhost.col > 0
        type = gameState.board(6 - thisGhost.row, thisGhost.col);
        if type == 0 || type == 3
            leftValid = true;
        end
    end
    if thisGhost.col == 0 && thisGhost.row == 5
        leftValid = true;
    end
    rightValid = false;
    if thisGhost.col < 5
        type = gameState.board(6 - thisGhost.row, thisGhost.col + 2);
        if type == 0 || type == 3
            rightValid = true;
        end
    end
    if thisGhost.col == 5 && thisGhost.row == 5
        rightValid = true;
    end
    
    % Loop over all goals for this ghost
    for j = 1:length(thisGhost.goals)  
        if thisGhost.goals(j).row == thisGhost.row && thisGhost.goals(j).col == thisGhost.col
            % Case where this ghost is already at the goal location
        elseif thisGhost.goals(j).row == thisGhost.row
            % Case where goal is directly to the left or right
            if thisGhost.goals(j).col < thisGhost.col && leftValid
                thisGhost.moves.left = thisGhost.moves.left + thisGhost.goals(j).value;
            elseif thisGhost.goals(j).col > thisGhost.col && rightValid
                thisGhost.moves.right = thisGhost.moves.right + thisGhost.goals(j).value;
            end
        elseif thisGhost.goals(j).col == thisGhost.col
            % Case where goal is directly above or below
            if thisGhost.goals(j).row < thisGhost.row && downValid
                thisGhost.moves.down = thisGhost.moves.down + thisGhost.goals(j).value;
            elseif thisGhost.goals(j).row > thisGhost.row && upValid
                thisGhost.moves.up = thisGhost.moves.up + thisGhost.goals(j).value;
            end
        else
            % Case where the goal is at an angle
            if thisGhost.goals(j).row > thisGhost.row && upValid
                thisGhost.moves.up = thisGhost.moves.up + thisGhost.goals(j).value / 2;
            end
            if thisGhost.goals(j).row < thisGhost.row && downValid
                thisGhost.moves.down = thisGhost.moves.down + thisGhost.goals(j).value / 2;
            end
            if thisGhost.goals(j).col < thisGhost.col && leftValid
                thisGhost.moves.left = thisGhost.moves.left + thisGhost.goals(j).value / 2;
            end
            if thisGhost.goals(j).col > thisGhost.col && rightValid
                thisGhost.moves.right = thisGhost.moves.right + thisGhost.goals(j).value / 2;
            end
        end            
    end
    
    % Update this ghost
    gameState.ghosts.good(i) = thisGhost;
end

% Loop through all evil ghosts
for i = 1:length(gameState.ghosts.evil)
    thisGhost = gameState.ghosts.evil(i);
    
    % Initialize move values to zero
    thisGhost.moves.up = 0;
    thisGhost.moves.down = 0;
    thisGhost.moves.left = 0;
    thisGhost.moves.right = 0;
    
    %Check which moves are vaild
    % for tempt, i dont want to capture
    upValid = false;
    if thisGhost.row < 5
        type = gameState.board(5 - thisGhost.row, thisGhost.col + 1);
        if  type == 0 ||type == 3
            upValid = true;
        end
    end
    downValid = false;
    if thisGhost.row > 0
        type = gameState.board(7 - thisGhost.row, thisGhost.col + 1);
        if type == 0 || type == 3
            downValid = true;
        end
    end
    leftValid = false;
    if thisGhost.col > 0
        type = gameState.board(6 - thisGhost.row, thisGhost.col);
        if type == 0 || type == 3
            leftValid = true;
        end
    end
    if thisGhost.col == 0 && thisGhost.row == 5
        leftValid = true;
    end
    rightValid = false;
    if thisGhost.col < 5
        type = gameState.board(6 - thisGhost.row, thisGhost.col + 2);
        if type == 0 || type == 3
            rightValid = true;
        end
    end
    if thisGhost.col == 5 && thisGhost.row == 5
        rightValid = true;
    end
    
    % Loop over all goals for this ghost
    for j = 1:length(thisGhost.goals)  
        
%         if strcmp(thisGhost.goals(j).name,'TemptClosestGhost')
%             if (abs(thisGhost.goals(j).row - thisGhost.row) < 1) && (abs(thisGhost.goals(j).col - thisGhost.col) < 1) && (thisGhost.goals(j).value > .5)% within vicinity & tempt value high
%                 clc;
% 
%                 disp('Adjusting weights for tempt')
%                 thisGhost.moves.left = thisGhost.moves.left + thisGhost.goals(j).value/2; % 4 may be too little e.g. 0.6/4 = .15..better to have at least .3
%                 thisGhost.moves.right = thisGhost.moves.right + thisGhost.goals(j).value/2;
%                 thisGhost.moves.up = thisGhost.moves.up + thisGhost.goals(j).value/2;
%                 thisGhost.moves.down = thisGhost.moves.down + thisGhost.goals(j).value/2;
%             end
%         end
        if thisGhost.goals(j).row == thisGhost.row && thisGhost.goals(j).col == thisGhost.col
            % Case where this ghost is already at the goal location
            thisGhost.moves.up = thisGhost.moves.up - thisGhost.goals(j).value;
            thisGhost.moves.down = thisGhost.moves.down - thisGhost.goals(j).value;
            thisGhost.moves.left = thisGhost.moves.left - thisGhost.goals(j).value;
            thisGhost.moves.right = thisGhost.moves.right - thisGhost.goals(j).value;
        elseif thisGhost.goals(j).row == thisGhost.row
            % Case where goal is directly to the left or right
            if thisGhost.goals(j).col < thisGhost.col && leftValid
                thisGhost.moves.left = thisGhost.moves.left + thisGhost.goals(j).value;
            elseif thisGhost.goals(j).col > thisGhost.col && rightValid
                thisGhost.moves.right = thisGhost.moves.right + thisGhost.goals(j).value;
            end
        elseif thisGhost.goals(j).col == thisGhost.col
            % Case where goal is directly above or below
            if thisGhost.goals(j).row < thisGhost.row && downValid
                thisGhost.moves.down = thisGhost.moves.down + thisGhost.goals(j).value;
            elseif thisGhost.goals(j).row > thisGhost.row && upValid
                thisGhost.moves.up = thisGhost.moves.up + thisGhost.goals(j).value;
            end
        else
            % Case where the goal is at an angle
            if thisGhost.goals(j).row > thisGhost.row && upValid
                thisGhost.moves.up = thisGhost.moves.up + thisGhost.goals(j).value / 2;
            end
            if thisGhost.goals(j).row < thisGhost.row && downValid
                thisGhost.moves.down = thisGhost.moves.down + thisGhost.goals(j).value / 2;
            end
            if thisGhost.goals(j).col < thisGhost.col && leftValid
                thisGhost.moves.left = thisGhost.moves.left + thisGhost.goals(j).value / 2;
            end
            if thisGhost.goals(j).col > thisGhost.col && rightValid
                thisGhost.moves.right = thisGhost.moves.right + thisGhost.goals(j).value / 2;
            end
        end            
    end
    
    % Update this ghost
    gameState.ghosts.evil(i) = thisGhost;
end