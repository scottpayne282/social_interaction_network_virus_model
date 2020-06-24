function [curves] = virus_curves(sim_var)

% This funtion outputs the curves representing the daily amounts of each
% state of the virus represented by the individuals
%--------------------------------------------------------------------------
% INPUT:
%       sim_var is the variable that stores the data of the simulation and
%       should be a structure object that can be indexed as follows:
%       sim_var(i).contacts is a Matlab graph object representing the daily
%       contacts between individuals on day i
%       sim_var(i).status is an nx1 numeric array such that the kth entry
%       is the status of individual k on day i
%       the status options are as follows:
%       0 -- susceptible
%       1 -- infected
%       2 -- contagious
%       3 -- severely ill
%       4 -- recovered
%       The status information is what we need to get the virus curves
%--------------------------------------------------------------------------

% get the number of days represented in the simulation
numds = size(sim_var,1);

% create the storage for output
curves = zeros(5,numds);

for i = 1:numds
    statusi = sim_var(i).status;
    curves(1,i) = sum(statusi==0);
    curves(2,i) = sum(statusi==1);
    curves(3,i) = sum(statusi==2);
    curves(4,i) = sum(statusi==3);
    curves(5,i) = sum(statusi==4);
end









