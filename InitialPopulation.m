function [chromosome]= InitialPopulation(good_num,evil_num,both_num)

load NN.mat;
all_num=good_num+evil_num+both_num;
i=1;
%% good
temp=zeros(all_num,24);
 while i<=all_num
    temp(i,1)=random('unif',0,1); %weight
    for j=1:3 % feature&points
        feature=randi([1 20]);  %feature
        if (feature>12)
            feature=0;
        end
        temp(i,3+6*(j-1))=feature;
        switch feature
            case 0  % no feature
                range_max=0;
            case {1,2,3,4}  %range 0-3
                range_max=3;                      
            case {6,7,5,11} %range 0-10 good and evil confidences also use 0-10 first
                range_max=10;
            case {8,10,12} %range 0-8
                range_max=8;
            case {9}    %range 0-4
                range_max=4; 
        end
         point=create_points(range_max); %create points               
         temp(i,4+6*(j-1))=point(1);
         temp(i,5+6*(j-1))=point(2);
         temp(i,6+6*(j-1))=point(3);
         temp(i,7+6*(j-1))=point(4); 
    end
    temp(i,[8 14])=randi([0 1]); %conjunction
    
    point=create_points(10); %goal point
    temp(i,21)=point(1);
    temp(i,22)=point(2);
    temp(i,23)=point(3);
    temp(i,24)=point(4);
    if (any(temp(i,[3 9 15])))
        i=i+1;     
    end
end
g=temp(1:good_num,:);
e=temp(good_num+1:good_num+evil_num,:);
b=temp(good_num+evil_num+1:all_num,:);

for i=1:good_num
    g(i,2)=0;
    g(i,20)=randsrc(1,1,[1 2 3]);   %goal   
end
for i=1:evil_num
    e(i,2)=1;
    e(i,20)=randsrc(1,1,[1 5]);   %goal
end
for i=1:both_num
    b(i,2)=2;
    b(i,20)=4;   %goal
end

chromosome.good = g;
chromosome.evil = e;
chromosome.both = b;
chromosome.NN = NN; % need to load mat..

end

function [point]=create_points(range)
count_same=3;
while count_same>2 %judge same number in points
    if (randi([0 1])==0)  %random trammf or trimmf 0-tri 1-tra
        point=sort(randsrc(3,1,0:range)); %create points of feature  
        point(4)=0;
        count_same=max(hist(point,unique(point(1:3)))); %judge same number in points
    else
        point=sort(randsrc(4,1,0:range));
        count_same=max(hist(point,unique(point))); %judge same number in points
    end
    
end
if (range~=0) 
    point=point./range; 
end
end