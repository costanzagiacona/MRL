%% ALGORITMO SARSA TRUE ONLINE
clear all
close all
clc

load qualita_true_50.mat
% numero di azioni
A = 4;
% numero di episodi
numEpisodes = 1e6;
% parametro di esplorazione
epsilon = 0.8;
% foresight parameter
gamma = 1;
% parametro di aggiornamento
alpha = 1e-2;
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
Q = zeros(A,5);

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
    fprintf("\n\nEPISODIO -> %d\n", e);

    morso = 0;
    muro = 0;    

    num_tested = 0;

    % Prendi azioni epsilon-greedy
    if rand < epsilon
        a = randi(A); % prendi azione casuale
    else
        a = find(Q(:,1) == max(Q(:,1)), 1, 'first'); % prendi azione greedy rispetto a Q
    end

    % Inizializza l'episodio
    s = {pos_ini, a, indtarget};

    alpha = 1 / e;

    % Inizializza le tracce di eligibilità
    z = zeros(size(w));

    % Definisci Qold
    Qold = 0;

    % Ottieni le feature per lo stato iniziale
    Fac = get_features2(s, cellPOS, cellDIR, M, N);

    % Ottieni la funzione di qualità
    Q = sum(w(Fac, :));

    % Controllo per NaN
    if any(isnan(Q))
        error('Q contiene NaN all''inizio dell''episodio');
    end
    
    % Prendi azioni epsilon-greedy
    if rand < epsilon
        a = randi(A); % prendi azione casuale
    else
        a = find(Q(:,1) == max(Q(:,1)), 1, 'first'); % prendi azione greedy rispetto a Q
    end

    % All'inizio non è terminale
    isTerminal = false;
    while true
        % Prendi azione a e osserva sp e r
        [sp, r, muro] = modello_snake_50x50(s, a, POS, DIR, e, point, muro, muro_min, muro_max);
        history_muro = [history_muro muro];
        history_azione(a) = history_azione(a) + 1;

        % Aggiorna il rendimento totale
        G(e) = G(e) + r;

        % Aggiornamento parametri
        
        % Calcola la prossima funzione Q
        Facp = get_features2(sp, cellPOS, cellDIR, M, N);
        Qp = sum(w(Facp, :));
        
        % Controllo per Inf e NaN
        if any(isinf(Qp)) || any(isnan(Qp))
            warning('Qp contiene Inf o NaN. Reinizializzo Qp a zero.');
            Qp = zeros(size(Qp)); % O qualche altro valore di default
        end
        
        % Prendi azione epsilon-greedy
        if rand < epsilon
            ap = randi(A); % prendi azione casuale
        else
            ap = find(Qp == max(Qp), 1, 'first'); % prendi azione greedy
        end
        
        % Calcola le funzioni Q
        QQ = sum(w(Fac, a));
        QQp = sum(w(Facp, ap));
        
        % Controllo per NaN e Inf
        if any(isinf(QQ)) || any(isnan(QQ)) || any(isinf(QQp)) || any(isnan(QQp))
            error('QQ o QQp contiene NaN o Inf');
        end
        
        % Calcola l'errore di differenza temporale
        delta = r + gamma * QQp - QQ;
        
        % Controllo per Inf e NaN in delta
        if any(isinf(delta)) || any(isnan(delta))
            warning('delta contiene Inf o NaN. Reinizializzo delta a zero.');
            delta = 0; % O qualche altro valore di default
        end

        % Aggiorna le tracce di eligibilità
        z = gamma * lambda * z;
        z(Fac, a) = z(Fac, a) + 1 - alpha * gamma * lambda * sum(z(Fac, a));

        % Controllo per NaN nelle tracce di eligibilità
        if any(isnan(z(:)))
            error('z contiene NaN');
        end
        
        % Aggiorna i pesi
        lambda_reg = 1e-4; % Tasso di regularizzazione
        w = w + alpha * (delta + QQ - Qold) * z - lambda_reg * w;
        w(Fac, a) = w(Fac, a) - alpha * (QQ - Qold) - lambda_reg * w(Fac, a);

        % Clipping dei pesi
        maxWeight = 1e3;
        minWeight = -1e3;
        w(w > maxWeight) = maxWeight;
        w(w < minWeight) = minWeight;

        % Controllo per NaN nei pesi
        if any(isnan(w(:)))
            error('w contiene NaN');
        end

        % Aggiorna Qold
        Qold = QQp;

        % Aggiorna Fac
        Fac = Facp;

        % In base al reward verifichiamo se stiamo in uno stato terminale
        % Stato terminale quando raggiunge il target
        if r == 5
            point = point + 1;
            punteggio = [punteggio point];
            fprintf("punteggio: %d\n", point);
            fprintf("si è morso %d volte\n", morso);
            fprintf("ha sbattuto %d volte\n", muro);
            history_morso = [history_morso morso];

            indtarget = genera_target50x50(muro_min, muro_max, numcol, numrow);
            [tx, ty] = ind2sub([numrow, numcol], indtarget);
            
            num_tested = 0;
            corpo = genera_snake(tx, ty, offset, muro_min, muro_max, numcol, numrow);
            locx = corpo(:, 1);
            locy = corpo(:, 2);
            
            for i = 1:len_snake
                pos_ini(i) = sub2ind([numrow numcol], locx(i), locy(i));
            end
            break;
                 
        elseif r == -5 %%% si è morso la coda %%%
            % delta = r - sum(w(Fac(:,1), a));
            point = 0;
            morso = morso + 1;
            sp = {pos_ini, rand(A), indtarget};
        end

        % Aggiorna azione
        a = ap;
        % Aggiorna stato
        s = sp;

        % GLIE
        if mod(e, 20) == 0
            epsilon = epsilon * 0.9;
            if epsilon <= 0.01
                epsilon = 0.8;
            end
        end
    end
end

%% salvataggio parametri
save qualita_true_50.mat w history_morso history_azione history_muro punteggio

%% plot return per episode
figure(2)
plot(G, 'LineWidth', 2)
xlim([0 e])

%% plot statistiche
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
title('Frequenza con cui si morde')

figure(5)
plot(history_muro);
title('Frequenza con cui colpisce il muro')

figure(6)
plot(punteggio);
title("Storico punteggio")
