%--------------------------------------------------------------------------
% updateGoals.m
% Upates the value of each goal for all of our own ghosts. Returns an
% updated gameState data structure.
% called by updateMoves.m
%--------------------------------------------------------------------------

function gameState = updateEvilGoalsWithRules(gameState,fis)

% Update features
gameState = updateFeaturesNormalized(gameState);

% Loop through all evil ghosts
for i = 1:length(gameState.ghosts.evil)
    thisGhost = gameState.ghosts.evil(i);
    otherGhostCloserToHomeExit=0;
    selfDistHomeExit = thisGhost.features.DistToHomeExit;
    for j=1:length(gameState.ghosts.evil)
        if i~=j
           curGhostDist =  gameState.ghosts.evil(j).features.DistToHomeExit;
           if curGhostDist <= selfDistHomeExit % need to play more with equal to option...dont want a situation where no one blocks
               otherGhostCloserToHomeExit = otherGhostCloserToHomeExit+1;
           end
        end
    end
    for j=1:length(gameState.ghosts.good)
        curGhostDist =  gameState.ghosts.good(j).features.DistToHomeExit;
        if curGhostDist <= selfDistHomeExit
            otherGhostCloserToHomeExit = otherGhostCloserToHomeExit+1;
        end
    end

%     otherGhostCloserToHomeExit = otherGhostCloserToHomeExit/8; % not checked if this is requireed or not

    % Construct feature vector
    features = [gameState.features.CapturedGood/3, ...
                gameState.features.CapturedEvil/3, ...
                gameState.features.LostGood/3, ...
                gameState.features.LostEvil/3, ...
                thisGhost.features.ClosestGhostDist/10, ...
                thisGhost.features.ClosestGhostGoodConf, ...
                thisGhost.features.ClosestGhostEvilConf, ...
                thisGhost.features.DistToOpponentExit/8, ...
                thisGhost.features.ExitCongestion/8, ...
                thisGhost.features.OpponentDistToHomeExit/8, ...
                thisGhost.features.DistToHomeExit/10, ...
                otherGhostCloserToHomeExit/8];

            
     % Evaluate fuzzy inference system
     output = evalfis(features, fis);
     
     % Remove any existing goals
     thisGhost.goals = [];
     
     % Add goal to capture the closest ghost
     goal = [];
     goal.name = 'CAPTURE_CLOSEST_GHOST';
     goal.value = output(1);
     goal.row = thisGhost.features.ClosestGhostRow;
     goal.col = thisGhost.features.ClosestGhostCol;
     thisGhost.goals = [thisGhost.goals, goal];

     
     % Add goals to tempt the closest ghost
     temptRow = thisGhost.features.ClosestGhostRow;
     temptCol = thisGhost.features.ClosestGhostCol;
     % Check above the ghost
     if temptRow < 5
        if gameState.board(5-temptRow, temptCol+1) < 3
            goal = [];
            goal.name = 'TEMPT_FROM_ABOVE     ';
            goal.value = output(2) / 2;
            goal.row = temptRow + 1;
            goal.col = temptCol;
            thisGhost.goals = [thisGhost.goals, goal];
        end
     end
     % Check below the ghost
     if temptRow > 0
        if gameState.board(7-temptRow, temptCol+1) < 3
            goal = [];
            goal.name = 'TEMPT_FROM_BELOW     ';
            goal.value = output(2) / 2;
            goal.row = temptRow - 1;
            goal.col = temptCol;
            thisGhost.goals = [thisGhost.goals, goal];
        end
     end
     % Check to the left of the ghost
     if temptCol > 0
        if gameState.board(6-temptRow, temptCol) < 3
            goal = [];
            goal.name = 'TEMPT_FROM_LEFT      ';
            goal.value = output(2) / 2;
            goal.row = temptRow;
            goal.col = temptCol - 1;
            thisGhost.goals = [thisGhost.goals, goal];
        end
     end
     % Check to the right of the ghost
     if temptCol < 5
        if gameState.board(6-temptRow, temptCol+2) < 3
            goal = [];
            goal.name = 'TEMPT_FROM_RIGHT     ';
            goal.value = output(2) / 2;
            goal.row = temptRow;
            goal.col = temptCol + 1;
            thisGhost.goals = [thisGhost.goals, goal];
        end
     end
     
