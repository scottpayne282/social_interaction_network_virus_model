function [G] = day_contacts_from_model(P)

% this function generates a 0,1 weight undirected graph from the
% probability model defined by the nxn P where P(i,j) is the probability of
% an contact between i and j

n = size(P,1);

% linearize the upper triangular indices
IND=1:nchoosek(n,2);
J = round(floor(-.5 + .5 * sqrt(1 + 8 * (IND - 1))) + 2);
I = round(J .* (3 - J) / 2 + IND - 1);

% this is actually pretty quick
lininds = sub2ind([n,n],I',J');

G = zeros(n,n);

n_input = ones(1,IND(end));
bernou_trls = binornd(n_input,P(lininds)');
G(lininds) = bernou_trls';

G = G + G';