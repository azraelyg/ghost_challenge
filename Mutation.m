function [ C ] = Mutation( C,game_result)

[~,wI]=max(game_result(1:3));
[~,lI]=max(game_result(4:6));
 p_high=0.7;
 p_low=0.2;
 p_normal=0.5;
 g_high=0; %goal need to be improved
 g_low=0; %goal less need to be improved 
 % win game 1--capture is good,2--temp good 3--exit good 
 switch wI
     case 1
        g_low=1;    
     case 2
        g_low=5;
     case 3
        g_low=2;
 end
% lose game 4--escape bad,5--capture bad 6--block bad 
 switch lI
     case 1
        g_high=3;    
     case 2
        g_high=1;
     case 3
        g_high=4;
 end
 if g_high==g_low %if capture is both good and bad,nomal probability
 	p_high=0.5;
 	p_low=0.5;
 end
 if ~any(game_result(1:3))
     p_low=0.5;
 end
  if ~any(game_result(4:6))
     p_high=0.5;
 end
Lg=size(C.good,1);
Le=size(C.evil,1);
Lb=size(C.both,1);
L=Lg+Le+Lb;
TempC=[C.good;C.evil;C.both];
for i=1:L
    switch TempC(i,20)
        case g_high
            p_rule=p_high; %probability of change this rule
        case g_low
            p_rule=p_low;
        otherwise
            p_rule=p_normal;
    end
    if p_rule>=random('unif',0,1)
        %1-change weight 2,3,4-change points of feature 5-change conjunction0
        %6-change goal
        change_para=unique(randsrc(1,2,1:6));%each time change at most 2 param
        for j=1:length(change_para)
            switch change_para(j)
                case 1
                    TempC(i,:)=changeWeight(TempC(i,:));
                case {2,3,4}                       
                    switch TempC(i,3+6*(change_para(j)-2))
                        case {1,2,3,4}  %range 0-3
                             delt=0.3; 
                             range_max=3;
                        case {6,7,5,11} %range 0-10 good and evil confidences also use 0-10 first
                             delt=0.1;
                             range_max=10;
                        case {8,10,12} %range 0-8
                             delt=0.125;
                             range_max=8;
                        case {9}    %range 0-4
                             delt=0.25; 
                             range_max=4;
                        case 0
                            continue;
                    end
                    TempC(i,:)=changePoint(TempC(i,:),4+6*(change_para(j)-2),range_max,delt);
                case 5 %change conjunction
                    TempC(i,[8 14])=~TempC(i,[8 14]);
                case 6
                    TempC(i,:)=changeGoal(TempC(i,:));
            end
        end
    end
end
C.good=TempC(1:Lg,:);
C.evil=TempC(Lg+1:Lg+Le,:);
C.both=TempC(1+Lg+Le:L,:);

end

function c=changeWeight(c)
    c(1)=c(1)+normrnd(0,0.2);%0.2 gaussian distri
    if c(1)>1  
        c(1)=1;
    elseif c(1)<0
        c(1)=0;
    end
end
function c=changePoint(c,k,range_max,delt)
    tempc=c(k:k+3);
    if(randsrc(1,1,[0 1;0.8 0.2])==0) % just change points 
        count_same=3;
        while count_same>2
            if  tempc(4)==0 %tri
                tempc(1:3)=sort(round((tempc(1:3)+normrnd(0,delt)).*range_max)./range_max); %add gausin random, normal to range
                tempc(tempc>1)=1;
                tempc(tempc<0)=0;
                count_same=max(hist(tempc,unique(tempc(1:3))));
            else
                tempc=sort(round((tempc(1:4)+normrnd(0,delt)).*range_max)./range_max);
                tempc(tempc>1)=1;
                tempc(tempc<0)=0;
                count_same=max(hist(tempc,unique(tempc)));
            end
        end
    else %if 1 swap trimmf and trammf
        count_same=3;
        while count_same>2
        if tempc(4)==0 %tri
            deltp=normrnd(0,delt,1,2);
            point_m=round([tempc(2)-deltp(1) tempc(2)+deltp(2)].*range_max)./range_max;
            point_m(point_m>1)=1;
            point_m(point_m<0)=0;
            tempc=sort([tempc(1) point_m tempc(3)]);
            count_same=max(hist(tempc,unique(tempc)));
        else
            point_m=round(((tempc(2)+tempc(3))/2).*range_max)./range_max; %find midle point of 2 and 3
            point_m(point_m>1)=1;
            point_m(point_m<0)=0;
            tempc=[tempc(1) point_m tempc(4) 0];
            count_same=max(hist(tempc,unique(tempc(1:3))));
        end
        end
    end
    c(k:k+3)=tempc;
end
function c=changeGoal(c)
    if(randsrc(1,1,[0 1;0.8 0.2])==0) % just change points 
        c=changePoint(c,21,10,0.1);
    else %change goal
        switch c(2)
            case 0
                c(20)=randsrc(1,1,[1 2 3]);
            case 1
                c(20)=randsrc(1,1,[1 5]); 
        end
    end
end