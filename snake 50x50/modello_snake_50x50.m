%% MODELLO DEL SISTEMA
%calcola il nuovo stato del serpente e il reward associato all'azione da intraprendere

function [sp, r, muro] = modello_snake_50x50 (s, a, POS, DIR, e, point, muro, muro_min, muro_max)
    % s -> stato, lista contenete locx e locy, la direzione e il target
    % a -> direzione scelta tramite azione greedy
    % e -> episodio corrente
    % point -> punteggio corrente
    % out
    % sp -> stato successivo
    % r -> reward
    % muro_min = 15;
    % muro_max = 34;
    % lung_int = 10;
    % lung_ext = 20;
    % Assegna la direzione passata come azione
    direction = a; %azione greedy
    % ***************************** %
    % direzione 1 -> verso destra
    % direzione 2 -> verso sinitra
    % direzione 3 -> verso basso
    % direzione 4 -> verso sopra
    % ***************************** %
    
    % Dimensione della griglia
    numrow = 50;
    numcol = 50;

    % Parametri corpo serpente
    locx = zeros(1, 5);
    locy = zeros(1, 5);

    gg = 100;

    global num_tested;
    %% Calcolo la posizione e configurazione attuale del serpente dallo stato s %%
    
    %posizione serpente
    pos = s{1};

    for i =1:5
        [locx(i), locy(i)] = ind2sub([numrow numcol], pos(i));
    end
    len_snake  = length(locx);

    %direzione precedente
    prev_dir = s{2};

    %posizione target
    [tx, ty] = ind2sub([numrow numcol], s{3});
   
    
    % fa il passo avanti del serpente
    locx(2:len_snake)=locx(1:len_snake-1);
    locy(2:len_snake)=locy(1:len_snake-1);

    % ****** CONTROLLO SULLA DIREZIONE ******** %

    % ****************************************************** %
    % manteniamo due variabli di direzione, attuale e        %
    % precedente,  per verificare che il serpente non prenda %
    % l'azione di tornare indietro, se sceglie tale azione,  %
    % la direzione rimane uguale all'istante precedente      %                                    
    % ****************************************************** %

    %NON può tornare indietro
    switch direction
        case 1
            if prev_dir ==2
                direction = prev_dir;
            end
        case 2
            if prev_dir ==1
                direction = prev_dir;
            end
        case 3
            if prev_dir ==4
                direction = prev_dir;
            end
        case 4
            if prev_dir ==3
                direction = prev_dir;
            end
    end
    
    %SE ESCE FUORI DALLA GRIGLIA
    if direction==1
        % se esce a destra, ricompare a sinistra
        if locx(1)== numcol 
            locx(1)=1;
        else
            locx(1)=locx(1)+1;
        end
    elseif direction==2
        % se esce a sinistra, ricompare a destra
        if locx(1)==1
            locx(1)=numcol;
        else
            locx(1)=locx(1)-1;
        end
    elseif direction==3
        % se esce sotto, ricompare sopra
        if locy(1)==1
            locy(1)=numrow;
        else
            locy(1)=locy(1)-1;
        end
    elseif direction==4
        % se esce sopra, ricompare sotto
        if locy(1)==numrow
            locy(1)=1;
        else
            locy(1)=locy(1)+1;
        end
    end

     % ****** FINE CONTROLLO SULLA DIREZIONE ******** %


     % ****** PLOT GIOCO SERPENTE ******** %
    if mod(e,gg)==0
        % pause(t/5);
        %%% AMBIENTE %%%
        figure(1)
        clf
        title(['episodio ' , num2str(e), ' punteggio: ', num2str(point)]);
        axis equal
        axis tight
        hold on
        % dopo aver aggiornato anche la testa del serpente
        % sovrascrivo la figura precedente con la nuova posizione del serpente
        % disegno lo sfondo nero 
        rectangle('Position', [1,1,numrow,numcol], 'FaceColor', 'k')

        %%% TARGET %%%
        rectangle('Position', [tx, ty, 1, 1], 'FaceColor', 'w')
       
        %%% MURI ESTERNI %%%
        % muro in basso
        rectangle('Position',[15,1,20,1], 'FaceColor','b');
        % muro in alto
        rectangle('Position',[15,numrow,20,1], 'FaceColor','b');
        % muro a sinistra
        rectangle('Position',[1,15,1,20], 'FaceColor','b');
        % muro a destra
        rectangle('Position',[numcol,15,1,20], 'FaceColor','b');

        %%% MURI INTERNI %%%
        % segmenti verticali ----
        % basso destra 
        rectangle('Position',[34,15,1,5], 'FaceColor','b');
        % alto a destra 
        rectangle('Position',[34,30,1,5], 'FaceColor','b');
        % basso sinistra 
        rectangle('Position',[15,15,1,5], 'FaceColor','b');
        % alto sinistra 
        rectangle('Position',[15,30,1,5], 'FaceColor','b');
        % segmenti orizzontali ----
        % alto a sinistra
        rectangle('Position',[15,34,5,1], 'FaceColor','b');
        % alto a destra
        rectangle('Position',[30,34,5,1], 'FaceColor','b');
        % basso sinistra
        rectangle('Position',[15,15,5,1], 'FaceColor','b');
        % alto sinistra
        rectangle('Position',[30,15,5,1], 'FaceColor','b');
        
        %%% SERPENTE %%%
        disegno_snake(locx, locy);
    end
   
   
    pos_fin = zeros(1,len_snake);
    for i = 1:len_snake
        pos_fin(i) = sub2ind([numrow numcol], locx(i), locy(i));
    end
    
    

    % *************** REWARD ******************* %
    variabile = controllo_muro50x50(locx(1), locy(1), muro_min, muro_max, numcol, numrow);
    %%%%%%%  se il serpente si morde la coda %%%%%%%
    if sum((locx(2:end)==locx(1)) & (locy(2:end)==locy(1))) 
       
      game_over(e,gg);
        
       r = -5;
       % sp = -1; 
       sp = {pos_fin, direction,s{3}};
        
    % se il serpente tocca il muro
    elseif variabile == true
        % fprintf("muro toccato")
        muro = muro + 1;
        num_tested = 0;
        game_over(e,gg);
        
        pause(1);
        % disp(100)
        r = -5;
        % sp = -1; 
        sp = {pos_fin, direction,s{3}};
        
        
    else
        %%%%%%% se il serpente mangia il target con la testa %%%%%%%
        if sum((locx(1)==tx) & (locy(1)==ty))==1
            r = +5;
            % è uno stato terminale
            sp = {pos_fin, direction,s{3}};
            % sp = -1;
            isTerminal = 0;
           
    
        
        %%%%%%% se il serpente avanza senza commettere errori %%%%%%%
        else 
            r = -1; %reward standard
            %calcolo stato successivo
            sp = {pos_fin, direction,s{3}};
            isTerminal = 1;
    end 
% ****** FINE REWARD ******%
    
end

