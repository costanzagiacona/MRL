function a = epsilon_greedy(Q, epsilon, A)
    if rand < epsilon
        a = randi(A);
    else
        a = find(Q == max(Q), 1, 'first');
    end
end
