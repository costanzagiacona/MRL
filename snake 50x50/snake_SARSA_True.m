%% ALGORITMO SARSA TRUE ONLINE
clear all
close all
clc

load qualita_true_50.mat
% number of actions
A = 4;
% number of episodes
numEpisodes = 1e6;
% exploration parameter
epsilon = 0.8;
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

offset = 1;

% parameters
M = 5; % number of cells per grid
N = 10; % number of grids

% dimension of the weight vector
d = (M+1)^6*N;

% initialize the weigth vector
% w = randn(d,A);

% construct grids
[cellPOS, cellDIR] = griglie(POS, DIR, M, N);

% dimensioni muri
muro_min = 15;
muro_max = 34;

% total return
G = zeros(numEpisodes,1);

% inizializziazione funzione qualità
Q = zeros(A,5);

% teniamo traccia delle configurazioni del serpente testste
global num_tested;

%%%%%  posizione iniziale del serpente %%%%%
len_snake = 5;

% Inizializzazione del punteggio
point = 0;
punteggio = [];

%%%%% target %%%%%
% Posizione casuale per il target
indtarget = genera_target50x50(muro_min, muro_max, numcol,numrow);
[tx,ty] = ind2sub([numrow, numcol], indtarget);
corpo = genera_snake(tx,ty, offset, muro_min, muro_max, numcol, numrow);
locx = corpo(:,1);
locy = corpo(:,2);

pos_ini = zeros(1,len_snake);
for i = 1:len_snake
    pos_ini(i) = sub2ind([numrow numcol], locx(i), locy(i));
end

% history_morso = [];
% history_azione = zeros(A,1);
% history_muro = [];

for e = 1:numEpisodes
    fprintf("\n\nEPISODIO -> %d\n",e);

    morso = 0;
    muro = 0;    

    num_tested = 0;

    % take epsilon greedy actions
    if rand < epsilon
        a = randi(A); % take random action
    else
        a = find(Q(:,1) == max(Q(:,1)), 1, 'first'); % take greedy action wrt Q
    end

    % initialize the episode
    s = {pos_ini, a, indtarget};

    alpha = 1/e;
    % initialize eligibility traces
    z = zeros(size(w));

    % define Qold
    Qold = 0;

    % get feature for initial state
    Fac = get_features2(s, cellPOS, cellDIR, M, N);

    % get quality function
    Q = sum(w(Fac,:));
    % Q(:,1) = sum(w(Fac(:,1),:));
    
    % at the beginning is not terminal
    isTerminal = false;
    while true
 
        % take action a and observe sp and r
        [sp, r, muro] = modello_snake_50x50(s, a, POS, DIR, e, point, muro, muro_min, muro_max);
        history_muro = [history_muro muro];
        history_azione(a) =  history_azione(a) + 1;

        % update total return
        G(e) = G(e) + r;

        % aggiornamento parametri
        
        % compute next q function
        Facp = get_features2(sp, cellPOS, cellDIR, M, N);
        Qp = sum(w(Facp,:));
        % take epsilon greedy action
        if rand < epsilon
            ap = randi(A); % take random action
        else
            ap = find(Qp == max(Qp), 1, 'first'); % take greedy action 
        end
        
        % compute Q functions
        QQ = sum(w(Fac,a));
        QQp = sum(w(Facp,ap));
        % compute temporal difference error
        delta = r + gamma*QQp - QQ;

        % update eligiblity traces
        z = gamma*lambda*z;
        z(Fac,a) = z(Fac, a) + 1 - alpha*gamma*lambda*sum(z(Fac, a));
        % update weights
        w = w + alpha*(delta + QQ - Qold)*z;
        w(Fac,a) = w(Fac,a) - alpha*(QQ - Qold);
        % update Qold
        Qold = QQp;
        
        % update Fac
        Fac = Facp;
        
        % in base al reward verifichiamo se stiamo un uno stato terminale
        % stato terminale quando raggiunge il target
        if r == 5
            point = point+1;
            punteggio = [punteggio point];
            fprintf("punteggio: %d\n", point);
            % disp(point)
            fprintf("si è morso %d volte\n", morso);
            fprintf("ha sbattuto %d volte\n", muro);
            history_morso = [history_morso morso];

            indtarget = genera_target50x50(muro_min, muro_max, numcol,numrow);
            [tx,ty] = ind2sub([numrow, numcol], indtarget);
            
            num_tested = 0;
            corpo = genera_snake(tx,ty, offset, muro_min, muro_max, numcol, numrow);
            locx = corpo(:,1);
            locy = corpo(:,2);
            
            for i = 1:len_snake
                pos_ini(i) = sub2ind([numrow numcol], locx(i), locy(i));
            end
            break;
                 
        elseif r == -5 %%% si è morso la coda %%%
            % delta = r - sum(w(Fac(:,1),a));
            point = 0;
            morso = morso+1;
            sp = {pos_ini, rand(A), indtarget};
        end

        % update action
        a = ap;
        % update state
        s = sp;
        % figure(6)
        % surf(w)
        % 
        % grid on

        if mod(e,20) == 0
            epsilon = epsilon*0.9;
            if epsilon <= 0.01
                epsilon = 0.8;
            end
        end
    end
end
%%
save qualita_true_50.mat w history_morso history_azione history_muro punteggio
%% plot return per episode
figure(2)
plot(G, 'LineWidth',2)

%% plot statistiche
figure(3)
bar(history_azione);
title('Preferenza azioni')

figure(4)
plot(history_morso);
title('Frequenza con cui si morde')

figure(5)
plot(history_muro);
title('Frequenza con cui colpisce il muro')

figure(6)
plot(punteggio);
title("Storico punteggio")
