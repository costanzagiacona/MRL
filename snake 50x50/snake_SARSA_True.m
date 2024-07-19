%% ALGORITMO SARSA TRUE ONLINE
clear all
close all
clc

load qualita_true_50.mat
% number of actions
A = 4;
% number of episodes
numEpisodes = 1000;
% exploration parameter
epsilon = 0.3;
% foresight parameter
gamma = 1;
% update parameter
alpha = 1e-2;
% define lambda
lambda = 0.1;

% size of the state space
POS = [0, 50*50];
DIR = [1, 4];

%dimesioni griglia
numrow = 50;
numcol = 50;

% parameters
M = 5; % number of cells per grid
N = 10; % number of grids

% dimension of the weight vector
d = (M+1)^3*N;

% initialize the weigth vector
% w = zeros(d,A);

% construct grids
[cellPOS, cellDIR] = griglie(POS, DIR, M, N);

% define colors
plotColors = lines(N);
% plot the grids
figure()
hold on
for i = 1:N
    for j = 1:M+2
        plot([cellPOS(i,j), cellPOS(i,j)], DIR, 'Color', plotColors(i,:));
        plot(POS, [cellDIR(i,j), cellDIR(i,j)], 'Color', plotColors(i,:));
    end
end
xlim(POS)
ylim(DIR)

% dimensioni muri
muro_min = 25;
muro_max = 75;

% total return
G = zeros(numEpisodes,1);

%%%%%  posizione iniziale del serpente %%%%%
len_snake = 5;
locx = [20 20 20 20 20]; %pos orizzontale
locy = [23 24 25 26 27]; %pos verticale
pos_ini = zeros(1,len_snake);
    for i = 1:len_snake
        pos_ini(i) = sub2ind([numrow numcol], locx(i), locy(i));
    end


% Inizializzazione del punteggio
point = 0;

%%%%% target %%%%%
% Posizione casuale per il target
indtarget = genera_target50x50(muro_min, muro_max, numcol,numrow, locx, locy);


figure()
for e = 1:numEpisodes
    disp(e)
    % initialize the episode
    s = {pos_ini, 3, indtarget};
    alpha = 1/e;
    % initialize eligibility traces
    z = zeros(size(w));

    % define Qold
    Qold = 0;

    % get feature for initial state
    Fac = get_features(s, cellPOS, cellDIR, M, N);
    % get quality function
    % Q = sum(w(Fac,:));
    Q(:,1) = sum(w(Fac(:,1),:));
    % take epsilon greedy actions
    if rand < epsilon
        a = randi(A); % take random action
    else
        a = find(Q(:,1) == max(Q(:,1)), 1, 'first'); % take greedy action wrt Q
    end
    a
    % at the beginning is not terminal
    isTerminal = false;
    while true
        % take action a and observe sp and r
        [sp, r] = modello_snake_50x50(s, a, POS, DIR,e, point);
        % update total return
        G(e) = G(e) + r;

        % aggiornamento parametri
        
        % compute next q function
        Facp = get_features(sp, cellPOS, cellDIR, M, N);
        Qp = sum(w(Facp(:,1),:));
        % take epsilon greedy action
        if rand < epsilon
            ap = randi(A); % take random action
        else
            ap = find(Qp == max(Qp), 1, 'first'); % take greedy action 
        end
        
        % compute Q functions
        QQ = sum(w(Fac(:,1),a));
        QQp = sum(w(Facp(:,1),ap));
        % compute temporal difference error
        delta = r + gamma*QQp - QQ;

        % update eligiblity traces
        z = gamma*lambda*z;
        z(Fac(:,1),a) = z(Fac(:,1), a) + 1 - alpha*gamma*lambda*sum(z(Fac(:,1), a));
        % update weights
        w = w + alpha*(delta + QQ - Qold)*z;
        w(Fac(:,1),a) = w(Fac(:,1),a) - alpha*(QQ - Qold);
        % update Qold
        Qold = QQp;
        
        % update Fac
        Fac(:,1) = Facp(:,1);
        

        % in base al reward verifichiamo se stiamo un uno stato terminale
        % stato terminale quando raggiunge il target
        if r == 5
            point = point+1;
            % disp(point)
            %%%%% target %%%%%
            % Posizione casuale per il target
            % while(1)
            % % randperm genera un numero casuale preso tra 1 e size(mat_r)
            % tx = randperm(numrow,1); % coordinata casuale x
            % ty = randperm(numcol,1); % coordinata casuale y
            % 
            % % se il target ha le stesse coordinate del serpente, non è valido
            %     if sum(locx == tx & locy == ty) == 0
            %         break;
            %     end
            % end
            indtarget = genera_target50x50(muro_min, muro_max, numcol,numrow, locx, locy);

            break;
                 
        elseif r == -5 %%% si è morso la coda %%%
           
                % delta = r - sum(w(Fac(:,1),a));
                point = 0;
                sp = {pos_ini, 3, indtarget};
        end

        % update action
        a = ap;
        % update state
        s = sp;
        % figure(6)
        % surf(w)
        % 
        % grid on
    end
end
%%
save qualita_true_50.mat  w
%% plot return per episode
figure()
plot(G, 'LineWidth',2)

%% plot optimal value function
% define a grid
[xx, vv] = meshgrid(linspace(POS(1), POS(2), 50), ...
    linspace(DIR(1), DIR(2), 40));
% define value function
Value = zeros(size(xx));
for i = 1:size(xx,1)
    for j = 1:size(xx,2)
        s = [xx(i,j); vv(i,j)];
        Fac = get_features(s, cellPOS, cellDIR, M, N);
        Qs = sum(w(Fac, :));
        Value(i,j) = max(Qs);
    end
end
figure()
surf(xx, vv, Value)