%% SERPENTE LUNGHEZZA 5

clear all
close all
clc
% qualita.mat contiene la funzione qualita addestrando l'algorimo con
% reward 10 se otteniamo il target, -1 per ogni passo e -5 se si morde
% load qualita5.mat
% load qualita6.mat
load qualita7.mat
% inizializziamo i parametri per l'algoritmo SARSA
gamma = 1;
% alpha = 1e-1;
alpha = 0.1;
numEpisodes = 1e6;
epsilon = 0.1;

% definiao le dimesioni della griglia di gioco
numrow = 8;
numcol = 8;

% possibili coordinate del target
target_x = 8;
target_y = 8;

gg = 1000;

% i vari stati del serpente dipendono dalla posizione della testa, dalla
% configurazione del corpo e dalla posizione del target
[conf_snake,conf] = count_snake_configurations(5);
S = numrow*numcol*conf_snake*target_x*target_y;
% le azioni possibili sono quattro:
% UP, DOWN, LEFT, RIGHT
A = 4;
% tic

% Contatori
count_a = zeros(4, 1);              % contatore azioni
count_m = 0;                        % contatore per quando il serpente si morde da solo
count_m_p = 0;                      % contatore per quando il serpente muore da usare nel punteggio
point = 0;                          % contatore punti
point_tot = 0;                      % andamento del punteggio

% Statistiche 
% history_M = zeros(1, numEpisodes);        % storico frequenza morsi
% history_P = zeros(1, numEpisodes);        % storico dei punteggi
% history_m = [];
% punteggio = [];
% history_A = zeros(A, numEpisodes);
% states = zeros(1, S);                     % vettore degli stati
% 
% Q = zeros(S, A);    % initialize Q function

% iterazione ricorsiva per ogni episodio
for e = 1:numEpisodes
    count_m = 0; % ad ogni episodio azzero il contatore
    % disp(e)
    if mod(e,gg) == 0
        disp(e)
    end
    % definiamo la posizione iniziale serpente
    locx = [5 5 5 5 5]; % coordinate orizzontali
    locy = [4 5 6 7 8]; % coordinate verticali
    aprev = 3; % inizializziamo la direzione iniziale, visto 
               % l'orientamento iniziale del serpente, scegliamo sempre sotto 
    
    % calcoliamo la configurazione del serpente, da confrontare con la lista
    % che abbiamo a disposizione. La testa del serpente si trova sempre in
    % posizione (0,0)
    loc_cfx = locx - locx(1);
    loc_cfy = locy - locy(1);
    config = [loc_cfx(1) loc_cfy(1);
              loc_cfx(2) loc_cfy(2);
              loc_cfx(3) loc_cfy(3);
              loc_cfx(4) loc_cfy(4);
              loc_cfx(5) loc_cfy(5)];
    j = 1;
    % confontiamo la configurazione ottenuta con la lista, fino a quando non
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
    % ossia fino a quando il target ha coordinate diverse dal serpente
    while(1)
        % posizione target
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
    a = epsgreedy(Q, s, A, epsilon);
    while true
         
        % scegliamo un azione tramite un metodo EPSILON-GREEDY
        
        
        % CALCOLIAMO LO STATO SUCCESSIVO E IL REWARD
        [sp, r, ap, count_a, count_m] = snake_model_5(s, a, aprev, e, conf, point, count_a, count_m);
        count_m_p = count_m_p + count_m;

        % pause(0.1)
        % se lo stato successivo è -1, il serpente si è morso la cosa allora viene 
        % ri-inizializzato in uno stato iniziale, e ricalcolata la configurazione
        % iniziale
        if sp == -1 
            % history_P(1, e) = point_tot;
            point = 0;
            punteggio = [punteggio, 0];
            history_m = [history_m count_m];
            point_tot = point_tot + point;
            % serpente ritorna nella posizione iniziale 
            locx = [5 5 5 5 5]; % pos orizzontale
            locy = [4 5 6 7 8]; % pos verticale
            aprev = 3; % verso il basso
            % traduco le coordinate del serpente rispetto alla testa, per determinare
            % la configurazione
            loc_cfx = locx - locx(1);
            loc_cfy = locy - locy(1);
            config = [loc_cfx(1) loc_cfy(1);
                    loc_cfx(2) loc_cfy(2);
                    loc_cfx(3) loc_cfy(3);
                    loc_cfx(4) loc_cfy(4);
                    loc_cfx(5) loc_cfy(5)];
            j = 1;
            % determino l'indice della configurazione
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
        % se il serpente non si è morso la coda, allora o ha raggiunto il target
        % e quindi uno STATO TERMINALE
        % altrimenti viene aggiornata la funzione qualita e il serpente continua il
        % suo pecorso
        else
            states(sp) = states(sp)+1;
            %target preso            
            if r == 50
                point = point+1;
                punteggio = [punteggio, point];
                point_tot = point_tot + 1;
                Q(s,a) = Q(s,a) + alpha*(r-Q(s,a));
                % fprintf("\nEPISODIO %d \n", e);
                % fprintf("punteggio: %d \n",point);
                % fprintf("punteggio totale: %d \n", point_tot);
                break;
                
            else
                % stimo il valore della funzione qualità        
                % Qp = (1-epsilon)*max(Q(sp,:)) + epsilon/A*sum(Q(sp,:));
                a_next = epsgreedy(Q,sp,A,epsilon);
                % aggiorniamo la funzione qualita, attraverso la legge di aggiornamento SARSA
                Q(s,a) = Q(s,a) + alpha*(r + gamma*Q(sp,a_next) - Q(s,a));
                % andiamo al prossimo stato salvando l'azione precedente
                s = sp;
                aprev = ap; 
                a =a_next;
                % add state to history
                % H = [H, s];
            end
        end

    end

    if mod(e, 1000) == 0
        epsilon = epsilon*0.8; % diminuisco epsilon
    end
    history_A(:, e) = count_a;
    % history_M(1, e) = count_m;
    % history_P(1, e) = point-1;
end

%% Grafico per visualizzare quante volte prendiamo ciascuna azione
figure(3)
subplot(3,1,1)
plot(history_A','LineWidth',2)
% xlim([0, e]);
title("Frequenza di scelta delle azioni")
legend('Destra', 'Sinistra', 'Basso', 'Alto')

% Grafico per visualizzare quante volte il serpente si morde la coda
subplot(3,1,2)
plot(history_m,'LineWidth',2)
title("Frequenza con cui il serpente si morde la coda")
 
% Grafico per visualizzare il punteggio
subplot(3,1,3)
% plot(history_P','LineWidth',2)
plot(punteggio','LineWidth', 2) 
title("Storico punteggio")

figure(4)
bar(states, 1000)

%%
figure(5)
episodes = 1:length(punteggio);                                  
degree = 3;  
[coefficients, S, mu] = polyfit(episodes, punteggio, degree);  % Fit con centering e scaling
polynomial_fit = polyval(coefficients, episodes, [], mu);      % Valuta il polinomio con i dati scalati

hold on;
plot(episodes, polynomial_fit, '-r', 'LineWidth', 2); % Curva di fit polinomiale
xlabel('Episodi');
ylabel('Punteggio');
title('Andamento crescente del punteggio con fit polinomiale');
grid on;
legend('Fit Polinomiale');
hold off;


%% cambiato momentaneamente quaita 7
save qualita7.mat Q history_A history_m punteggio states count_a 