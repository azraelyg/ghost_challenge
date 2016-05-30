function op = rouletteWheel(bestMoves)

ranked = true;

if ranked
    
    moves = sortrows(bestMoves, -3);
    
    r = rand();
    s = 0;
    p = 0.8;
    
    i = 0;
    while s < r && i < size(bestMoves,1)
        
        s = s + p;
        i = i + 1;
        p = p / 2;
        
    end
    
    op = moves(i,1:2);
    
else

    % first scales the confidences for the 8 possible moves and then
    conf = bestMoves(:,3);
    sumConf = sum(conf);
    conf = conf/sumConf;

    cumConf = cumsum(conf);

    rw=[];
    for i=1:length(cumConf)
        rw = [rw;repmat(i,round(conf(i)*100),1)];
    end

    k=floor(100*rand)+1;

    try
        selected = rw(k);
        op = bestMoves(selected(1),1:2);
    catch % just select randomly if that doesnt work, possible due to rounding issues
        [no,~]=size(bestMoves);
        k = floor(no*rand)+1;
        op = bestMoves(k(1),1:2);
    end
    
end