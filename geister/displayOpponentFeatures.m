%--------------------------------------------------------------------------
% displayOpponentFeatures.m
% Displays the computed features for the opponent ghosts.
%--------------------------------------------------------------------------

function displayOpponentFeatures(gameState)

space1 = '\t\t';
space2 = '\t\t\t\t';

str = 'Nature:                  ';
for i = 1:8
    if i > 1
        str = [str space2];
    end
    str = [str num2str(gameState.features.opponent(i).nature)];
end
fprintf([str '\n']);
str = 'Start Position:          ';
for i = 1:8
    if i > 1
        str = [str space1];
    end
    str = [str num2str(gameState.features.opponent(i).startPosition(1,:))];
end
fprintf([str '\n']);
str = '                         ';
for i = 1:8
    if i > 1
        str = [str space1];
    end
    str = [str num2str(gameState.features.opponent(i).startPosition(2,:))];
end
fprintf([str '\n']);
str = 'First Moved:             ';
for i = 1:8
    if i > 1
        str = [str space2];
    end
    str = [str num2str(gameState.features.opponent(i).firstMoved)];
end
fprintf([str '\n']);
str = 'Second Moved:            ';
for i = 1:8
    if i > 1
        str = [str space2];
    end
    str = [str num2str(gameState.features.opponent(i).secondMoved)];
end
fprintf([str '\n']);
str = 'Backward Moves:          ';
for i = 1:8
    if i > 1
        str = [str space2];
    end
    str = [str num2str(gameState.features.opponent(i).backwardMoves)];
end
fprintf([str '\n']);
str = 'Forward Moves:           ';
for i = 1:8
    if i > 1
        str = [str space2];
    end
    str = [str num2str(gameState.features.opponent(i).forwardMoves)];
end
fprintf([str '\n']);
str = 'Lateral Moves:           ';
for i = 1:8
    if i > 1
        str = [str space2];
    end
    str = [str num2str(gameState.features.opponent(i).lateralMoves)];
end
fprintf([str '\n']);
str = 'Capture When Threatened: ';
for i = 1:8
    if i > 1
        str = [str space2];
    end
    str = [str num2str(gameState.features.opponent(i).captureWhenThreatened)];
end
fprintf([str '\n']);
str = 'Escape When Threatened:  ';
for i = 1:8
    if i > 1
        str = [str space2];
    end
    str = [str num2str(gameState.features.opponent(i).escapeWhenThreatened)];
end
fprintf([str '\n']);
str = 'Remain When Threatened:  ';
for i = 1:8
    if i > 1
        str = [str space2];
    end
    str = [str num2str(gameState.features.opponent(i).remainWhenThreatened)];
end
fprintf([str '\n']);
str = 'Threat When Threatened:  ';
for i = 1:8
    if i > 1
        str = [str space2];
    end
    str = [str num2str(gameState.features.opponent(i).threatWhenThreatened)];
end
fprintf([str '\n']);