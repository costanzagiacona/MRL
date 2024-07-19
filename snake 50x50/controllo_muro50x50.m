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
    elseif ((x == 35 && ((y>=muro_min && y<=muro_min+5) || (y>=muro_max-5 && y<=muro_max))) ...
            || (x == 15 && ((y>=muro_min && y<=muro_min+5) || (y>=muro_max-5 && y<=muro_max))) ...
            || (y == 35 && ((x>=muro_min && x<=muro_min+5) || (x>=muro_max-5 && x<=muro_max))) ...
            || (y == 15 && ((x>=muro_min && x<=muro_min+5) || (x>=muro_max-5 && x<=muro_max))))
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
    % se locx == 75 -> muri a destra
    % con (locy>=muro_min && locy<=muro_min+15) controllo muro verticale in basso
    % con (locy>=muro_max-15 && locy<=muro_max) controllo muro verticale in alto
    % se locx == 25 -> muri a sinistra
    % il controllo segue la logica di prima
    % se locy == 75 -> muri in alto
    % con (locx>=muro_min && locx<=muro_min+15) controllo muro orizzontale in alto
    % con (locx>=muro_max-15 && locx<=muro_max) controllo muro orizzontale in alto


