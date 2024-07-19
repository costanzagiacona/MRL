% % driving race
clc
close all
% Definiamo le dimensioni della griglia
lengthGrid = 25;
heightGrid = 25;
griglia = zeros(heightGrid, lengthGrid); % Inizializziamo la griglia con zeri

% Inizializziamo le variabili di controllo
h = 0;
count = 0;
k = 3;
count_incr = 0;
incr = 0;
% creiamo la struttura della strada, come una matrice di 1 e 0
% le posizioni con 1 caratterizzano un punto della strada, dove la macchina
% può passare. Gli 0 sono punti esterni a tale strada

for i = heightGrid:-1:2 % Scorriamo tutta l'altezza della griglia dall'alto verso il basso
    if (i > round(heightGrid/0.9)) % Se siamo nella parte superiore della griglia
        for j = 5:lengthGrid-15 % Definiamo una sezione della strada
            griglia(i,j) = 1; % Impostiamo questi punti come parte della strada
        end
    else % Altrimenti, per le parti inferiori della griglia
        count_incr = count_incr +1;
        count = count +1;    % ad ogni passo in altezza incrementiamo count
        if count == k        % ogni k passi,  incrementiamo h
            h = h+incr; 
            count = 0;      % e azzeriamo il conto
        end
        if (k >1)   % il numero di passi per decidere ogni quanto modificare h, viene diminuito ad ogni iterazione
            k = k-1;
        end
        if (count_incr ==3) % ogni 5 passi, aumentiamo il valore con cui 
                            % incrementiamo le variabili,k questo serve per fare vla pista piu curva
            incr = incr +1;
            count_incr = 0;
        end
        
         % Definiamo la strada con spostamento orizzontale
         % per ogni passo in altezza, disegnamo la strada
         % ogni tratto orizzontale che diegnamo trasla orizzontalemente verso
         % destra, tale traslazione è controllata dalla variabile h, che determina l
         % primo e l'ultimo punto del tratto orizzntale
         % modificando h/5 e/o 0.4*h si allarga o restringe la fine della curva
         
        for j = 5+round(h/5):min(lengthGrid-15+round(0.3*h), lengthGrid)
            % disp('1')
            if j == lengthGrid
                % linea rossa
                % se la coordinata corrisponde con il bordo della matrice, stiamo a fie
                % pista
                griglia(i,j) = 2;% Impostiamo una linea rossa (fine pista)
            else
                griglia(i,j) = 1; % Impostiamo la strada
            end
           
        end
    end
    
end
% Impostiamo la partenza della strada
griglia(heightGrid,5:lengthGrid-15) = 3*ones;

% griglia = resize(griglia,[25 25])
figure

% Definiamo i colori per la visualizzazione
background = [0, 0, 0]; % Nero
white = [1, 1, 1]; % Bianco
red = [1, 0, 0]; % Rosso
green = [0, 1, 0]; % Verde

% Impostiamo la mappa dei colori
colormap([background; white; red; green]);

% Visualizziamo la griglia
grid = imagesc(griglia);

% Salviamo la griglia e la struttura 'grid' in un file .mat
save grid.mat grid griglia















