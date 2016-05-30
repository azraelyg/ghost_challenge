%--------------------------------------------------------------------------
% updateGoals.m
% Upates the value of each goal for all of our own ghosts. Returns an
% updated gameState data structure.
% called by updateMoves.m
%--------------------------------------------------------------------------

function gameState = updateGoalsEvil(gameState)

% Update features
gameState = updateFeatures(gameState);

% Define fuzzy inference system for good ghosts
name = 'good_strategy';
type = 'mamdani';
andMethod = 'min';
orMethod = 'max';
impMethod = 'min';
aggMethod = 'sum';
defuzzMethod = 'mom';

fis = newfis(name, type, andMethod, orMethod, impMethod, aggMethod, defuzzMethod);

fis = addvar(fis, 'input', 'CAPTURED_GOOD', [0 3]);
fis = addmf(fis, 'input', 1, 'LOW', 'trimf', [0 0 3]);
fis = addmf(fis, 'input', 1, 'HIGH', 'trimf', [0 3 3]);

fis = addvar(fis, 'input', 'CAPTURED_EVIL', [0 3]);
fis = addmf(fis, 'input', 2, 'LOW', 'trimf', [0 0 3]);%0,0,1
fis = addmf(fis, 'input', 2, 'HIGH', 'trimf', [0 3 3]);%0,1,1

fis = addvar(fis, 'input', 'LOST_GOOD', [0 3]);
fis = addmf(fis, 'input', 3, 'LOW', 'trimf', [0 0 3]);
fis = addmf(fis, 'input', 3, 'HIGH', 'trimf', [0 3 3]);

fis = addvar(fis, 'input', 'LOST_EVIL', [0 3]);
fis = addmf(fis, 'input', 4, 'LOW', 'trimf', [0 0 3]);
fis = addmf(fis, 'input', 4, 'HIGH', 'trimf', [0 3 3]);

fis = addvar(fis, 'input', 'CLOSEST_GHOST_DIST', [0 10]);
fis = addmf(fis, 'input', 5, 'ADJACENT', 'trimf', [0 1 2]);
fis = addmf(fis, 'input', 5, 'NEAR', 'trapmf', [0 0 2 6]);
fis = addmf(fis, 'input', 5, 'FAR', 'trapmf', [2 6 10 10]);

fis = addvar(fis, 'input', 'CLOSEST_GHOST_GOOD_CONFIDENCE', [0 1]);
fis = addmf(fis, 'input', 6, 'LOW', 'trimf', [0 0 1]);
fis = addmf(fis, 'input', 6, 'HIGH', 'trimf', [0 1 1]);

fis = addvar(fis, 'input', 'CLOSEST_GHOST_EVIL_CONFIDENCE', [0 1]);
fis = addmf(fis, 'input', 7, 'LOW', 'trimf', [0 0 1]);
fis = addmf(fis, 'input', 7, 'HIGH', 'trimf', [0 1 1]);

fis = addvar(fis, 'input', 'DIST_TO_OPPONENT_EXIT', [0 8]);
fis = addmf(fis, 'input', 8, 'ADJACENT', 'trimf', [0 1 2]);
fis = addmf(fis, 'input', 8, 'NEAR', 'trapmf', [0 0 2 6]);
fis = addmf(fis, 'input', 8, 'FAR', 'trapmf', [2 6 8 8]);

fis = addvar(fis, 'input', 'EXIT_CONGESTION', [0 8]);
fis = addmf(fis, 'input', 9, 'LOW', 'trimf', [0 0 8]);
fis = addmf(fis, 'input', 9, 'HIGH', 'trimf', [0 8 8]);

fis = addvar(fis, 'input', 'OPPONENT_DIST_TO_HOME_EXIT', [0 8]);
fis = addmf(fis, 'input', 10, 'ADJACENT', 'trimf', [0 1 2]);
fis = addmf(fis, 'input', 10, 'NEAR', 'trapmf', [0 0 2 7]);
fis = addmf(fis, 'input', 10, 'FAR', 'trapmf', [2 7 8 8]);

fis = addvar(fis, 'input', 'DIST_TO_HOME_EXIT', [0 10]);
fis = addmf(fis, 'input', 11, 'ADJACENT', 'trimf', [0 1 2]);
fis = addmf(fis, 'input', 11, 'NEAR', 'trapmf', [0 0 2 4]);
fis = addmf(fis, 'input', 11, 'FAR', 'trapmf', [2 4 10 10]);

fis = addvar(fis, 'input', 'OTHERS_DIST_TO_HOME_EXIT', [0 8]);
fis = addmf(fis, 'input', 12, 'LOW', 'trimf', [0 1 2]);
fis = addmf(fis, 'input', 12, 'MEDIUM', 'trapmf', [0 0 2 7]);
fis = addmf(fis, 'input', 12, 'HIGH', 'trapmf', [2 7 8 8]);


