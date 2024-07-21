% clc
% clear all
% close all
% [a,b] = count_snake_configurations(5)

function [count, configuration] = count_snake_configurations(snake_length)
    % Funzione per contare tutte le configurazioni del serpente di lunghezza
    % snake_length considerando cammini autoevitanti in una griglia infinita
    
    % Inizializziamo il conteggio delle configurazioni
    count = 0;

    % Inizializziamo un array di celle per salvare le configurazioni
    configuration = {};

    % Definiamo le direzioni di movimento (destra, giù, sinistra, su)
    directions = [0 1;      % destra
                  1 0;      % giù
                  0 -1;     % sinistra
                  -1 0];    % su

    % Funzione annidata per la ricerca in profondità (DFS)
    function dfs(x, y, length, visited, path)
        % Se abbiamo raggiunto la lunghezza del serpente, aggiorniamo la variabile
        % che mantiene il conto, e aggiungiamo la nuova configurazione
        if length == snake_length
            count = count + 1;
            configuration{end+1} = path;
            return;
        end
        
        % Proviamo tutte le direzioni possibili
        for d = 1:4
            new_x = x + directions(d, 1);
            new_y = y + directions(d, 2);
            
            % Verifichiamo se la nuova posizione è stata già visitata
            if ~visited(new_x + 5, new_y + 5) % Usare un offset per gestire indici negativi
                % Se non è stata visitata aggiorniamo la tabella
                visited(new_x + 5, new_y + 5) = true;
                % Facciamo un altro passo ricorsivo
                dfs(new_x, new_y, length + 1, visited, [path; new_x, new_y]);
                visited(new_x + 5, new_y + 5) = false;
            elseif length == snake_length - 1 && new_x == path(1, 1) && new_y == path(1, 2)
                % Permettiamo di tornare sulla cella di partenza solo se siamo
                % alla lunghezza snake_length - 1 (cioè alla fine del percorso)
                count = count + 1;
                configuration{end+1} = [path; new_x, new_y];
            end
        end
    end
    
    % Matrice per tenere traccia delle celle visitate (con un offset)
    visited = false(9, 9); % Inizializziamo una griglia grande abbastanza per l'offset
    visited(5, 5) = true;
    
    % Avviamo la ricerca in profondità dall'origine
    dfs(0, 0, 1, visited, [0, 0]);
end
