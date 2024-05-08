function vpi = policy_eval(S,P,R,policy,gamma)
% data una policy stima il valore tramite formula Bellman

% transition probability matrix
Ppi = zeros(S,S);
% reward vector
Rpi = zeros(S,1);

for s = 1:S %sommatoria
    % matrices can be constructed row by row
    Ppi(s,:) = P(s,:,policy(s));
    Rpi(s) = R(s,policy(s)); %parte sommatoria con reward
end

% solve directly the Bellman equation
vpi = (eye(S) - gamma*Ppi)\Rpi;
% inv(eye(S) - gamma*Ppi)*Rpi