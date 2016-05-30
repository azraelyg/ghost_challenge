function [ C1,C2] = Crossover( P1,P2,p )
P1.good=sortrows(P1.good,20);
P2.good=sortrows(P2.good,20);
P1.evil=sortrows(P1.evil,20);
P2.evil=sortrows(P2.evil,20);
C1=P1;
C2=P2;

Lg=size(P1.good,1);
Le=size(P1.evil,1);
Lb=size(P1.both,1);
L=Lg+Le+Lb;
TempC1=[C1.good;C1.evil;C1.both];
TempC2=[C2.good;C2.evil;C2.both];

for i=1:L
     j=1;
    while j<=3 
        if p>=random('unif',0,1)
            Temp=TempC1(i,3+6*(j-1):7+6*(j-1));
            TempC1(i,3+6*(j-1):7+6*(j-1))=TempC2(i,3+6*(j-1):7+6*(j-1));
            TempC2(i,3+6*(j-1):7+6*(j-1))=Temp;
        end  
        j=j+1;
        if j==4 && (~any(TempC1(i,[3 9 15])) ||~any(TempC2(i,[3 9 15])))
            j=1;
        end
    end
end
C1.good=TempC1(1:Lg,:);
C2.good=TempC2(1:Lg,:);
C1.evil=TempC1(Lg+1:Lg+Le,:);
C2.evil=TempC2(Lg+1:Lg+Le,:);
C1.both=TempC1(1+Lg+Le:L,:);
C2.both=TempC2(1+Lg+Le:L,:);

end

