%% GESTIONE FEATURES ATTIVE
function Fac = get_features2(s, cellPOS, cellDIR, M, N)
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
snake = s{1};    % coordinate dello snake
pos_testa = snake(1);
pos_c2 = snake(2);
pos_c3 = snake(3);
pos_c4 = snake(4);
pos_c5 = snake(5);

dir = s{2};    % direzione dello snake
pos_target = s{3}; % posizione del target


% features attive per ogni griglia
% abbiamo sei celle attive, 5 che indicano il corpo e 1 per il target
FA = zeros(N, 1);  % Matrice temporanea delle feature attive
Fac = zeros(N, 1); % Matrice finale delle feature attive

% Per ogni griglia
for i = 1:N
    % troviamo le celle di appartenenza confrontando lo stato con gli estremi delle celle
    
        indpos_testa = find(pos_testa >= cellPOS(i, 1:end-1) & pos_testa <= cellPOS(i, 2:end), 1, 'first');
        indpos_c2 = find(pos_c2 >= cellPOS(i, 1:end-1) & pos_c2 <= cellPOS(i, 2:end), 1, 'first');
        indpos_c3 = find(pos_c3 >= cellPOS(i, 1:end-1) & pos_c3 <= cellPOS(i, 2:end), 1, 'first');
        indpos_c4 = find(pos_c4 >= cellPOS(i, 1:end-1) & pos_c4 <= cellPOS(i, 2:end), 1, 'first');
        indpos_c5 = find(pos_c5 >= cellPOS(i, 1:end-1) & pos_c5 <= cellPOS(i, 2:end), 1, 'first');
        indtarget = find(pos_target >= cellPOS(i, 1:end-1) & pos_target <= cellPOS(i, 2:end), 1, 'first');

    % cella di appartenenza per la direzione
    % inddir = find(dir >= cellDIR(i, 1:end-1) & dir <= cellDIR(i, 2:end), 1, 'first');
    % cella di appartenenza per il target
   

    % indice della cella 
    % FA(i) = sub2ind([M+1 M+1 M+1 M+1 M+1 M+1 M+1 M+1 M+1 M+1 M+1 M+1], indpos_testa_x, indpos_testa_x ,...
    %                                                                     indpos_c2_x,indpos_c2_y, ...
    %                                                                     indpos_c3_x,indpos_c3_y, ...
    %                                                                     indpos_c4_x,indpos_c4_y, ...
    %                                                                     indpos_c5_x,indpos_c5_y, ...
    %                                                                     indtarget_x, indtarget_y);
    % 
      FA(i) = sub2ind([M+1 M+1 M+1 M+1 M+1 M+1], indpos_testa,indpos_c2,indpos_c3,indpos_c4,indpos_c5 , indtarget);
    
    % componente attiva finale
    % Fac(i) = FA(i) + (i-1)*(M+1)^12;
    Fac(i) = FA(i) + (i-1)*(M+1)^6;

end


% % dimension of the feature vector
% d = (M+1)^2*N;
% % feature vector
% X = zeros(d, 1);
% X(Xac) = 1;