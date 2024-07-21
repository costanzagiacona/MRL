%% SERPENTE LUNGHEZZA 5

% clear all
close all
clc
% qualita.mat contiene la funzioone qualita addestrando l'algorimo con
% reword 10 se otteniamo il taeget, -1 per ogni passo e -1 se si mangia
load qualita5.mat
% load qualita_multi_target.mat

% inizializziamo i paramtri per l'algoritmo SARSA
gamma = 1;
alpha = 1e-2;
% numEpisodes = 1e7;
numEpisodes = 1e4;
epsilon = 0.5;

% definiao le dimesioni della griglia di gioco
numrow = 8;
numcol = 8;

% possibili coordinate del target
target_x = 8;
target_y = 8;

gg = 10;

% i vari stati del serpente dipendono dalla posizione della testa e la
% configurazione del corpo, e dalla posizione del target
[conf_snake,conf] = count_snake_configurations(5);
S = numrow*numcol*conf_snake*target_x*target_y;
% le azioni possibii da prendere sono quattro:
% UP, DOWN, LEFT, RIGHT
A = 4;
% tic
% contatore azioni
count_a = zeros(4, 1);
% history_A = zeros(A, numEpisodes);
% contatore per quando il serpente si morde da solo
count_m = 0;
% history_M = zeros(1, numEpisodes);
% storico dei punteggi
history_P = zeros(1, numEpisodes);
% contatore per tenere traccia di quando il serpente muore da usare nel
% punteggio
count_m_p = 0;

% initialize Q function
% Q = zeros(S, A);
% punteggio = [];
% contiamo i punti
point = 0;
% andamento del punteggio
point_tot = 0;

% vettore degli stati
% states = zeros(1, S);

