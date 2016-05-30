function  valEx =  anyExit(gameState)
    valEx = [];
   for i = 1:length(gameState.ghosts.good)
    ghost = gameState.ghosts.good(i);
    row = 6 - ghost.row;
    col = ghost.col + 1;
    
    if ((row==1) && (col==1)) 
        valEx = [i, 3]; % if left exit, move it to the left
        continue;
    end
    if ((row==1) && (col==6))
          valEx = [i, 4]; % if right exit, move it to the right
        continue;
    end
   end