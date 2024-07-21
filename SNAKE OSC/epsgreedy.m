function a = epsgreedy(Q, s, A, epsilon)

% with probability epsilon take a random action
if rand < epsilon
    a = randi(A);
else
% otherwise take the greedy with respect to Q in the current state
    v = find(Q(s,:) == max(Q(s, :)));
    a = v(randi(length(v)));
    % a = v(randi(length(v)));
end