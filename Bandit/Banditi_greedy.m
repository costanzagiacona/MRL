clear all
close all
clc

%rigenera gli stessi numeri casuali ogni volta che riesegui
rng(1) % set the random seed

%abbiamo 5 azioni
A = 5; % dimension action space
B = 5; % azioni avversario
epsilon = 0.01; % probability we take a random action
lengthEpisode = 1000; % number of actions to take

%inizializzo 
Q = ones(A, 1); % estimate of the value of actions
N = zeros(A, 1); % number of times we take each action
% save history of Q and N
historyQ = zeros(A, lengthEpisode);
historyN = zeros(A, lengthEpisode);

for i = 1:lengthEpisode %per ogni episodio
    if rand < epsilon % esploriamo
        a = randi(A); % we take a random action
        
    else
        % to break parity
        a = find(Q == max(Q), 1, 'first');  % either we take the one with lower index
        % a = find(Q == max(Q)); % list all optimal actions;
        % a = a(randi(length(a))); % take a random action among the optimal ones
    end

    b = randi(B); %avversario randomico
    r = bandit_d_s(a, b); 
    N(a) = N(a) + 1; % increment the counter for the actions taken
    Q(a) = Q(a) + 1/N(a)*(r - Q(a));

    % save the history
    historyQ(:,i) = Q;
    historyN(:, i) = N;
end

%% plots

% plot the history of Q
figure()
plot(historyQ','LineWidth',2)
title("Q - stima del reward atteso")
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

% plot the history of N
figure()
plot(historyN','LineWidth',2)
title("N - storia")
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')