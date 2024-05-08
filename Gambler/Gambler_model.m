clear all
close all
clc


%genera stessi numeri casuali
%rng(1);

%soldi disponibili inizialmente
cash = 100;
scommessa = 0;

%numero di stati
S = cash + 1; %c'è anche lo stato 0
%azioni- scommetti su testa o su croce
A = cash - 1; %non possiamo scommettere se siamo a 100
%A = 100;

%scommessa = randi(cash); %numero casuale da 1 a s (soldi disponibili)

%% probabilità

%prob vincere con testa 0.5
%prob vincere con croce 0.5
P = 0.5; %perche moneta

%% probabilità transizione

Pt = zeros(S,S,A); %inizializzo matrice SxS'xA
for a = 1:A
    for s = 1: S
    %indice
    [r, c] = ind2sub([S,S],s); % r stato attuale
    %r soldi con cui inizio a giocare
    r = r - 1; %matlab conta da 1

    if (r == 0 || r == cash) %stato terminale
        r1 = r +1; %perchè nella matrice contiamo da 1
        next_s = sub2ind([S S], r1, c);%calcolo dello stato successivo
        %rimango nella stessa colonna perchè non scommetto
        Pt (s,next_s,a) = 1;
    
    else
        %posso scommettere e con prob 0.5 vado in uno stato e con prob 0.5
        %in un altro

        %posso scommettere al massimo il denaro che possiedo
        %a è l'azione, quindi quanto voglio scommettere
        scommessa = min(a,r); %soldi scommessi

        %se vinco
        r1 = min(r+1+scommessa, S); %S perchè non posso superare 100, +1 perchè matlab conta da 1
        % se perdo
        r2 = max(r+1-scommessa, 1); %1 perchè consideriamo da 1 a 101 perchè nella matrice contiamo da 1

        %ci spostiamo nel nuovo stato in caso di vittoria
        next_s1 = sub2ind([S S], r1, c);
         %ci spostiamo nel nuovo stato in caso di sconfitta
        next_s2 = sub2ind([S S], r2, c);

        %probabilità di arrivare nel nuovo stato
        Pt(s,next_s1,a) = P; %vittoria
        Pt(s,next_s2,a) = P; %sconfitta

     end
    end
 end



%% reward
% ho reward solo se >= 100 o perdo <= 0
guadagno = zeros(S,1); %vettore lungo S

for s = 1:S
    if (s == 1) %stato 0 soldi
        guadagno(s) = -1; %perso
    elseif (s == S) %stato 100 soldi
        guadagno(s) = 1;
    end
    %tutti gli altri stati intermedi hanno guadagno 0
end


%matrice reward
%studiamo una riga alla volta
R = zeros(S,A);
for a = 1:A %per ogni azione, per ogni colonna
    R(:,a) = Pt(:,:, a)* guadagno; %valore atteso
end
   
% nello stato 0 soldi
R (1, :) = 0;
%nello stato 100 soldi
R(S, :) = 0;


%%
save gambler_model.mat Pt R S A
