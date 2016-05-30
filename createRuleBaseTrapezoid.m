function [fis1,fis2] = createRuleBaseTrapezoid(chromosome)

% create good and evil fis from the rules in the chromosome
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

% first good
name = 'good_strategy';
name2 = 'evil_strategy';
type = 'mamdani';
andMethod = 'min';
orMethod = 'max';
impMethod = 'min';
aggMethod = 'sum';
defuzzMethod = 'mom';

fis1 = newfis(name, type, andMethod, orMethod, impMethod, aggMethod, defuzzMethod);
fis1 = addvar(fis1, 'input', 'CAPTURED_GOOD', [0 1]);%0 3
fis1 = addvar(fis1, 'input', 'CAPTURED_EVIL', [0 1]);%0 3
fis1 = addvar(fis1, 'input', 'LOST_GOOD', [0 1]);%0 3
fis1 = addvar(fis1, 'input', 'LOST_EVIL', [0 1]);%0 3
fis1 = addvar(fis1, 'input', 'CLOSEST_GHOST_DIST', [0 1]);%0 10
fis1 = addvar(fis1, 'input', 'CLOSEST_GHOST_GOOD_CONFIDENCE', [0 1]);
fis1 = addvar(fis1, 'input', 'CLOSEST_GHOST_EVIL_CONFIDENCE', [0 1]);
fis1 = addvar(fis1, 'input', 'DIST_TO_OPPONENT_EXIT', [0 1]);%0 8
fis1 = addvar(fis1, 'input', 'EXIT_CONGESTION', [0 1]);%0 4
fis1 = addvar(fis1, 'input', 'OPPONENT_DIST_TO_HOME_EXIT', [0 1]);%0 8
fis1 = addvar(fis1, 'input', 'DIST_TO_HOME_EXIT', [0 1]);%0 10
fis1 = addvar(fis1, 'input', 'OTHERS_DIST_TO_HOME_EXIT', [0 1]);%0 8

fis1 = addvar(fis1, 'output', 'CAPTURE_CLOSEST_GHOST', [0 1]);
fis1 = addvar(fis1, 'output', 'EXIT', [0 1]);
fis1 = addvar(fis1, 'output', 'ESCAPE', [0 1]);
fis1 = addvar(fis1, 'output', 'BLOCK', [0 1]);
fis1 = addvar(fis1, 'output', 'TEMPT', [0 1]);

%evil
fis2 = newfis(name2, type, andMethod, orMethod, impMethod, aggMethod, defuzzMethod);
fis2 = addvar(fis2, 'input', 'CAPTURED_GOOD', [0 1]);%0 3
fis2 = addvar(fis2, 'input', 'CAPTURED_EVIL', [0 1]);%0 3
fis2 = addvar(fis2, 'input', 'LOST_GOOD', [0 1]);%0 3
fis2 = addvar(fis2, 'input', 'LOST_EVIL', [0 1]);%0 3
fis2 = addvar(fis2, 'input', 'CLOSEST_GHOST_DIST', [0 1]);%0 10
fis2 = addvar(fis2, 'input', 'CLOSEST_GHOST_GOOD_CONFIDENCE', [0 1]);
fis2 = addvar(fis2, 'input', 'CLOSEST_GHOST_EVIL_CONFIDENCE', [0 1]);
fis2 = addvar(fis2, 'input', 'DIST_TO_OPPONENT_EXIT', [0 1]);%0 8
fis2 = addvar(fis2, 'input', 'EXIT_CONGESTION', [0 1]);%0 8
fis2 = addvar(fis2, 'input', 'OPPONENT_DIST_TO_HOME_EXIT', [0 1]);%0 8
fis2 = addvar(fis2, 'input', 'DIST_TO_HOME_EXIT', [0 1]);%0 10
fis2 = addvar(fis2, 'input', 'OTHERS_DIST_TO_HOME_EXIT', [0 1]);%0 8

fis2 = addvar(fis2, 'output', 'CAPTURE_CLOSEST_GHOST', [0 1]);
fis2 = addvar(fis2, 'output', 'EXIT', [0 1]);
fis2 = addvar(fis2, 'output', 'ESCAPE', [0 1]);
fis2 = addvar(fis2, 'output', 'BLOCK', [0 1]);
fis2 = addvar(fis2, 'output', 'TEMPT', [0 1]);