fis = addvar(fis, 'output', 'CAPTURE_CLOSEST_GHOST', [0 1]);
fis = addmf(fis, 'output', 1, 'LOW', 'trimf', [0 0 0.4]);
fis = addmf(fis, 'output', 1, 'MEDIUM', 'trimf', [0.1 0.5 0.9]);
fis = addmf(fis, 'output', 1, 'HIGH', 'trimf', [0.6 1 1]);

% fis = addvar(fis, 'output', 'EXIT', [0 1]);
% fis = addmf(fis, 'output', 2, 'LOW', 'trimf', [0 0 0.4]);
% fis = addmf(fis, 'output', 2, 'MEDIUM', 'trimf', [0.1 0.5 0.9]);
% fis = addmf(fis, 'output', 2, 'HIGH', 'trimf', [0.6 1 1]);

% fis = addvar(fis, 'output', 'ESCAPE', [0 1]);
% fis = addmf(fis, 'output', 3, 'LOW', 'trimf', [0 0 0.4]);
% fis = addmf(fis, 'output', 3, 'MEDIUM', 'trimf', [0.1 0.5 0.9]);
% fis = addmf(fis, 'output', 3, 'HIGH', 'trimf', [0.6 1 1]);

fis = addvar(fis, 'output', 'TEMPT', [0 1]); % kept same values as escape so that not skewed
fis = addmf(fis, 'output', 2, 'LOW', 'trimf', [0 0 0.4]);
fis = addmf(fis, 'output', 2, 'MEDIUM', 'trimf', [0.1 0.5 0.9]);
fis = addmf(fis, 'output', 2, 'HIGH', 'trimf', [0.6 1 1]);


fis = addvar(fis, 'output', 'BLOCK', [0 1]);
fis = addmf(fis, 'output', 3, 'LOW', 'trimf', [0 0 0.4]);
fis = addmf(fis, 'output', 3, 'MEDIUM', 'trimf', [0.1 0.5 0.9]);
fis = addmf(fis, 'output', 3, 'HIGH', 'trimf', [0.6 1 1]);

fis = parsrule(fis, ['If CAPTURED_EVIL is HIGH or CLOSEST_GHOST_EVIL_CONFIDENCE is HIGH then CAPTURE_CLOSEST_GHOST is LOW                                     '; ...
                     'If CLOSEST_GHOST_DIST is ADJACENT and CLOSEST_GHOST_GOOD_CONFIDENCE is HIGH and CAPTURED_EVIL is LOW then CAPTURE_CLOSEST_GHOST is HIGH '; ...
                     'If CLOSEST_GHOST_DIST is NEAR and CLOSEST_GHOST_GOOD_CONFIDENCE is NOT LOW and CAPTURED_EVIL is LOW then CAPTURE_CLOSEST_GHOST is MEDIUM'; ...
                     'If CLOSEST_GHOST_DIST is ADJACENT and LOST_EVIL is HIGH then TEMPT is HIGH                                                              '; ...
                     'If LOST_EVIL is HIGH then TEMPT is MEDIUM                                                                                               '; ...
                     'If CLOSEST_GHOST_DIST is FAR and LOST_EVIL is LOW then TEMPT is MEDIUM                                                                  '; ...
                     'If OPPONENT_DIST_TO_HOME_EXIT is NEAR and DIST_TO_HOME_EXIT is NEAR then BLOCK is HIGH                                                  '; ...
                     'If OPPONENT_DIST_TO_HOME_EXIT is NEAR and DIST_TO_HOME_EXIT is NEAR and OTHERS_DIST_TO_HOME_EXIT is LOW then BLOCK is HIGH              '; ...
                     'If OPPONENT_DIST_TO_HOME_EXIT is NEAR and DIST_TO_HOME_EXIT is NEAR and OTHERS_DIST_TO_HOME_EXIT is HIGH then BLOCK is LOW              '; ...
                     'If OPPONENT_DIST_TO_HOME_EXIT is NEAR and DIST_TO_HOME_EXIT is NEAR and OTHERS_DIST_TO_HOME_EXIT is MEDIUM then BLOCK is LOW            '; ...
                     'If OPPONENT_DIST_TO_HOME_EXIT is FAR then BLOCK is LOW                                                                                  ']);
%                  'If CAPTURED_GOOD is LOW and CAPTURED_EVIL is LOW then CAPTURE_CLOSEST_GHOST is HIGH                                                     '; ...
%                      'If OPPONENT_DIST_TO_HOME_EXIT is NEAR and DIST_TO_HOME_EXIT is FAR then BLOCK is MEDIUM                                                 '; ...

% Loop through all good ghosts
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

    % Construct feature vector
    features = [gameState.features.CapturedGood, ...
                gameState.features.CapturedEvil, ...
                gameState.features.LostGood, ...
                gameState.features.LostEvil, ...
                thisGhost.features.ClosestGhostDist, ...
                thisGhost.features.ClosestGhostGoodConf, ...
                thisGhost.features.ClosestGhostEvilConf, ...
                thisGhost.features.DistToOpponentExit, ...
                thisGhost.features.ExitCongestion, ...
                thisGhost.features.OpponentDistToHomeExit, ...
                thisGhost.features.DistToHomeExit, ...
                otherGhostCloserToHomeExit];

            
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