function [ T_bestI,T_bestF ] = TournamentS(t,fitness,num_p,n,P1I)

    temp_p=setdiff(1:num_p,fitness(1:n,10));
    temp_p(temp_p==P1I)=[];
    T_bestI=temp_p(randi(length(temp_p)));
    T_bestF=fitness(fitness(:,10)==T_bestI,8);
    temp_p(temp_p==T_bestI)=[];
    for j=2:t
        T_nextI=temp_p(randi(length(temp_p)));
        T_nextF=fitness(fitness(:,10)==T_nextI,8);
        if T_nextF>T_bestF
            T_bestF=T_nextF;
            T_bestI=T_nextI;
        end
    end
end

