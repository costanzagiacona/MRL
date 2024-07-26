%% ALGORITMO SARSA TRUE ONLINE
clear all
close all
clc

load qualita_true.mat
% numero di azioni
A = 4;
% numero di episodi
numEpisodes = 1e6;
% foresight parameter
gamma = 0.99;
% definizione lambda
lambda = 0.1;

% spazio di stato
POS = [0, 50*50];
DIR = [1, 4];

% dimesioni griglia
numrow = 50;
numcol = 50;

% intorno del target
offset = 1;

% parameteri
M = 5; % numero di celle per griglia
N = 10; % numero di griglie

% dimensione vettore dei pesi
d = (M+1)^6*N;

% inizializzazione dettore dei pesi
% w = randn(d,A);

% realizzazione griglie
[cellPOS, cellDIR] = griglie(POS, DIR, M, N);

% dimensioni muri
muro_min = 15;
muro_max = 34;

% ritorno totale
G = zeros(numEpisodes,1);

% inizializzazione funzione qualità
% Q = zeros(A,5);

% teniamo traccia delle configurazioni del serpente testate
global num_tested;

%%%%%  posizione iniziale del serpente %%%%%
len_snake = 5;

% Inizializzazione del punteggio
point = 0;
% storico punteggio
punteggio = [];

%%%%% target %%%%%
% Posizione casuale per il target
indtarget = genera_target50x50(muro_min, muro_max, numcol,numrow);
[tx,ty] = ind2sub([numrow, numcol], indtarget);
[corpo, aprev] = genera_snake(tx,ty, offset, muro_min, muro_max, numcol, numrow);
locx = corpo(:,1);
locy = corpo(:,2);

pos_ini = zeros(1,len_snake);
for i = 1:len_snake
    pos_ini(i) = sub2ind([numrow numcol], locx(i), locy(i));
end

% history_morso = [];
% history_azione = zeros(A,1);
% history_muro = [];

% Parametri di apprendimento iniziali
initial_alpha = 1e-1;
alpha_decay = 0.999;
alpha_min = 1e-3;
epsilon = 0.5;
epsilon_decay = 0.999;
epsilon_min = 0.1;

for e = 1:numEpisodes
    fprintf("\n\nEPISODIO -> %d\n", e);

    % Aggiorna alpha e epsilon
    alpha = max(alpha_min, initial_alpha * alpha_decay^e);
    epsilon = max(epsilon_min, epsilon * epsilon_decay);
    % epsilon = 0.1;

    morso = 0;
    muro = 0;    
    num_tested = 0;

    % Prendi azioni epsilon-greedy
    % if rand < epsilon
    %     a = randi(A); % prendi azione casuale
    % else
    %     a = find(Q(:,1) == max(Q(:,1)), 1, 'first'); % prendi azione greedy rispetto a Q
    % end

    % Inizializza l'episodio
    s = {pos_ini, aprev, indtarget};
    z = zeros(size(w));
    Qold = 0;
    Fac = get_features2(s, cellPOS, cellDIR, M, N);
    Q = sum(w(Fac, :));

    if any(isnan(Q))
        error('Q contiene NaN all''inizio dell''episodio');
    end

    if rand < epsilon
        a = randi(A);
    else
        a = find(Q(:,1) == max(Q(:,1)), 1, 'first');
    end

    isTerminal = false;
    while true
        [sp, r, muro] = modello_snake_50x50(s, a, POS, DIR, e, point, muro, muro_min, muro_max);
        history_muro = [history_muro muro];
        history_azione(a) = history_azione(a) + 1;
        G(e) = G(e) + r;
        Facp = get_features2(sp, cellPOS, cellDIR, M, N);
        Qp = sum(w(Facp, :));
        
        if any(isinf(Qp)) || any(isnan(Qp))
            warning('Qp contiene Inf o NaN. Reinizializzo Qp a zero.');
            Qp = zeros(size(Qp));
        end
        
        if rand < epsilon
            ap = randi(A);
        else
            ap = find(Qp == max(Qp), 1, 'first');
        end
        
        QQ = sum(w(Fac, a));
        QQp = sum(w(Facp, ap));
        
        if any(isinf(QQ)) || any(isnan(QQ)) || any(isinf(QQp)) || any(isnan(QQp))
            error('QQ o QQp contiene NaN o Inf');
        end
        
        delta = r + gamma * QQp - QQ;
        
        if any(isinf(delta)) || any(isnan(delta))
            warning('delta contiene Inf o NaN. Reinizializzo delta a zero.');
            delta = 0;
        end

        z = gamma * lambda * z;
        z(Fac, a) = z(Fac, a) + 1 - alpha * gamma * lambda * sum(z(Fac, a));

        if any(isnan(z(:)))
            error('z contiene NaN');
        end
        
        lambda_reg = 1e-4;
        w = w + alpha * (delta + QQ - Qold) * z - lambda_reg * w;
        w(Fac, a) = w(Fac, a) - alpha * (QQ - Qold) - lambda_reg * w(Fac, a);

        maxWeight = 1e3;
        minWeight = -1e3;
        w(w > maxWeight) = maxWeight;
        w(w < minWeight) = minWeight;

        if any(isnan(w(:)))
            error('w contiene NaN');
        end

        Qold = QQ;
        Fac = Facp;

        if r == 5
            point = point + 1;
            punteggio = [punteggio point];
            fprintf("punteggio: %d\n", point);
            fprintf("si è morso %d volte\n", morso);
            fprintf("ha sbattuto %d volte\n", muro);
            history_morso = [history_morso morso];

            indtarget = genera_target50x50(muro_min, muro_max, numcol, numrow);
            [tx, ty] = ind2sub([numrow, numcol], indtarget);
            % tx = randi([24 26]);
            % ty = randi([24 26]);
            % indtarget = sub2ind([numrow, numcol], tx, ty);
            num_tested = 0;
            [corpo, aprev] = genera_snake(tx, ty, offset, muro_min, muro_max, numcol, numrow);
            locx = corpo(:, 1);
            locy = corpo(:, 2);
            
            for i = 1:len_snake
                pos_ini(i) = sub2ind([numrow numcol], locx(i), locy(i));
            end
            break;
                 
        elseif r == -5
            point = 0;
            morso = morso + 1;
            sp = {pos_ini, aprev, indtarget};
        end

        a = ap;
        s = sp;

    end
end

%%
save qualita_true.mat w history_morso history_azione history_muro punteggio

%%
figure(2)
plot(G, 'LineWidth', 2)
title('Ritorno')
xlim([0 e])

figure(3)
clr = [177,162,202; 
    139,211,230; 
    255,109,106;
    239,190,125] / 255;
b = bar(history_azione,'FaceColor','flat');
title('Preferenza azioni')
b.CData = clr;

figure(4)
plot(history_morso);
ylim([0 1800]);
title('Frequenza con cui si morde')

figure(5)
plot(history_muro);
% ylim([0 400])
title('Frequenza con cui colpisce il muro')

figure(6)
plot(punteggio);
title("Storico punteggio")
