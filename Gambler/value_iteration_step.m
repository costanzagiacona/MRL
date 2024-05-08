function [vpin, policy, p2] = value_iteration_step(S,A,P,R,gamma,vpi)

% initialize matrices
q = zeros(S,A);
vpin = zeros(S,1);
policy = zeros(S,1);
p2 = {};

% we loop for all the state
for s = 1:S 
    for a = 1:A
        q(s,a) = R(s,a) + gamma*P(s,:,a)*vpi; %funzione qualità
    end
    % synchronous substitution
    vpin(s) = max(q(s,:)); %prendo valore policy migliore
    %policy migliore
    policy(s) = find(q(s,:) == max(q(s,:)),1,"first"); %rompo la parità prendendo l'indice minore
    % p2(s) = find(q(s,:) == max(q(s,:)),1,"last");
    p2{s} = find(q(s,:) == max(q(s,:)));
end
