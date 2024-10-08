function [sp, r, ap, count_a, count_m] = snake_model_5 (s, a, prev_dir, e, config, point, count_a, count_m)
    % s -> stato, a -> direzione, prev_dir -> azione precedente, tx -> target x, ty -> target y
    % s vettore 5 componenti da cui ricaviamo locx e locy
    % sp -> stato successivo
    gg = 10000;
    t = 0.;
    % prev_dir = a;     % variabile per movimento serpente
    % points = 0;       % da passare come argomento
    direction = a; %direzione presa dopo il controllo
    
    % dimensione griglia
    numrow = 8;
    numcol = 8;
    [~, num_configurazioni] = size(config);
    target_x = numcol;
    target_y = numrow;
    % ********************* %
    % direzione 1 -> verso destra
    % direzione 2 -> verso sinitra
    % direzione 3 -> verso basso
    % direzione 4 -> verso sopra
    len_snake = 5;
    locx = zeros(1,5);
    locy = zeros(1,5);
    
    %% calcolo la posizione e comfigurazioe attuale del serpente %%
    % coordinate iniziali dei punti che costituiscono il serpente lungo x e y
    % locx = [5 5 5 5 5]; % pos orizzontale
    % locy = [3 4 5 6 7]; % pos verticale
    [locx(1), locy(1), ind_conf,tx,ty] = ind2sub([numrow numcol num_configurazioni, target_x, target_y], s);
    configurazione  = config{ind_conf};
    locx(2:end) = locx(1) + configurazione(2:end,1);
    locy(2:end) = locy(1) + configurazione(2:end,2);
    for h = 1 : length(configurazione)
        if locx(h) < 1
            locx(h) = numcol + locx(h) ;
        elseif locx(h) > numcol
            locx(h) = locx(h) - numcol;
        end

        if locy(h) < 1
            locy(h) = numrow + locy(h) ;
        elseif locy(h) > numrow
            locy(h) = locy(h) - numrow;
        end
    end
    
    len  = length(locx);
    locx(2:len)=locx(1:len-1);
    locy(2:len)=locy(1:len-1);

    % ****** CONTROLLO SULLA DIREZIONE ********%

    % *********************************************************  %
    % dobbiamo mantenere due variabli di direzione, attuale e    %
    % precedente e fare il controllo se quella precedente era    %
    % sopra, quella successiva non potrà essere sotto se esce   %
    % fuori dalla griglia                                        %
    % *********************************************************  %

    % verifico che il serpente non prenda l'azione di tornare indietro, se
    % sceglie tale azione, la direzione rimane uguale all'istante precedente

    switch direction
        % NON può tornare indietro
        case 1
            if prev_dir == 2
                direction = prev_dir;
            end
        case 2
            if prev_dir == 1
                direction = prev_dir;
            end
        case 3
            if prev_dir == 4
                direction = prev_dir;
            end
        case 4
            if prev_dir == 3
                direction = prev_dir;
            end
    end
    
    % Se esce fuori dalla griglia
    if direction == 1
        % se esce a destra, ricompare a sinistra
        if locx(1) == numcol
            locx(1) = 1;
        else
            locx(1) = locx(1)+1;
        end
    elseif direction == 2
        % se esce a sinistra, ricompare a destra
        if locx(1) == 1
            locx(1) = numcol;
        else
            locx(1) = locx(1)-1;
        end
    elseif direction == 3
        % se esce sotto, ricompare sopra
        if locy(1) == 1
            locy(1) = numrow;
        else
            locy(1) = locy(1)-1;
        end
    elseif direction == 4
        % se esce sopra, ricompare sotto
        if locy(1) == numrow
            locy(1) = 1;
        else
            locy(1) = locy(1)+1;
        end
    end
    
 
    % % Creazione della figura e impostazione delle dimensioni
    % rectangle('Position', [tx, ty, 1, 1], 'FaceColor', 'w')
    % % funzione che aggiorna la posizione del serpente
    % disegno_snake( locx, locy);

    pause(t/4);
    % color = ['m', 'b'];
    if mod(e,gg)==0
        % creo la figura su cui disegnare l'ambiente e il serpente
        figure(1)
        clf
        title(['episodio: ', num2str(e), ' - punteggio: ', num2str(point)]);
        axis equal
        axis tight
        hold on
        % dopo aver aggiornato anche la testa del serpente
        % sovrascrivo la figura precedente con la nuova posizione del serpente
        % disegno lo sforndo nero 
        rectangle('Position', [1,1,numrow,numcol], 'FaceColor', 'k')

        % disegno il target
        rectangle('Position', [tx, ty, 1, 1], 'FaceColor', 'w')

        disegno_snake( locx, locy);
    end

    % ****** FINE CONTROLLO SULLA DIREZIONE ********%
        
    

    % *************** REWARD ******************* %
    % 1)
    % se il serpente si morde da solo
    if sum((locx(2:end)==locx(1)) & (locy(2:end)==locy(1)))
       % rectangle('Position',[1,1,numrow, numcol], 'FaceColor','r');
       if mod(e,gg)==0
            % str = 'GAME OVER!';
            % dim = [.1 .4 .7 .7];
            T = annotation('textbox',[.3 .4 .5 .5],'String','GAME OVER!','FitBoxToText','on');
            T.FontSize = 28;
            T.Color = 'r';
            T.BackgroundColor = 'k';
            T.EdgeColor = 'r';
            pause(1);
       end
        % stato terminale
        sp = - 1; 
        r = - 50;
        ap = direction;
        count_m = count_m + 1;
    else
        % calcolo configurazione finale
        loc_cfx = locx - locx(1);
        loc_cfy = locy - locy(1);
        for h = 2: len_snake
            if loc_cfx(h) - loc_cfx(h-1)> len_snake
                loc_cfx(h) = loc_cfx(h) - numcol;
            elseif loc_cfx(h) - loc_cfx(h-1)< -len_snake
                loc_cfx(h) = numcol + loc_cfx(h);
            end
            if loc_cfy(h) - loc_cfy(h-1)> len_snake
                loc_cfy(h) = loc_cfy(h) - numrow;
            elseif loc_cfy(h) - loc_cfy(h-1)< -len_snake
                loc_cfy(h) = numrow + loc_cfy(h);
            end
        end
        config_end = [loc_cfx(1) loc_cfy(1);
                      loc_cfx(2) loc_cfy(2);
                      loc_cfx(3) loc_cfy(3);
                      loc_cfx(4) loc_cfy(4);  
                      loc_cfx(5) loc_cfy(5)];
        j = 1;
        while true
            if config_end == config{j}
                break;
            else
                j = j+1;
            end
        end

        % 2)
        % se il serpente mangia il target con la testa
        if sum((locx(1)==tx) & (locy(1)==ty))==1
            r = +50;
            sp = sub2ind([numrow,numcol, num_configurazioni, target_x, target_y], locx(1), locy(1),j,tx,ty);
            ap = direction;
    
        
        % 3)
        % se il serpente avanza senza commettere errori
        else
            % ricalcolo configurazione del serpente per restituire lo stato successivo
            
            % locx(2:len)=locx(1:len-1);
            % locy(2:len)=locy(1:len-1); 
            r = -1; % reward standard
            % calcolo stato successivo
            sp = sub2ind([numrow,numcol, num_configurazioni, target_x, target_y], locx(1), locy(1),j,tx,ty);
            ap = direction;
        end
    end 
    % ****** FINE REWARD ******%
    count_a(direction) = count_a(direction) + 1; 
end

