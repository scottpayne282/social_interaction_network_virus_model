
% This script is a basic demo of how to use the modeling tools to simulate 
% virus spread through the college community via social interaction among
% close friends and others via RANDOMIZED interaction:
% This script simulates virus spread based on daily contact networks which
% were randomized in the script
% 'create_randomized_contacts_matching_dregree.m', see that script for
% explanation.
%
% THIS SCRIPT ADDS TO an pre-loaded Matlab structure variable "dayV2" where dayV2(i) is
% the status of the discrete time simulation on day i 
% dayV2(i).contacts is the Matlab graph object representing in-person
% contacts on day i and  dayV2(i).status is the 3826x1 numeric array
% representing the status of each individual (the status is the part we 
% will calculate in the running of this example script). 
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
%% load the pre-calculated daily contacts
% define your filepath, for example:
filepath = 'C:\Users\scott\Documents\MATLAB\social_interaction_network_virus_model\EXAMPLE_1\randomized_contactgraphs_based_April20_data.mat';
load(filepath)
% in this example script the loaded variable is called dayV2
%--------------------------------------------------------------------------
%% Now we'll run an example in which we simulate socialization that is random
%
% establish the initialized inputs for the virus model
n = 3826; %<-- need to set this according to the data size (number of individuals)
contagiousness = 0.8;
days_in = zeros(n,1);
status = zeros(n,1);
% create the initial infection (1 means infected)
status(3124) = 1;
%--------------------------------------------------------------------------
% Initialize a storage variable with size estimated for necessary storage
Daily_data = cell(100,2);
stillrunning = true;
%
ii = 0;
while stillrunning
    ii = ii + 1;
    % draw the day's contacts from the pre-loaded data (output is 3826x3826 array)
    [adjacencyG0] = full(adjacency(dayV2(ii).contacts));
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
dayV2 = cell2struct(Daily_data, {'contacts','status'}, 2);
% trim unused preallocated storage if necessary
dayV2((ii+1):end) =[];











