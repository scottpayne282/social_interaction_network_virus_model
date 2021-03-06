
% This script is a basic demo of how to use the modeling tools to simulate 
% virus spread through the college community via social interaction among
% close friends and others via social patterns typical of college life
%
% THIS SCRIPT CREATES a Matlab structure variable "day" where day(i) is
% the status of the discrete time simulation on day i 
% day(i).contacts is the Matlab graph object representing in-person
% contacts on day i and  day(i).status is the 3826x1 numeric array
% representing the status of each individual. 
% status codes:
% 0 -- susceptible
% 1 -- infected
% 2 -- contagious
% 3 -- severely ill
% 4 -- recovered
%
% After running this script the only variable you need to save is the
% structure variable "day" described above...all information about the
% simulation outcome is stored there.
%% load the social network data
% define your filepath, for example:
% filepath = 'C:\Users\scott\Documents\college_social_network_model\college_social_network_data.mat';
filepath = 'C:\Users\scott\Documents\MATLAB\social_interaction_network_virus_model\social_network_data\college_social_network_data.mat';
load(filepath)
%-------------------------------------------------------------------------- 
% ABOUT THE VARIABLES/DATA:
% G is saved as a 3826x3826 sparse array containing the unweighted network 
% data of the college social network, we'll need to convert it to full 
% array type to run it in the functions used here
% so G(i,j) is 1 if individuals i and j are friends and 0 if not
%
% Comms is a 1x659 cell array such that Comms{i} is the ith friend group
% listed as a row array of their numeric labels
%
% meta_data is a 3826x7 numeric array encoding some annonimized information
% about the individuals in this network, for example column 5 is a numeric that
% indicates their housing location, column 6 indicates their class year
%-------------------------------------------------------------------------- 
% GENERAL INFO ABOUT THIS DATA:
% The data is anonymized in the sense that no information is available
% about who these individuals are, to us they are each just a number. It is
% real world data and we do know who was friends with who....that's the
% social network (the variable G). We know the network was formed during a
% time when these friendships were established through the college so they
% did interact in person with some probability ESPECIALLY when it comes 
% to their close friends in their friend group. All the meta data is
% fully annonimized except for class year...so for each individual we do
% know their year.
% The friend groups (the variable Comms) were data-mined using a new
% network science method. It is a mathematical approach similar to but not
% the same as "community detection"...portions of the mathematical details
% are now under consideration for publication in a peer reviewed academic
% journal. Other portions are in preparation for release in the cs section
% of Cornell University arXiv.org
%--------------------------------------------------------------------------
%% Now we'll run an example in which we simulate socialization ONLY between friends 
% We start with this restricted case because it comes out easy to see how 
% things work in the visualization tools
G = full(G);
% make a logical representing the facebook friendships
LG = logical(G);
% NOTE: I find LG useful for getting certain indexing done but it
% is not always the fastest or most memory efficient way to do
% everything....in general the codes in this package were developed very
% quickly, so cheap and easy was the way to go...feel free to improve upon
% it.
%--------------------------------------------------------------------------
% Create the baseline probabilities of interaction for each ij pair
[P] = social_interaction_model_base_friendsonly(G,Comms,meta_data);
%[P] = social_interaction_model_base(G,Comms,meta_data);
% P is a 3826x3826 array where the ij entry is the baseline probability
% that ij will interact. The probabilities are computed in a complex way
% that accounts for different social dynamics based on classyear, close
% friend group, group size, housing, and similarity of the friendship patterns 
% between the two individuals. The parameters are set inside the function 
% and are each described in detail so read the notes in the function in 
% order to understand and learn how to tweek them....my choice of default 
% values produce a model that behaves fairly realistically, but this is a 
% ROUGH DRAFT. The goal is for further work to tune the model using 
% additional academic resources.
%--------------------------------------------------------------------------
% Create the parameters to adjust socialization to suit the day of the week
social_days = [0.6 1 0.6 1.6 2.5 1.8 1];
% So, social_days(1) is 60%, meaning that on Mondays (day 1 in my code)
% students are at 60% of their baseline sociality whereas on Friday they
% are at 250% of their baseline....the way I established these was just by
% tinkering with all the parameters of the model until it was generating
% daily social contacts that were within our estimated ranges for the type 
% of socialization expected among college students per weekday....so the
% values chosen here specifically are interdependent with the fixed
% parameter values inside the function "social_interaction_model_base_friendsonly"
% seen above.
%--------------------------------------------------------------------------
% establish the initialized inputs for the virus model
n = size(G,1);
contagiousness = 0.8;
days_in = zeros(n,1);
status = zeros(n,1);
% create the initial infection (1 means infected)
status(3124) = 1;
% these codes are pretty self explanatory, look in the function "virus_model"
% for more info.
%--------------------------------------------------------------------------
% Now will actually iterate through the days to run the simulation
% Initialize a storage variable with size estimated for necessary storage
Daily_data = cell(100,2);
stillrunning = true;
%
ii = 0;
while stillrunning
    ii = ii + 1;
    % adjust for the day
    day = mod(ii,7);
    if day==0
        day = 7;
    end
    % get a model we can tweek for the day
    Pcurr = P;
    Pcurr(LG) = Pcurr(LG)*social_days(day);
    % now we adjust some of the groups' daily model in a semi-random way so
    % as to introduce some further organic variablitity that is still
    % dependent on the friend groups ....see notes in the function for
    % details and explanation of the parameters
    numcnt = 0.5;
    numstd = 0.35;
    adjcnt = 0.55;
    adjstd = 0.45;
    [ADJ] = semi_randomize_daily_group_behavior(G,Comms,0.7,numcnt,numstd,adjcnt,adjstd);
    Pcurr(LG) = Pcurr(LG).*ADJ(LG);
    Pcurr(Pcurr>1) = 1;
    Pcurr(Pcurr<0) = 0;
    % draw the day's contacts from the model Pcurr (output is 3826x3826 array)
    [adjacencyG0] = day_contacts_from_model(Pcurr);
    % run the virus model (look inside the function for details and parameter adjustment)
    [status,days_in] = virus_model(adjacencyG0,status,days_in,contagiousness);
    % check if the virus is finished spreading
    numinf = sum(status==1);
    numcont = sum(status==2);
    numsev = sum(status==3);
    if numinf+numcont+numsev==0
        stillrunning = false;
    end
    % Store the daily state of the simulation
    % make a Matlab graph object of the contacts and store stuff
    G0=graph(adjacencyG0);
    Daily_data{ii,1} = G0;
    Daily_data{ii,2} = status;
end
%
% now the simulation has finished, convert the data to a structured variable
% in the format described at the top of this script
day = cell2struct(Daily_data, {'contacts','status'}, 2);
% trim unused preallocated storage if necessary
if ii<100
    day((ii+1):end) =[];
end










