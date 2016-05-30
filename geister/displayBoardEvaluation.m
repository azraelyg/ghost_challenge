%--------------------------------------------------------------------------
% displayBoardEvaluation.m
% Displays the evaluation of the board in terms of goal utility values.
%--------------------------------------------------------------------------

function displayBoardEvaluation(gameState)

space1 = '\t';
space2 = '\t\t\t';

for i = 1:length(gameState.ghosts.good)
    ghost = gameState.ghosts.good(i);
    
    disp('Good.. ');
    disp(['Ghost (' num2str(ghost.col) ',' num2str(ghost.row) '):']);
    
    disp(['CLOSEST_GHOST_DIST: ' num2str(ghost.features.ClosestGhostDist)]);
    disp(['CLOSEST_GHOST_GOOD_CONFIDENCE: ' num2str(ghost.features.ClosestGhostGoodConf)]);
    disp(['CLOSEST_GHOST_EVIL_CONFIDENCE: ' num2str(ghost.features.ClosestGhostEvilConf)]);
    disp(['DIST_TO_OPPONENT_EXIT: ' num2str(ghost.features.DistToOpponentExit)]);
    disp(['EXIT_CONGESTION: ' num2str(ghost.features.ExitCongestion)]);
    disp(['OPPONENT_DIST_TO_HOME_EXIT: ' num2str(ghost.features.OpponentDistToHomeExit)]);
    disp(['DIST_TO_HOME_EXIT: ' num2str(ghost.features.DistToHomeExit)]);
    disp(['Opponent Closest to Exit: ' num2str(ghost.features.OpponentClosestToExitLR)]);
    
    str = 'Goals:   ';
    for j = 1:length(ghost.goals)
        if j > 1
            str = [str space1];
        end
        str = [str ghost.goals(j).name];
    end
    fprintf([str '\n']);
    
    str = '         ';
    for j = 1:length(ghost.goals)
        if j > 1
            str = [str space2];
        end
        str = [str '(' num2str(ghost.goals(j).col) ',' num2str(ghost.goals(j).row) ') = ' num2str(ghost.goals(j).value, '%.2f')];
    end
    fprintf([str '\n']);
end

for i = 1:length(gameState.ghosts.evil)
    ghost = gameState.ghosts.evil(i);
    
    disp('Evil.. ');
    disp(['Ghost (' num2str(ghost.col) ',' num2str(ghost.row) '):']);
    
    disp(['CLOSEST_GHOST_DIST: ' num2str(ghost.features.ClosestGhostDist)]);
    disp(['CLOSEST_GHOST_GOOD_CONFIDENCE: ' num2str(ghost.features.ClosestGhostGoodConf)]);
    disp(['CLOSEST_GHOST_EVIL_CONFIDENCE: ' num2str(ghost.features.ClosestGhostEvilConf)]);
    disp(['DIST_TO_OPPONENT_EXIT: ' num2str(ghost.features.DistToOpponentExit)]);
    disp(['EXIT_CONGESTION: ' num2str(ghost.features.ExitCongestion)]);
    disp(['OPPONENT_DIST_TO_HOME_EXIT: ' num2str(ghost.features.OpponentDistToHomeExit)]);
    disp(['DIST_TO_HOME_EXIT: ' num2str(ghost.features.DistToHomeExit)]);
    disp(['Opponent Closest to Exit: ' num2str(ghost.features.OpponentClosestToExitLR)]);
    
    str = 'Goals:   ';
    for j = 1:length(ghost.goals)
        if j > 1
            str = [str space1];
        end
        str = [str ghost.goals(j).name];
    end
    fprintf([str '\n']);
    
    str = '         ';
    for j = 1:length(ghost.goals)
        if j > 1
            str = [str space2];
        end
        str = [str '(' num2str(ghost.goals(j).col) ',' num2str(ghost.goals(j).row) ') = ' num2str(ghost.goals(j).value, '%.2f')];
    end
    fprintf([str '\n']);
end

for i = 1:length(gameState.ghosts.opponent)
    ghost = gameState.ghosts.opponent(i);
    
    disp('Oponent.. ');
    disp(['Ghost (' num2str(ghost.col) ',' num2str(ghost.row) '):']);
    
    disp(['Good Confidence: ' num2str(ghost.goodConf)]);
    disp(['Evil Confidence: ' num2str(ghost.evilConf)]);
end