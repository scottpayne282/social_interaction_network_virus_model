
%--------------------------------------------------------------------------
% The scripts and files in this folder demonstrate a basic use of the
% modeling tools in this package.

% In this example we do a basic simulation of virus spread with social
% contact simulated based on the social structures in the friend network.
% We then compare that simulation with a randomized social contact version
% and also we compare the friend contact version with four runs to look at
% the variation across runs.

% This readme documents the way the scripts were run to create the example
% simulation.

%--------------------------------------------------------------------------
% 1) We ran the script 'simulate_virus_outbreak_basic.m' and the resulting
% structure variable called "day" was saved as the file 'simulation_April20_friendsonly_default.mat'
%
% 2) to visualize the simulation you can load the files for the social
% network data and layout: 'college_social_network_data.mat' and 'network_diagram_xy_coords.mat'
% (found in the folder social_network_data) and use the function:
%       [fig,bttns,hslide,cntctObs] = visualize_simulation(day,G,Comms,Y,meta_data)
% That function creates a figure with gui buttons to show the features of
% the social network and a slider that sweeps through the days of the virus
% simulation
%
% 3) We ran the script 'create_randomized_contacts_matching_dregree.m' which
% creates an alternate socialization scenario in which the graphs
% representing daily contacts between individuals match the degree
% sequences of the contact graphs saved in the first simulation except that
% in this new scenario the contact graphs are random instead of being
% fitted to the social structure of the underlying network. The new
% simulation variable "dayV2" was saved as the file 'randomized_contactgraphs_based_April20_data.mat'
%
% 4) We ran the script
% 'simulate_virus_outbreak_basic_RANDOMIZED_CONTACTS.m' to create the
% simulation of virus based on the randomized social contact scenario
% described above. The resulting simulation variable "dayV2" was saved as
% the file 'simulation_April20_randomizedversion_default.mat'
%
% 5) to compare the daily infection curves of the two simulations run the
% script 'compare_two_simluations_curves.m'
%
% 6) We ran the script 'simulate_virus_outbreak_basic.m' three more times
% and saved those simulations as files.
%
% 7) to compare the four saved simulations run the script 'view_curves_four_simulations.m'







