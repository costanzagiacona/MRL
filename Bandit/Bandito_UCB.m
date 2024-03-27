clear all
close all
clc

rng(1) % set the random seed

A = 5; % dimension action space
B = 5; %azioni avversario
c = 1; % exploration rate
lengthEpisode = 1000; % number of actions to take

Q = ones(A, 1); % estimate of the value of actions
N = zeros(A, 1); % number of times we take each action

% save history of Q and N
historyQ = zeros(A, lengthEpisode);
historyN = zeros(A, lengthEpisode);

for i = 1:lengthEpisode
    Qext = Q + c*sqrt(log(i)./(N+1)); % extended value function
    a = find(Qext == max(Qext), 1, "first"); % to break parity
    b = randi(B); %avversario randomico
    r = bandit_d_s(a,b); 
    N(a) = N(a) + 1; % increment the counter for the actions taken
    Q(a) = Q(a) + 1/N(a)*(r - Q(a));

    % save the history
    historyQ(:,i) = Q;
    historyN(:, i) = N;
end

%% plots

% plot the history of Q
subplot(2,1,1)
plot(historyQ','LineWidth',2)
title("Q - stima del reward atteso")
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

% plot the history of N
subplot(2,1,2)
plot(historyN','LineWidth',2)
title("N - storia")
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')