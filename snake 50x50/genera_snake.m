% %% GENERA SNAKE IN UN INTORNO DEL TARGET
% function corpo = genera_snake(tx,ty, offset, muro_min, muro_max, numcol, numrow)
% % tx, ty -> posizione target
% % offset -> dimensione intorno
% % muro_min, muro_max -> posizioni muro sulla griglia
% % numcol, numrow -> dimensini griglia
% 
%     % TESTA
%     while(1)
%         %generiamo testa vicino al target
%         % fprintf("\ngenera testa")
%         testa_x = randi([tx - offset, tx + offset]);
%         testa_y = randi([ty - offset, ty + offset]);
%         %controllo testa non esca fuori dallo spazio di lavoro
%         if testa_x >= 1 && testa_x <= numcol && testa_y >= 1 && testa_y <= numrow
%             % fprintf("testa = [%d , %d]", testa_x, testa_y);
%             test = controllo_muro50x50(testa_x, testa_y, muro_min, muro_max, numcol, numrow);
%             % controllo testa non sui muri e non sul target
%             if test == false && (testa_x ~= tx || testa_y ~= ty)   
%                 break;
%             end
%         end
%         %controlliamo che non sia sovrapposta al muro
% 
%     end
% 
%     %generiamo tutte le possibili configurazioni
%     [count, configurations] = configurazioni(5);
% 
%     % Array per tenere traccia delle configurazioni testate
%     tested = false(1, count);
%     % num_tested = 0;
%     global num_tested;
% 
%     %CORPO
%     while(1)
%         if num_tested == count
%             error('Non ci sono configurazioni valide disponibili.');
%         end
%         %prendiamo una configurazione random (qui testa sta in [0,0])
%         % fprintf("genera snake\n")
%         % ind = randi(count); % indice configurazione
% 
%         % Prendiamo una configurazione random non ancora testata
%         while (1)
%             ind = randi(count); % Indice configurazione
%             if ~tested(ind)
%                 tested(ind) = true;
%                 num_tested = num_tested + 1;
%                 break;
%             end
%         end
% 
%         conf = configurations{ind};%configurazione
%         % calcoliamo la posizione del corpo rispetto alla testa 
%         corpo(:,1) = conf(:,1) + testa_x; % x
%         corpo(:,2) = conf(:,2) + testa_y; % y
%         %controlliamo che il corpo non sbatta sui muri o sia sul target
%         for i = 2: size(corpo, 1)
%             test = controllo_muro50x50(corpo(i,1), corpo(i,2), muro_min, muro_max, numcol, numrow);
%             if test == true || ~(corpo(i,1) ~= tx && corpo(i,2) ~= ty)
%                 break;
%             end
% 
%         end
%         %se abbiamo eseguito il controllo su tutto il corpo e non ci sono
%         %stati errori 
%         if i == 5
%             break;
%         end
% 
%     end
% 
%     %controllo che il serpente non esca fuori dallo spazio di lavoro (testa verificata sopra)
%     % se il serpente esce dalla grigli riappare sul lato opposto
%     for i = 1:size(corpo,1)
% 
%         % controllo sulla x
%         if corpo(i,1)>numcol %esce a dx
%             fprintf("x(%d) > numcol", i);
%             corpo(i,1) = corpo(i,1)-numcol; %compare a sx
%         elseif corpo(i,1) < 1 %esce a sx
%             fprintf("x(%d) < 1", i);
%             corpo(i,1) = numcol + corpo(i,1); %compare a dx
%         end
% 
%         % controllo sulla y
%         if corpo(i,2)>numrow %esce sopra
%             fprintf("y(%d) > numrow", i);
%             corpo(i,2) = corpo(i,2)-numrow;
%         elseif corpo(i,2) < 1 %esce sotto
%             fprintf("y(%d) < 1", i);
%             corpo(i,2) = numrow + corpo(i,2);
%         end
% 
% 
%     end
        
% end

function corpo = genera_snake(tx, ty, offset, muro_min, muro_max, numcol, numrow)
% tx, ty -> posizione target
% offset -> dimensione intorno
% muro_min, muro_max -> posizioni muro sulla griglia
% numcol, numrow -> dimensini griglia

    % TESTA
    while(1)
        % generiamo testa vicino al target
        testa_x = randi([tx - offset, tx + offset]);
        testa_y = randi([ty - offset, ty + offset]);
        % controllo testa non esca fuori dallo spazio di lavoro
        if testa_x >= 1 && testa_x <= numcol && testa_y >= 1 && testa_y <= numrow
            test = controllo_muro50x50(testa_x, testa_y, muro_min, muro_max, numcol, numrow);
            % controllo testa non sui muri e non sul target
            if test == false && (testa_x ~= tx || testa_y ~= ty)   
                break;
            end
        end
    end
    testa_x
    testa_y
    % generiamo tutte le possibili configurazioni
    [count, configurations] = configurazioni(5);

    % Array per tenere traccia delle configurazioni testate
    tested = false(1, count);
    global num_tested;
    num_tested = 0;

    % CORPO
    while(1)
        if num_tested == count
            error('Non ci sono configurazioni valide disponibili.');
        end

        % Prendiamo una configurazione random non ancora testata
        while (1)
            ind = randi(count); % Indice configurazione
            if ~tested(ind)
                tested(ind) = true;
                num_tested = num_tested + 1;
                break;
            end
        end

        conf = configurations{ind}; % configurazione
        % calcoliamo la posizione del corpo rispetto alla testa 
        corpo(:,1) = conf(:,1) + testa_x; % x
        corpo(:,2) = conf(:,2) + testa_y; % y
        
        % Aggiungere stampe di debug
        % fprintf('Testando configurazione %d\n', ind);
        % fprintf('Testa: (%d, %d)\n', testa_x, testa_y);
        % disp('Corpo:');
        % disp(corpo);
        % 
        % controlliamo che il corpo non sbatta sui muri o sia sul target
        valido = true;
        for i = 2:size(corpo, 1)
            test = controllo_muro50x50(corpo(i,1), corpo(i,2), muro_min, muro_max, numcol, numrow);
            if test == true || (corpo(i,1) == tx && corpo(i,2) == ty) || (corpo(i,1)==corpo(1,1) && corpo(i,2)==corpo(1,2)) 
                valido = false;
                break;
            end
        end

        % Stampare se la configurazione è valida o meno
        % fprintf('Valido: %d\n', valido);
        
        if valido
            break;
        end
    end
    
    % controllo che il serpente non esca fuori dallo spazio di lavoro (testa verificata sopra)
    for i = 1:size(corpo, 1)
        % controllo sulla x
        if corpo(i,1) > numcol % esce a dx
            corpo(i,1) = corpo(i,1) - numcol; % compare a sx
        elseif corpo(i,1) < 1 % esce a sx
            corpo(i,1) = numcol + corpo(i,1); % compare a dx
        end

        % controllo sulla y
        if corpo(i,2) > numrow % esce sopra
            corpo(i,2) = corpo(i,2) - numrow;
        elseif corpo(i,2) < 1 % esce sotto
            corpo(i,2) = numrow + corpo(i,2);
        end
    end
end
