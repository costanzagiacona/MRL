%% ALGORITMO SARSA

% Pulisce l'ambiente di lavoro
clear all
close all
clc

load qualita.mat
%%%%%% Parametri %%%%%
% Numero di azioni
A = 4;
% Numero di episodi
numEpisodes = 1000;
% Parametro di esplorazione (epsilon-greedy)
epsilon = 0.1;
% Parametro di sconto 
gamma = 1;
% Parametro di aggiornamento 
alpha = 1e-2;

% Dimensione dello spazio degli stati
POS = [0, 50*50];
DIR = [1, 4];

numrow = 50;
numcol = 50;

% intorno nel quale generiano testa serpente rispetto a target
offset = 5;
M = 5; % numero di celle per griglia
N = 10; % numero di griglie

% Dimensione del vettore dei pesi
d = (M+1)^3 * N;

% funzione qualita (azioni, lunghezza del serpente)
% 
% Q = zeros(A,5);
% Inizializzazione del vettore dei pesi con valori casuali
% w = randn(d, A);

% Creazione griglie
[cellPOS, cellDIR] = griglie(POS, DIR, M, N);

% Colori per il grafico
plotColors = lines(N);
% Stampiamo a schermo le griglie
figure(1)
hold on
for i = 1:N
    for j = 1:M+2
        plot([cellPOS(i,j), cellPOS(i,j)], DIR, 'Color', plotColors(i,:));
        plot(POS, [cellDIR(i,j), cellDIR(i,j)], 'Color', plotColors(i,:));
    end
end
xlim(POS)
ylim(DIR)


muro_min = 25;
muro_max = 75;
% Inizializzazione del rendimento totale
G = zeros(numEpisodes, 1);


%%%%%  posizione iniziale del serpente %%%%%
len_snake = 5;
% locx = [20 20 20 20 20]; %pos orizzontale
% locy = [23 24 25 26 27]; %pos verticale
% pos_ini = zeros(1,len_snake);
%     for i = 1:len_snake
%         pos_ini(i) = sub2ind([numrow numcol], locx(i), locy(i));
%     end


% Inizializzazione del punteggio
point = 0;
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


%%%%% EPISODI %%%%%

for e = 1:numEpisodes
    fprintf("Episodio ->");
    disp(e)
    
    %%%%% posizione iniziale serpente %%%%%
    % stato: posizione iniziale, direzione iniziale (3) e target
    s = {pos_ini, 3, indtarget};
    
    % feature dello stato iniziale
    Fac = get_features(s, cellPOS, cellDIR, M, N);
    
    % Funzione qualità della testa
    % creiamo la funzine qualita sulla base del vettore dei pesi
    for i = 1:6
        Q(:,i) = sum(w(Fac(:,i),:));
    end
    % aggiorniamo il vattore dei pesi delle features attive

    %%%%% azione epsilon greedy %%%%%
    if rand < epsilon
        a = randi(A); % azone random 
    else
        a = find(Q == max(Q), 1, 'first'); % azione greedy rispetto a Q
    end

    % inizializzazione
    isTerminal = false;


    while true
        % esegue l'azione a e osserva il nuovo stato sp e la ricompensa r
        % disp(a)
        [sp, r] = modello_snake_50x50(s, a, POS, DIR,e, point);
        % aggiornamento ritorno
        G(e) = G(e) + r;

        % STATO TERMINALE
        if r == 5 %%% target preso %%%
           
            delta = r - sum(w(Fac(:,1),a));
            point = point+1;
            fprintf("punteggio: ");
            disp(point)
           
        else
            % features dello stato successivo
            Facp = get_features(sp, cellPOS, cellDIR, M, N);
            % calcolo della funzione qualità per lo stato successivo
            fac1 = Facp(:,1);
            % Qp = sum(w(fac1,:));
            for i = 1:6
                Qp(:,i) = sum(w(Fac(:,i),:));
            end
            for i = 1:4
                sumQ(i) = sum(Qp(i,:));
            end
            % azione epsilon greedy
            if rand < epsilon
                ap = randi(A); % take random action
            else
                % ap = find(Qp == max(Qp), 1, 'first'); % take greedy action 
                 ap = find(sumQ == max(sumQ), 1, 'first');
            end

            % calcolo errore delle differenza temporali
            delta = r + gamma*sumQ(ap) - sum(w(Fac(:,1),a));

            if r == -5 %%% il serpente si è morso %%%
                point = 0;
                sp = {pos_ini, 3, indtarget};
                % corpo = genera_snake(tx,ty, offset, muro_min, muro_max, numcol, numrow);
                % locx = corpo(:,1);
                % locy = corpo(:,2);
                % 
                % 
                % for i = 1:len_snake
                %     pos_ini(i) = sub2ind([numrow numcol], locx(i), locy(i));
                % end
             end
        end
        % aggiornamento vettore dei pesi
        w(Fac(:,1),a) = w(Fac(:,1),a) + alpha*delta;
        
        if r ~= 5 %stato non terminale
        % aggiornamento stato, azione e features
        s = sp;
        a = ap;
        Fac = Facp;
        else
            % Posizione casuale per il target
            indtarget = genera_target50x50(muro_min, muro_max, numcol,numrow);
            [tx,ty] = ind2sub([numrow, numcol], indtarget);
            corpo = genera_snake(tx,ty, offset, muro_min, muro_max, numcol, numrow);
            locx = corpo(:,1);
            locy = corpo(:,2);
            
            
            for i = 1:len_snake
                pos_ini(i) = sub2ind([numrow numcol], locx(i), locy(i));
            end

            break;
        end

        
        
    end
end
%%
save qualita.mat Q w
%% plot return per episode
figure(3)
plot(G, 'LineWidth',2)

% %% plot optimal value function
% % define a grid
% [xx, vv] = meshgrid(linspace(POS(1), POS(2), 50), ...
%     linspace(DIR(1), DIR(2), 40));
% % define value function
% Value = zeros(size(xx));
% for i = 1:size(xx,1)
%     for j = 1:size(xx,2)
%         s = [xx(i,j); vv(i,j)];
%         Fac = get_features(s, cellPOS, cellDIR, M, N);
%         Qs = sum(w(Fac, :));
%         Value(i,j) = max(Qs);
%     end
% end
% figure(4)
% surf(xx, vv, Value)