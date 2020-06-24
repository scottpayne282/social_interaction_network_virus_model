function [P] = social_interaction_model_base_friendsonly(G,Comms,meta_data)


%% the inputs
% in this code G is the nxn adjacency data of the unweighted network
% Comms is a 1xsz cell variable were Comms{i} is the numeric labels of the
% ith community as a row array
% meta_data is a 3826x7 numeric array. It contains annonimized iinformation
% about the social network members, for example column 5 is a numeric that
% indicates their housing location, column 6 indicates their class year
%% Establish interaction model parameterization
% Interaction probabilities are based on the network G and communities Comms
% as well as on assumptions about social behaviors related to class year,
% housing etc...
%--------------------------------------------------------------------------
% enter the base parameters for friendships and group structures
% in-group interaction probability IF they are friends, default 2/7
ingp = 2/7;
%-----------------------------------
% we'll create a scale that adjusts the parameter ingp to suit the group
% size with smaller groups assumed to be closer friends who interact more
% frequently....size 2 maps to an ingp value of 6/7, the max value of the
% variable s_f_s (that stands for scale for sizes) maps to whatever ingp already is
s_f_s = 2:10;
map0 = (6/7)*(1/ingp);
incrmnt = (1-map0)/(length(s_f_s)-1);
s_f_s_map = map0:incrmnt:1;
% we'll put the values we're considering (s_f_s) on top os the map to make
% it easier to look up when we implement it
s_f_s_map = [s_f_s ; s_f_s_map];
%------------------------------------
% between-group interaction probability IF they are friends, default 1/42
btgp = 1/42;
% now we'll tweek those assuming freshmen are most social, then
% sophmores..etc....we'll do it via a "bump value" we can add on later
pfresh = 2.5;
psoph = 1.5;
pjun = 1;
psen = 1;
pyear = [pfresh,psoph,pjun,psen];
%--------------------------------------------------------------------------
% now we'll enter some parameters for random interactions at housing,
% within class year, and then just in general...we can estimate them based
% on the set sizes....we will assign them to non edges (individuals who are
% not friends)
n = size(G,1);
sz = size(Comms,2);
% let's say that you are randomly near enough to spread to 2 people a day,
% then 
prnd = 0; %<-- set to zero for "friendsonly" model
% for housing we'll base it on the assumption that an individual has
% contact close enough to cause risk with a certain number of people in
% their housing during the course of each day, default 1
phsng = 0; %<-- set to zero for "friendsonly" model
% for class year this may seem a bit random but we'll just say that in a
% semester an individual comes in contact with at least 1/100 of their class 
% who they are not even facebook friends with,  and we'll estimate a per diem
% contact from that based on 7*13 days and their classyear size....this
% could be done differently...so other versions of parameterizing this
% should be explored.
pclssyr = 0; %<-- set to zero for "friendsonly" model

%% Establish the interaction probability matrix P based on above parameterization
% OK, now we'll calculate an nxn matrix P (we can just think of it as a
% weighted graph ) where the ij entry is the baseline probability that
% individual i and j come in contact on a given day. P will be one input to
% the simulation, party_days will be the input that controls increased or
% decreased socialization based on day of the week.
P = zeros(n,n);
% First we'll implement one of the most technical parts of this model: We
% will assign in-group friend contact probabilities based on the parameter
% ingp, but we will scale them based on group size undr the assumption that
% smaller groups are more specific close friend groups and see eachother
% more frequently.
% We'll use a nxn logical matrix L because it's my favorite lazy way to
% pick stuff out of a matrix
sizelist=cellfun('length',Comms);
L = false(n,n);
LG = logical(G);
for ii = 1:sz
    % calculate the factor fact_ii that we will adhust ingp by
    sizec = sizelist(ii);
    indx = s_f_s_map(1,:) ==sizec;
    fact_ii = s_f_s_map(2,indx);
    if ~isempty(fact_ii)
        L(Comms{ii},Comms{ii}) = true;
        P(L&LG) = ingp*fact_ii;
        L(Comms{ii},Comms{ii}) = false;
    else
        L(Comms{ii},Comms{ii}) = true;
        P(L&LG) = ingp;
        L(Comms{ii},Comms{ii}) = false;
    end
end
%
% Now we'll do thebetween-group parameters
% Here's a logical matrix for the in-group connections 
L = false(n,n);
for ii = 1:sz
    L(Comms{ii},Comms{ii}) = true;
end
% now we'll need to use the edges between groups defined by G
G2 = G;
% delete the in-group edges
G2(L) = 0;
% convert to logical 
G2 = logical(G2);
P(G2) = btgp;
% save memory and get rid of G2
clear G2
% Now we'll do some adjustment by class year
% look up the classes using a logical indicator built from the metadata
% variable meta_data
Lclass = [(meta_data(:,6)==2009)';(meta_data(:,6)==2008)';(meta_data(:,6)==2007)';(meta_data(:,6)==2006)';];
% this one accounts for the connections in the network G
L = logical(G);
L2 = false(n,n);
for ii = 1:4
    L2(Lclass(ii,:),Lclass(ii,:)) = true;
    P(L&L2) = P(L&L2) * pyear(ii);
    L2(Lclass(ii,:),Lclass(ii,:)) = false;
end
%--------------------------------------------------------------------------
% Now we need to work on the parameters relating to interactions between
% students who are not facebook friends
% THIS SECTION OMITTED IN THE friendsonly MODEL
%--------------------------------------------------------------------------
% Now we need to make sure we get rid of the values on the diagonal just so
% that it won't potentially interfere with varioous way that we might
% choose to code a simulation using this model P
P(1:n+1:n*n) = 0;
% and just in case anything ended up with a value >1 or <1

P(P>1) = 1;
P(P<0) = 0;
%
%% Finally, we'll account for commonality of friendships as a social similarity
% build in neighborhood similarity, this is just one way to do it
S1=pdist(G,'cosine');
S1=squareform(S1);
S1=1-S1;
P(LG) = P(LG).*S1(LG);








