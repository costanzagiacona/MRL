%% GENERAZIONE TARGET

function target = genera_target50x50(muro_min, muro_max, numcol,numrow)
    while(1)
        % randperm genera un numero casuale preso tra 1 e size(mat_r)
        tx = randperm(numrow,1); % coordinata casuale x
        ty = randperm(numcol,1); % coordinata casuale y
        
        % se il target ha le stesse coordinate del serpente
        % o se il targer è sul muro, , non è valido
        if ~controllo_muro50x50(tx,ty, muro_min, muro_max, numcol, numrow) 
            break
        end
    end

target = sub2ind([numrow numcol], tx,ty);
end