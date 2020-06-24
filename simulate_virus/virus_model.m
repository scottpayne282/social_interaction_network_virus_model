function [status,days_in] = virus_model(G0,status,days_in,contagiousness)

% this function updates the spread of the virus based on the person to
% person contacts of the day represented by the network data G0
%
% INPUT
% G0 is an nxn unweighted adjacency matrix
%
% days_in is an nx1 numeric array counting the number of days into virus
% progression for each individual separately
%
% status is an nx1 numerical vector representing the status of each
% individual by a number
% 0 -- susceptible
% 1 -- infected
% 2 -- contagious
% 3 -- severely ill
% 4 -- recovered
%
% contagiousness is a scalar that is the probability that a contact results
% in a new infection case
%
%
% OUTPUT
% The status vector can be used to color plot the individuals by status for
% animation and tracking daily data

% some parameters
time_contagious = 2;
time_severe = 6;
time_recover = 14;

% First we remove any contacts related to a person with a severe case since
% we assume in this model that severe cases are isolating
temp_log = status == 3;
temp_log = temp_log';
if any(temp_log)
    G0(temp_log,:) = 0;
    G0(:,temp_log) = 0;
end

%--------------------------------------------------------------------------
% update days_in for all the individuals who are in some state of the
% virus
days_in(status==1) = days_in(status==1) + 1;
days_in(status==2) = days_in(status==2) + 1;
days_in(status==3) = days_in(status==3) + 1;

% figure out the cases now switching to contagious and update them
newcases = find(status==1&days_in>=time_contagious);
if ~isempty(newcases)
    for i = 1:length(newcases)
        switch days_in(newcases(i))
            case 2
                if binornd(1,0.5)
                    status(newcases(i)) = 2;
                end
            case 3
                if binornd(1,0.80)
                    status(newcases(i)) = 2;
                end
            case 4
                status(newcases(i)) = 2;
        end
    end
end
%--------------------------------------------------------------------------

% next we will update the new infections based on the day contacts
% represented by G0
% NOTE: in this model we assume that severe cases are isolating so they do
% not factor into new infections, hence we only need to consider those who
% are status 2 (contagious)
newcases = find(status==2);
if ~isempty(newcases)
    for i = 1:length(newcases)
        person = newcases(i);
        temp_log = logical(G0(:,person)) & status==0; %<-- THIS LINE!!
        if contagiousness~=1
            % generate a logical drawn from binomial that will handle the
            % contagiousness parameter
            n_input = ones(1,sum(temp_log));
            bernou_trls = binornd(n_input,repmat(contagiousness,[1 sum(temp_log)]));
            status(temp_log) = bernou_trls';
        else
            status(temp_log) = 1;
        end
    end
end
%--------------------------------------------------------------------------

% figure out the cases now switching from contagious to severe and update them
newcases = find(status==2&days_in>=time_severe);
if ~isempty(newcases)
    for i = 1:length(newcases)
        switch days_in(newcases(i))
            case 6
                if binornd(1,0.1)
                    status(newcases(i)) = 3;
                end
            case 7
                if binornd(1,0.1)
                    status(newcases(i)) = 3;
                end
            case 8
                if binornd(1,0.1)
                    status(newcases(i)) = 3;
                end
            case 9
                if binornd(1,0.1)
                    status(newcases(i)) = 3;
                end
            case 10
                if binornd(1,0.1)
                    status(newcases(i)) = 3;
                end
        end
    end
end
%--------------------------------------------------------------------------

% figure out the cases now switching to recovered and update them
newcases = find(status==2|status==3&days_in>=time_recover);
if ~isempty(newcases)
    for i = 1:length(newcases)
        switch days_in(newcases(i))
            case 14
                if binornd(1,0.50)
                    status(newcases(i)) = 4;
                end
            case 15
                if binornd(1,0.70)
                    status(newcases(i)) = 4;
                end
            case 16
                if binornd(1,0.80)
                    status(newcases(i)) = 4;
                end
            case 17
                if binornd(1,0.80)
                    status(newcases(i)) = 4;
                end
            case 18
                if binornd(1,0.80)
                    status(newcases(i)) = 4;
                end
            case 19
                status(newcases(i)) = 4;
        end
    end
end





