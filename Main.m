clear all;

%using K-fold relative fitness assessment

%initial population
load NN.mat
num_p=20; %population number
good_num=10;
evil_num=6;
both_num=4;
k=5; %desired minimum number of tests per individual
n=2; %desired number of elite
t=2; % tournament size
p=0.4; %probability of crossover
for i=1:num_p
    population(i,1)=InitialPopulation(good_num,evil_num,both_num);
end

g=1; %generation
human_result=0;
while 1
    
    fitness=CompeteAssess(num_p,k,population);

    %%%%%%Tournament selection with elitism%%%%%%%%%%%
    fitness=sortrows(fitness,-8);
    Best_F=fitness(1,8); %Best_F--fitness,Best_I--Index
    Best_I=fitness(1,10);
    best=population(Best_I);

    New_population=population(fitness(1:n,10)); %best 2 individuals
    %%%%%selection & crossover & mutation%%%%%%%
    for i=1:(num_p-n)/2
        [P1I,P1F]=TournamentS(t,fitness,num_p,n,0);   
        [P2I,P2F]=TournamentS(t,fitness,num_p,n,P1I);
        Parent1=population(P1I);
        Parent2=population(P2I);
        game_result=fitness(fitness(:,10)==P1I,1:6)+fitness(fitness(:,10)==P2I,1:6);
        [C1,C2]=Crossover(Parent1,Parent2,p);
        C1=Mutation(C1,game_result);
        C2=Mutation(C2,game_result);
        New_population=[New_population;C1;C2];
    end
    population=New_population;
    g=g+1;   
    if mod(g,10)==0
        human_result=playGameAgainstChromosome(best,true);
    end
    if (g>20 || human_result>3)
        break;
    end
end