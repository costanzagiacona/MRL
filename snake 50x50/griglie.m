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
wpos_testa = (POS(2) - POS(1))/M; % larghezza delle celle per la posizione
wdir = (DIR(2) - DIR(1))/M; % larghezza delle celle per la direzione
wpos_c2 = (POS(2) - POS(1))/M; 
wpos_c3 = (POS(2) - POS(1))/M; 
wpos_c4 = (POS(2) - POS(1))/M; 
wpos_c5 = (POS(2) - POS(1))/M; 
wpos_target = (POS(2) - POS(1))/M; 
% Creazione dei vettori di griglia per posizione e direzione
% utilizzando linspace per creare divisioni uniformi, includendo anche gli
% estremi (M+2)
% linespece -> tilecoding per una retta
posgrid_testa = linspace(POS(1) - wpos_testa, POS(2), M + 2);
posgrid_c2 = linspace(POS(1) - wpos_c2, POS(2), M + 2);
posgrid_c3 = linspace(POS(1) - wpos_c3, POS(2), M + 2);
posgrid_c4 = linspace(POS(1) - wpos_c4, POS(2), M + 2);
posgrid_c5 = linspace(POS(1) - wpos_c5, POS(2), M + 2);
posgrid_target = linspace(POS(1) - wpos_target, POS(2), M + 2);
dirgrid = linspace(DIR(1) - wdir, DIR(2), M + 2);

% Spostamento (offset) per evitare sovrapposizioni
displacement = [3; 1];% scelte arbitrarie degli spostamenti
% normalizzare lo spostamento in modo che la somma delle componenti sia 1
displacement = displacement/max(displacement);

% Definizione del movimento tra le celle per evitare sovrapposizioni
% le celle devono essere sovrapponibili ma non sovrapposte
mpos_testa = wpos_testa/N*displacement(1);  % spostamento per posizione
mpos_c2 = wpos_c2/N*displacement(1);
mpos_c3 = wpos_c3/N*displacement(1);
mpos_c4 = wpos_c4/N*displacement(1);
mpos_c5 = wpos_c5/N*displacement(1);

mpos_target = wpos_target/N*displacement(1);
mdir = wdir/N*displacement(2);  % spostamento per direzione

% Inizializzazione delle matrici per le celle di posizione e direzione
cellPOS_testa = zeros(N, M+2);
cellPOS_c2 = zeros(N, M+2);
cellPOS_c3 = zeros(N, M+2);
cellPOS_c4 = zeros(N, M+2);
cellPOS_c5 = zeros(N, M+2);
cellPOS_target = zeros(N, M+2);
cellDIR = zeros(N, M+2);

% La prima griglia è già costruita
cellPOS_testa(1,:) = posgrid_testa;
cellPOS_c2(1,:) = posgrid_c2;
cellPOS_c3(1,:) = posgrid_c3;
cellPOS_c4(1,:) = posgrid_c4;
cellPOS_c5(1,:) = posgrid_c5;
cellPOS_target(1,:) = posgrid_target;
cellDIR(1,:) = dirgrid;
% le altre griglie sono ottenute aggiungendo il movimento definito sopra
for i = 2:N
    cellPOS_testa(i,:) = posgrid_testa + mpos_testa*(i-1);
    cellPOS_c2(i,:) = posgrid_c2 + mpos_c2*(i-1);
    cellPOS_c3(i,:) = posgrid_c3 + mpos_c3*(i-1);
    cellPOS_c4(i,:) = posgrid_c4 + mpos_c4*(i-1);
    cellPOS_c5(i,:) = posgrid_c5 + mpos_c5*(i-1);
    cellPOS_target(i,:) = posgrid_target + mpos_target*(i-1);
    cellDIR(i,:) = dirgrid + mdir*(i-1);
end
cellPOS = [cellPOS_testa, cellPOS_c2,cellPOS_c3, cellPOS_c4,cellPOS_c4,cellPOS_target];
% cellPOS = [cellPOS_testa,cellPOS_target];

end