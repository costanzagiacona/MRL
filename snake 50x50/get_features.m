%% GESTIONE FEATURES ATTIVE
function Fac = get_features(s, cellPOS, cellDIR, M, N)
% per ogni griglia ho una cella attiva
% Input:
% - s: un vettore di celle dove s{1} contiene le coordinate dello snake,
%      s{2} contiene la direzione dello snake,
%      s{3} contiene la posizione del target
% - cellPOS: definisce i limiti delle celle per la posizione
% - cellDIR: definisce i limiti delle celle per la direzione
% - M: numero di celle per griglia.
% - N: numero di griglie.
% Output:
% - Fac: matrice delle feature attive di dimensioni (N x 6).

% Estrazione informazioni dallo stato
pos = s{1};    % coordinate dello snake
dir = s{2};    % direzione dello snake
target = s{3}; % posizione del target


% features attive per ogni griglia
% abbiamo sei celle attive, 5 che indicano il corpo e 1 per il target
FA = zeros(N, 6);  % Matrice temporanea delle feature attive
Fac = zeros(N, 6); % Matrice finale delle feature attive

% Per ogni griglia
for i = 1:N
    % troviamo le celle di appartenenza confrontando lo stato con gli estremi delle celle
    for j = 1:5
        indpos(j) = find(pos(j) >= cellPOS(i, 1:end-1) & pos(j) <= cellPOS(i, 2:end), 1, 'first');
    end
    % cella di appartenenza per la direzione
    inddir = find(dir >= cellDIR(i, 1:end-1) & dir <= cellDIR(i, 2:end), 1, 'first');
    % cella di appartenenza per il target
    indtarget = find(target >= cellPOS(i, 1:end-1) & target <= cellPOS(i, 2:end), 1, 'first');

    % indice della cella 
    for j = 1:5
        FA(i,j) = sub2ind([M+1 M+1 M+1], indpos(j), inddir, indtarget);
    end
    % componente attiva finale
    for j = 1:6
        Fac(i,j) = FA(i,j) + (i-1)*(M+1)^3;
    end
end
disp(FA);

% % dimension of the feature vector
% d = (M+1)^2*N;
% % feature vector
% X = zeros(d, 1);
% X(Xac) = 1;