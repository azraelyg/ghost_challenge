function chromosome =  createPopulationTrapezoid()

%% first just making the population from the existing rules
% Weight: double [0,1] % weight assigned to the rule; the higher the weight, the stronger the rule
% Feature 0: Nature (0-2) 0: good
% Feature 1 : integer [0, 12] : 0 represents no feature (we could change this to [1-20] or something and say that anything over 12 is no feature so it would have a greater probability)
% Parameter 11 : double [0, 1]
% Parameter 12 : double [0, 1]
% Parameter 13 : double [0, 1]
% Parameter 14 : double [0, 1]
% Conjunction : integer [0, 1] : 0 is and; 1 is or
% Feature 2 : integer [0, 12] : Same as above
% Parameter 21 : double [0, 1]
% Parameter 22 : double [0, 1]
% Parameter 23 : double [0, 1]
% Parameter 24 : double [0, 1]
% Conjunction : integer [0, 1] : 0 is and; 1 is or
% Feature 3 : integer [0, 12] : Same as above
% Parameter 31 : double [0, 1]
% Parameter 32 : double [0, 1]
% Parameter 33 : double [0, 1]
% Parameter 34 : double [0, 1]
% Goal 1 : integer [1, 5] : Every rule has a goal (no bogus rule)
% Parameter 41 : double [0, 1]
% Parameter 42 : double [0, 1]
% Parameter 43 : double [0, 1]
% Parameter 44 : double [0, 1]


%% Feature  Input:
% 0: none,
% 1: CAPTURED_GOOD,
% 2: CAPTURED_EVIL
% 3: LOST_GOOD
% 4: LOST_EVIL
% 5: CLOSEST_GHOST_DIST
% 6: CLOSEST_GHOST_GOOD_CONFIDENCE
% 7: CLOSEST_GHOST_EVIL_CONFIDENCE
% 8: DIST_TO_OPPONENT_EXIT
% 9: EXIT_CONGESTION
% 10: OPPONENT_DIST_TO_HOME_EXIT
% 11: DIST_TO_HOME_EXIT
% 12: OTHERS_DIST_TO_HOME_EXIT
%% Feature Goal
% 1: CAPTURE_CLOSEST_GHOST
% 2: EXIT
% 3: ESCAPE
% 4: BLOCK
% 5: TEMPT

load NN.mat;
%% items need normalizing: CAPTURED_EVIL, CLOSEST_GHOST_DIST, ,CAPTURED_GOOD,LOST_EVIL,DIST_TO_OPPONENT_EXIT,LOST_GOOD,LOST_EVIL,OPPONENT_DIST_TO_HOME_EXIT,DIST_TO_HOME_EXIT
g1 = [1,0,2,0,1,1,0,1,7,0,1,1,0,0,0,0,0,0,0,1,0,0,0.4,0]; % no third feature
g2 = [1,0,5,0,0.1,.2,0,0,6,0,1,1,0,0,2,0,0,1,0,1,0.6,1,1,0];
g3 = [1,0,5,0,0,.2,.6,0,6,0,1,1,0,0,2,0,0,1,0,1,.1,.5,.9,0]; % if fourth element of each feature parameter==0, trimmf else trapmf
g4 = [1,0,8,0,.12,.25,0,0,0,0,0,0,0,0,0,0,0,0,0,2,.6,1,1,0];
g5 = [1,0,3,0,0,1,0,0,8,0,0,.25,.75,0,9,0,1,1,0,2,.6,1,1,0];
g6 = [1,0,2,0,1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,2,0.1,0.5,0.9,0];
g7 = [1,0,9,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0.4,0];
g8 = [1,0,5,0,.1,.2,0,0,3,0,1,1,0,0,0,0,0,0,0,3,0.6,1,1,0];
g9 = [1,0,5,0,0,.2,.6,0,0,0,0,0,0,0,0,0,0,0,0,3,0.1,0.5,0.9,0];
g10 = [1,0,5,.2,.6,.6,1,0,3,0,0,1,0,0,0,0,0,0,0,3,0,0,.4,0];

g=[g1;g2;g3;g4;g5;g6;g7;g8;g9;g10];

% evil rules
e1 =[1,1,2,0,1,1,0,1,7,0,1,1,0,0,0,0,0,0,0,1,0,0,.4,0];
e2 = [1,1,5,0,.1,.20,0,0,6,0,1,1,0,0,2,0,0,1,0,1,0.6,1,1,0];
e3 = [1,1,5,0,.2,.6,0,0,6,0,1,1,0,0,2,0,0,1,0,1,.6,1,1,0];
e4 = [1,1,5,0,.1,.2,0,0,4,0,1,1,0,0,0,0,0,0,0,5,.6,1,1,0];
e5 = [1,1,4,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,5,.1,.5,.9,0];
e6 = [1,1,5,.2,.6,.6,1,0,4,0,0,1,0,0,0,0,0,0,0,5,.1,.5,.9,0];

e=[e1;e2;e3;e4;e5;e6];

% both parties

b1 = [1,2,10,0,0,.25,.87,0,11,0,0,.2,.4,0,12,0,.12,.25,0,4,0.6,1,1,0];
b2 = [1,2,10,0,0,.25,.87,0,11,0,0,.2,.4,0,12,.12,.87,1,1,4,0,0,.4,0];
b3 = [1,2,10,0,0,.25,.87,0,11,0,0,.2,.4,0,12,0,0,.25,.87,4,0,0,.4,0];
b4 = [1,2,10,.12,.87,1,1,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,.4,0];

b=[b1;b2;b3;b4];

chromosome.good = g;
chromosome.evil = e;
chromosome.both = b;

chromosome.NN = NN; % need to load mat..
