function [ fit_func ] = CompeteAssess(num_p,k,population)
%%%%%%%%%%%%compete & assess%%%%%%%%%%%%%%%%%%

r=1:num_p; %the number of individual haven't enough games
fit_func=zeros(num_p,10); %record game results
% 1 2 3 4 5 6 7 score game_included number
win=3;
lose=-2;
draw=1;
for i=1:num_p
    if (fit_func(i,9)~=k)
        r=setdiff(r,i);  %delete this individual
    end
    while fit_func(i,9)<k
        if length(r)<k
            temp_p=1:num_p;
            temp_p=setdiff(temp_p,r);
            temp_p(temp_p==i)=[];
            uni_p=randperm(num_p-length(r)-1); %k unique individuals in r
            uni_p=uni_p(1:k-length(r));
            q=[population(r)' population(temp_p(uni_p))']';
            q_num=[r temp_p(uni_p)];
        else
            uni_p=randperm(length(r)); %k unique individuals in r
            q=population(r(uni_p(1:k)));  
            q_num=r(uni_p(1:k));
        end
        for j=1:k-fit_func(i,9)
            fit_func(i,9)=fit_func(i,9)+1;
            fit_func(q_num(j),9)=fit_func(q_num(j),9)+1;
            out=playGameBetweenChromosomes(population(i),q(j));
            fit_func(i,out)=fit_func(i,out)+1;         
            switch out
                case {1,2,3}
                    fit_func(i,8)=fit_func(i,8)+win;
                    fit_func(q_num(j),8)=fit_func(q_num(j),8)+lose;
                    fit_func(q_num(j),out+3)=fit_func(q_num(j),out+3)+1;
                case {4,5,6}
                    fit_func(i,8)=fit_func(i,8)+lose;
                    fit_func(q_num(j),8)=fit_func(q_num(j),8)+win;
                    fit_func(q_num(j),out-3)=fit_func(q_num(j),out-3)+1;
                case 7
                    fit_func(i,8)=fit_func(i,8)+draw;
                    fit_func(q_num(j),8)=fit_func(q_num(j),8)+draw;
                    fit_func(q_num(j),out)=fit_func(q_num(j),out)+1;
            end
            if fit_func(q_num(j),9)==k
                r=setdiff(r,q_num(j)); 
            end                
        end
    end
    fit_func(i,10)=i;
end

end

