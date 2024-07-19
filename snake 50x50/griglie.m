%% CREAZIONE DELLE GRIGLIE
%genera N griglie sovrapposte con offset [3;1] per la posizione e la direzione 
%di movimento, utili per la discretizzazione dello spazio in celle

%% mostrare le griglie
% X = [1, 20*20];
% V = [1, 4];
% 
% % parameters
% M = 5; % number of cells per grid
% N = 10; 
% [cellX, cellV] = get_cells(X, V, M, N);
% 
% % define colors
% plotColors = lines(N);
% % plot the grids
% figure()
% hold on
% for i = 1:N
%     for j = 1:M+2
%         plot([cellX(i,j), cellX(i,j)], V, 'Color', plotColors(i,:));
%         plot(X, [cellV(i,j), cellV(i,j)], 'Color', plotColors(i,:));
%     end
% end
% xlim(X)
% ylim(V)

%% Funzione
function [cellPOS, cellDIR] = griglie(POS, DIR, M, N)
% POS vettore dimensione griglia [pos_min, pos_max]
% DIR vettore numero direzioni [d_min, d_max]
% N numero di griglie sovrapposte
% M numero di celle per griglia


% Grandezza della cella lungo gli assi x e y 
wpos = (POS(2) - POS(1))/M; % larghezza delle celle per la posizione
wdir = (DIR(2) - DIR(1))/M; % larghezza delle celle per la direzione

% Creazione dei vettori di griglia per posizione e direzione
% utilizzando linspace per creare divisioni uniformi, includendo anche gli
% estremi (M+2)
% linespece -> tilecoding per una retta
posgrid = linspace(POS(1) - wpos, POS(2), M + 2);
dirgrid = linspace(DIR(1) - wdir, DIR(2), M + 2);

% Spostamento (offset) per evitare sovrapposizioni
displacement = [3; 1];% scelte arbitrarie degli spostamenti
% normalizzare lo spostamento in modo che la somma delle componenti sia 1
displacement = displacement/max(displacement);

% Definizione del movimento tra le celle per evitare sovrapposizioni
% le celle devono essere sovrapponibili ma non sovrapposte
mpos = wpos/N*displacement(1);  % spostamento per posizione
mdir = wdir/N*displacement(2);  % spostamento per direzione

% Inizializzazione delle matrici per le celle di posizione e direzione
cellPOS = zeros(N, M+2);
cellDIR = zeros(N, M+2);

% La prima griglia è già costruita
cellPOS(1,:) = posgrid;
cellDIR(1,:) = dirgrid;
% le altre griglie sono ottenute aggiungendo il movimento definito sopra
for i = 2:N
    cellPOS(i,:) = posgrid + mpos*(i-1);
    cellDIR(i,:) = dirgrid + mdir*(i-1);
end
end