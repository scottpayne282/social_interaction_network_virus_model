function [ADJ,adjustmentvector] = semi_randomize_daily_group_behavior(G,Comms,pct,numcnt,numstd,adjcnt,adjstd)

% this function chooses a random number of social groups (the number is draw from a Gaussian dist)
% and makes a percentage of the individuals in each group either more or
% less social (the percentage is also drawn from a Gaussian)...that
% adjustment happens per group, so for a given group that is picked the
% input pct controls the likely number of individuals and those individuals
% will all be more social or all be less social.....this function is meant
% to make group socialization contacts more "organic"...so that the
% social behavior is not too stricktly governed by day of the week.

ADJ = G;
sz = size(Comms,2);
%% establish a distribution from which to pick the number of groups
% sz is the number of groups
% defaults: numcnt=0.5  numstd=0.35
numgrps = ceil(normrnd(floor(numcnt*sz),ceil(numstd*sz/3)));
if numgrps<1
    numgrps = 1;
end
% choose the groups
grplist = randperm(sz,numgrps);
Groups = Comms(grplist);
% randomly assign them each a percentage 
% defaults: adjcnt=0.55   adjstd=0.45
adjustmentvector = normrnd(adjcnt,adjstd,1,length(grplist));
locs = adjustmentvector<=0;
adjustmentvector(locs) = 0.5;
%
for ii = 1:numgrps
    labels = Groups{ii};
    for jj = 1:length(labels)
        if binornd(1,pct)
            ADJ(labels(jj),:) = ADJ(labels(jj),:)*adjustmentvector(ii);
            ADJ(:,labels(jj)) = ADJ(:,labels(jj))*adjustmentvector(ii);
        end
    end
end