[len,~]=size(chromosome.good);
inputCnt = ones(12,1); % to keep count of number of mfs for the input
outputCnt = ones(5,1); % to keep count of number of mfs for the output
% mfNames = ['MF01';'MF02';'MF03';'MF04';'MF05';'MF06';'MF07';'MF08';'MF09';'MF10';'MF11';'MF12'];
% rule=[];

%good
for i=1:len
    ruleI = zeros(1,12);
    ruleO = zeros(1,5);
    currentRule = chromosome.good(i,:);
    feature = currentRule(3);
    if feature~=0
        mf = currentRule(4:7);
        if mf(4) ==0 
            fis1 = addmf(fis1, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trimf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        else
            fis1 = addmf(fis1, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trapmf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        end
    end
    conjunction = currentRule(8);
    feature = currentRule(9);
    if feature~=0
        mf = currentRule(10:13);
        if mf(4) ==0 
            fis1 = addmf(fis1, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trimf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        else
            fis1 = addmf(fis1, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trapmf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        end
    end
    feature = currentRule(15);
    if feature~=0
        mf = currentRule(16:19);
        if mf(4) ==0 
            fis1 = addmf(fis1, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trimf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        else
            fis1 = addmf(fis1, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trapmf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        end
    end
    feature = currentRule(20);
    if feature~=0
        mf = currentRule(21:24);
        if mf(4) ==0
            fis1 = addmf(fis1, 'output', feature,['MF' num2str(outputCnt(feature))] , 'trimf', mf);
            ruleO(feature) = outputCnt(feature);
            outputCnt(feature) =  outputCnt(feature) + 1; % incrementing
        else
            fis1 = addmf(fis1, 'output', feature,['MF' num2str(outputCnt(feature))] , 'trapmf', mf);
            ruleO(feature) = outputCnt(feature);
            outputCnt(feature) =  outputCnt(feature) + 1; % incrementing
        end
    end
%     r1 = num2str(ruleI); r2 = num2str(ruleO);
    wt = currentRule(1);
%     r = strcat(r1,',',' ',r2 ,sprintf('(%.2f):',wt));
%     rule{i} = strcat(r,num2str(conjunction+1));
    fis1 = addrule(fis1, [ruleI, ruleO, wt, conjunction+1]);
end 

[len2,~]=size(chromosome.both); % adding the common rules to both the rule bases
for i=1:len2
    ruleI = zeros(1,12);
    ruleO = zeros(1,5);
    
    currentRule = chromosome.both(i,:);
    feature = currentRule(3);
    if feature~=0
        mf = currentRule(4:7);
        if mf(4) ==0 
            fis1 = addmf(fis1, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trimf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        else
            fis1 = addmf(fis1, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trapmf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        end
    end
    conjunction = currentRule(8);
    feature = currentRule(9);
    if feature~=0
        mf = currentRule(10:13);
        if mf(4) ==0 
            fis1 = addmf(fis1, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trimf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        else
            fis1 = addmf(fis1, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trapmf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        end
    end
    feature = currentRule(15);
    if feature~=0
        mf = currentRule(16:19);
        if mf(4) ==0 
            fis1 = addmf(fis1, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trimf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        else
            fis1 = addmf(fis1, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trapmf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        end
    end
    feature = currentRule(20);
    if feature~=0
        mf = currentRule(21:24);
        if mf(4) ==0
            fis1 = addmf(fis1, 'output', feature,['MF' num2str(outputCnt(feature))] , 'trimf', mf);
            ruleO(feature) = outputCnt(feature);
            outputCnt(feature) =  outputCnt(feature) + 1; % incrementing
        else
            fis1 = addmf(fis1, 'output', feature,['MF' num2str(outputCnt(feature))] , 'trapmf', mf);
            ruleO(feature) = outputCnt(feature);
            outputCnt(feature) =  outputCnt(feature) + 1; % incrementing
        end
    end
%     r1 = num2str(ruleI); r2 = num2str(ruleO);
    wt = currentRule(1);
%     r = strcat(r1,',',' ',r2 ,sprintf('(%.2f):',wt));
%     rule{i+len} = strcat(r,num2str(conjunction+1));
    fis1 = addrule(fis1, [ruleI, ruleO, wt, conjunction+1]);
end    
% totalRule=[];
% for i=1:len+len2
%     totalRule = [totalRule;rule{i}];
% end
% fis1 = parsrule(fis1,totalRule,'indexed');


% evil
[len,~]=size(chromosome.evil);
inputCnt = ones(12,1); % to keep count of number of mfs for the input
outputCnt = ones(5,1); % to keep count of number of mfs for the output
% mfNames = ['MF01';'MF02';'MF03';'MF04';'MF05';'MF06';'MF07';'MF08';'MF09';'MF10';'MF11';'MF12'];
% rule=[];

for i=1:len
    ruleI = zeros(1,12);
    ruleO = zeros(1,5);
    
    currentRule = chromosome.evil(i,:);
    feature = currentRule(3);
    if feature~=0
        mf = currentRule(4:7);
        if mf(4) ==0 
            fis2 = addmf(fis2, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trimf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        else
            fis2 = addmf(fis2, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trapmf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        end
    end
    conjunction = currentRule(8);
    feature = currentRule(9);
    if feature~=0
        mf = currentRule(10:13);
        if mf(4) ==0 
            fis2 = addmf(fis2, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trimf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        else
            fis2 = addmf(fis2, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trapmf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        end
    end
    feature = currentRule(15);
    if feature~=0
        mf = currentRule(16:19);
        if mf(4) ==0 
            fis2 = addmf(fis2, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trimf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        else
            fis2 = addmf(fis2, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trapmf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        end
    end
    feature = currentRule(20);
    if feature~=0
        mf = currentRule(21:24);
        if mf(4) ==0
            fis2 = addmf(fis2, 'output', feature,['MF' num2str(outputCnt(feature))] , 'trimf', mf);
            ruleO(feature) = outputCnt(feature);
            outputCnt(feature) =  outputCnt(feature) + 1; % incrementing
        else
            fis2 = addmf(fis2, 'output', feature,['MF' num2str(outputCnt(feature))] , 'trapmf', mf);
            ruleO(feature) = outputCnt(feature);
            outputCnt(feature) =  outputCnt(feature) + 1; % incrementing
        end
    end
%     r1 = num2str(ruleI); r2 = num2str(ruleO);
    wt = currentRule(1);
%     r = strcat(r1,',',' ',r2 ,sprintf('(%.2f):',wt));
%     rule{i} = strcat(r,num2str(conjunction+1));
    fis2 = addrule(fis2, [ruleI, ruleO, wt, conjunction+1]);
end    

[len2,~]=size(chromosome.both); % adding the common rules to both the rule bases
for i=1:len2
    ruleI = zeros(1,12);
    ruleO = zeros(1,5);
    
    currentRule = chromosome.both(i,:);
    feature = currentRule(3);
    if feature~=0
        mf = currentRule(4:7);
        if mf(4) ==0 
            fis2 = addmf(fis2, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trimf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        else
            fis2 = addmf(fis2, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trapmf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        end
    end
    conjunction = currentRule(8);
    feature = currentRule(9);
    if feature~=0
        mf = currentRule(10:13);
        if mf(4) ==0 
            fis2 = addmf(fis2, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trimf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        else
            fis2 = addmf(fis2, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trapmf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        end
    end
    feature = currentRule(15);
    if feature~=0
        mf = currentRule(16:19);
        if mf(4) ==0 
            fis2 = addmf(fis2, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trimf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        else
            fis2 = addmf(fis2, 'input', feature,['MF' num2str(inputCnt(feature))] , 'trapmf', mf);
            ruleI(feature) = inputCnt(feature);
            inputCnt(feature) =  inputCnt(feature) + 1; % incrementing
        end
    end
    feature = currentRule(20);
    if feature~=0
        mf = currentRule(21:24);
        if mf(4) ==0
            fis2 = addmf(fis2, 'output', feature,['MF' num2str(outputCnt(feature))] , 'trimf', mf);
            ruleO(feature) = outputCnt(feature);
            outputCnt(feature) =  outputCnt(feature) + 1; % incrementing
        else
            fis2 = addmf(fis2, 'output', feature,['MF' num2str(outputCnt(feature))] , 'trapmf', mf);
            ruleO(feature) = outputCnt(feature);
            outputCnt(feature) =  outputCnt(feature) + 1; % incrementing
        end
    end
%     r1 = num2str(ruleI); r2 = num2str(ruleO);
    wt = currentRule(1);
%     r = strcat(r1,',',' ',r2 ,sprintf('(%.2f):',wt));
%     rule{i+len} = strcat(r,num2str(conjunction+1));
    fis2 = addrule(fis2, [ruleI, ruleO, wt, conjunction+1]);
end    
% totalRule=[];
% for i=1:len+len2
%     totalRule = [totalRule;rule{i}];
% end
% fis2 = parsrule(fis2,totalRule,'indexed');