%      goal = [];
%      goal.name = 'TemptClosestGhost';
%      goal.value = output(2);
%      goal.row = thisGhost.features.ClosestGhostRow;
%      goal.col = thisGhost.features.ClosestGhostCol;
%      thisGhost.goals = [thisGhost.goals, goal];
     
     % Add goal to win the game by exiting
%      goal = [];
%      goal.name = 'Exit';
%      goal.value = output(2);
%      goal.row = 5;
%      if thisGhost.col < 4
%          goal.col = -1;
%      else
%          goal.col = 6;
%      end
%      thisGhost.goals = [thisGhost.goals, goal];
%      
%      % Add goals to escape capture
%      % Check up
%      upValid = true;
%      if thisGhost.row < 5
%         if checkSpaceSafety(gameState.board, thisGhost.row + 1, thisGhost.col)
%             goal = [];
%             goal.name = 'Escape Up';
%             goal.value = output(3);
%             goal.row = thisGhost.row + 1;
%             goal.col = thisGhost.col;
%             thisGhost.goals = [thisGhost.goals, goal];
%         end
%      end
%      % Check down
%      if thisGhost.row > 0
%         if checkSpaceSafety(gameState.board, thisGhost.row - 1, thisGhost.col) == 0
%             goal = [];
%             goal.name = 'Escape Down';
%             goal.value = output(3);
%             goal.row = thisGhost.row - 1;
%             goal.col = thisGhost.col;
%             thisGhost.goals = [thisGhost.goals, goal];
%         end
%      end
%      % Check left
%      if thisGhost.col > 0
%         if checkSpaceSafety(gameState.board, thisGhost.row, thisGhost.col - 1) == 0
%             goal = [];
%             goal.name = 'Escape Left';
%             goal.value = output(3);
%             goal.row = thisGhost.row;
%             goal.col = thisGhost.col - 1;
%             thisGhost.goals = [thisGhost.goals, goal];
%         end
%      end
%      % Check right
%      if thisGhost.col < 5
%         if checkSpaceSafety(gameState.board, thisGhost.row, thisGhost.col + 1) == 0
%             goal = [];
%             goal.name = 'Escape Right';
%             goal.value = output(3);
%             goal.row = thisGhost.row;
%             goal.col = thisGhost.col + 1;
%             thisGhost.goals = [thisGhost.goals, goal];
%         end
%      end
     
     % Add goal for blocking the home exit
     goal = [];
     goal.name = 'BLOCK                ';
     goal.value = output(3);
     goal.row = 0;
     if thisGhost.features.OpponentClosestToExitLR == 0
         goal.col = 0;
     else
         goal.col = 5;
     end
     thisGhost.goals = [thisGhost.goals, goal];
    
     gameState.ghosts.evil(i) = thisGhost;
end


%--------------------------------------------------------------------------
% Takes a board position in standard server coordinates and returns true if
% the space is empty and is not adjacent to an opponent ghost.
%--------------------------------------------------------------------------
function safe = checkSpaceSafety(board, row, col)

safe = true;
if board(6 - row, col + 1) > 0
    % Check that the space is empty
    safe = false;
else
    % Check for opponents above
    if row < 5
        if board(5 - row, col + 1) == 3
            safe = false;
        end
    end
    
    % Check for opponents below
    if row > 0
        if board(7 - row, col + 1) == 3
            safe = false;
        end
    end
    
    % Check for opponents to the left
    if col > 0
        if board(6 - row, col) == 3
            safe = false;
        end
    end
    
    % Check for opponents to the right
    if col < 5
        if board(6 - row, col + 2) == 3
            safe = false;
        end
    end
end