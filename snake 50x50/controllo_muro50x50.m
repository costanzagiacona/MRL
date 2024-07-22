%% Funzione controllo muro colpito 
function bool = controllo_muro50x50(x, y, muro_min, muro_max, numcol, numrow)
% locx, locy -> posizione serpente
% muro_min, muro_max -> posizioni muro sulla griglia
% numcol, numrow -> dimensini griglia
    
    % controllo sui muri esterni
    if ((x == numcol && (y>=muro_min && y<=muro_max) ...
            || (x == 1 && (y>=muro_min && y<=muro_max)) ...
            || (y == numrow && (x>=muro_min && x<=muro_max)) ...
            || (y == 1 && (x>=muro_min && x<=muro_max))))
        bool = true;
        % fprintf('muro esterno colpito\n');

    % controllo sui muri interni
    elseif ((x == 34 && ((y>=muro_min && y<=muro_min+4) || (y>=muro_max-4 && y<=muro_max))) ...
            || (x == 15 && ((y>=muro_min && y<=muro_min+4) || (y>=muro_max-4 && y<=muro_max))) ...
            || (y == 34 && ((x>=muro_min && x<=muro_min+4) || (x>=muro_max-4 && x<=muro_max))) ...
            || (y == 15 && ((x>=muro_min && x<=muro_min+4) || (x>=muro_max-4 && x<=muro_max))))
    % elseif ((x == 34 && ((y>=15 && y<=19) || (y>=30 && y<=34))) ...
    %         || (x == 15 && ((y>=15 && y<=19) || (y>=30 && y<=34))) ...
    %         || (y == 34 && ((x>=15 && x<=19) || (x>=30 && x<=34))) ...
    %         || (y == 15 && ((x>=15 && x<=19) || (x>=30 && x<=34))))
        bool = true;
        % fprintf('muro interno colpito\n');
        
    else
        bool = false;

    end

    %% Commenti

    %%% muro esterno %%%
    % se locx == numcol  -> muro a destra
    % con locy controlliamo altezza muro
    % se locx == 1 -> muro a sinistra
    % con locy controlliamo altezza muro
    % se locy == numrow -> muro in alto
    % con locx controlliamo lunghezza muro
    % se locy == 1 -> muro in basso
    % con locx controlliamo lunghezza muro


    %%% muro interno %%%
    % se locx == 34 -> muri a destra
    % con (locy>=muro_min && locy<=muro_min+4) controllo muro verticale in basso
    % con (locy>=muro_max-4 && locy<=muro_max) controllo muro verticale in alto
    % se locx == 15 -> muri a sinistra
    % il controllo segue la logica di prima
    % se locy == 34 -> muri in alto
    % con (locx>=muro_min && locx<=muro_min+4) controllo muro orizzontale in alto
    % con (locx>=muro_max-4 && locx<=muro_max) controllo muro orizzontale in alto