%epsilon = 0;
% iterazione ricorsiva per ogni episodio
for e = 1 :numEpisodes
    count_m = 0; % ad ogni episodio azzero il contatore
    % disp(e)
    if mod(e,gg) == 0
        disp(e)
    end
    % definiamo la posizione iniziale serpente
    locx = [5 5 5 5 5]; % coordinate orizzontali
    locy = [4 5 6 7 8]; % coordinate verticali
    aprev = 3; % inizializziamo al direzione iniziale, visto 
               % l'orientamento iniziale del serpente, sccegliamo sempre sotto 
    
    % calcoliamo la configurazione del serpente, da confrontare con a la lista
    % che abbiamo a disposizione. La testa del serpente si trova sempre im
    % posizione (0,0)
    loc_cfx = locx - locx(1);
    loc_cfy = locy - locy(1);
    config = [loc_cfx(1) loc_cfy(1);
              loc_cfx(2) loc_cfy(2);
              loc_cfx(3) loc_cfy(3);
              loc_cfx(4) loc_cfy(4);
              loc_cfx(5) loc_cfy(5)];
    j = 1;
    % confontiamo al configurazione ottenuta con la lista, fino a quando non
    % troviamo una uguaglianza
    while true
        if config == conf{j}
            break;
        else 

            j = j+1;
        end
    end

    % definiamo il target che il serpente deve colpire
    % iteriamo fino a quando il target non appare in una posizione accettabile,
    % ossia fino a quando l target non ha le stesse coordianate del serpente
    while(1)
        %posizione target
        % randperm genera un numero casuale preso tra 1 e size(mat_r)
        tx = randperm(numrow,1); % coordinata casuale x
        ty = randperm(numcol,1); % coordinata casuale y
        % se il target ha le stesse coordinate del serpente, non è valido
        if sum(locx == tx & locy == ty) == 0
            break;
        end
    end

    % calcoliamo lo stato del serpente, a partire dalla posizione della testa e
    % la configurazione, e la posizione del target
    s = sub2ind([numrow, numcol, conf_snake, target_x, target_y], locx(1), locy(1), j, tx, ty);
    % history
    H = s;
    % iteriamo fino a quando il serpente non raggiunge il target, ossia fino a
    % quando non ci troviamo in uno stato terminale
    while true
         
        % scegliamo un azione tramite un metodo EPSILON-GREEDY
        a = epsgreedy(Q, s, A, epsilon);
        
        % CALCOLIAMO LO STATO SUCCESSIVO E IL REWARD
        [sp, r, ap, count_a, count_m] = snake_model_5(s, a, aprev,e, conf, point, count_a, count_m);
        count_m_p = count_m_p + count_m;

        % pause(0.1)
        % se lo stato successivo è -1, il serpente si è morso la cosa allora viene 
        % ri-inizializzato in uno stato iniziale, e riacalcolata la configurazione
        % iniziale
        if sp == -1 
            % history_P(1, e) = point_tot;
            point = 0;
            % 
            % if (punteggio(length(punteggio))~=0)
            punteggio = [punteggio, 0];
            % end
            point_tot = point_tot + point;
            
            % % if the next state is terminal Q(sp,ap) = 0
            % Q(s,a) = Q(s,a) + alpha*(r - Q(s,a)); %s(1) ci serve l testa
            %serpente ritorna nella posizione iniziale 
            %posizione iniziale serpente
            locx = [5 5 5 5 5]; %pos orizzontale
            locy = [4 5 6 7 8]; %pos verticale
            aprev = 3; %verso il basso
            % traduco le coordinate del serpente rispetto alla testa, per determinare
            % la onfigurazione
            loc_cfx = locx - locx(1);
            loc_cfy = locy - locy(1);
            config = [loc_cfx(1) loc_cfy(1);
                    loc_cfx(2) loc_cfy(2);
                    loc_cfx(3) loc_cfy(3);
                    loc_cfx(4) loc_cfy(4);
                    loc_cfx(5) loc_cfy(5)];
            j = 1;
            % determio l'indice della configurazione
            while true
                if config == conf{j}
                    break;
                else 
                    j = j+1;
                end
            end
            % disp('s = -1, ricalcolo nuovo stato iniziale')
            s = sub2ind([numrow numcol conf_snake,target_x, target_y], locx(1), locy(1), j, tx, ty);
            
            % break;
            % disp("HO MANGiato me stesso");
        % se il serpente non si è morso la cosa, allora o ha raggiunto il target
        % e quindi uno STATO TERMINALE
        % altrimenti viene aggiornata la funzione qualita e l serpente continua il
        % suo pecorso
        else
            states(sp) = states(sp)+1;
            %target preso            
            if r == 10
                point = point+1;
                punteggio = [punteggio, point];
                point_tot = point_tot + 1;
                % fprintf("\nEPISODIO %d \n", e);
                % fprintf("punteggio: %d \n",point);
                % fprintf("punteggio totale: %d \n", point_tot);
                break;
                
            else
                % stiamo il valore della funzione qualità
                
                Qp = (1-epsilon)*max(Q(sp,:)) + epsilon/A*sum(Q(sp,:));
                % aggiorniamo la funzione qualita, attravverso la legge di aggiornamento SARSA
                Q(sp,a) = Q(sp,a) + alpha*(r + gamma*Qp - Q(sp,a));
                % andiamo al prossimo stato salvando l'azione precedente
                s = sp;
                aprev = ap; 
                % add state to history
                H = [H, s];
            end
        end

    end

    if mod(e, 100) == 0
         
        epsilon = epsilon*0.9; %diminuisco epsilon
    end
    history_A(:, e) = count_a;
    history_M(1, e) = count_m;
    % history_P(1, e) = point-1;
end

%% 
figure(2)
surf(Q)
% % 
% figure
% plot(H)

%% Grafico per visualizzare quante volte prendiamo ciascuna azione
figure(3)
subplot(3,1,1)
plot(history_A','LineWidth',2)
title("Frequenza di scelta delle azioni")
legend('Destra', 'Sinistra', 'Basso', 'Alto')

% Grafico per visualizzare quante volte il serpente si morde la coda
subplot(3,1,2)
plot(history_M','LineWidth',2)
title("Frequenza con cui il serpente si morde la coda")

% Grafico per visualizzare il punteggio
subplot(3,1,3)
% plot(history_P','LineWidth',2)
plot(punteggio','LineWidth',2)
title("Storico punteggio")
%%
figure(4)
bar(states, 30)

%%
save qualita5.mat Q history_A history_M punteggio states











