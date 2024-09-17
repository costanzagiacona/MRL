%% DESCRIZIONE SNAKE

%% MODELLO DEL SERPENTE
    % lo stato è indicato dalla posizione della testa, la configurazione del corpo e il target
    % le azioni sono quattro:
    % - destra
    % - sinistra
    % - alto 
    % - basso
    % è presente un controllo per verificare che il serpente con torni indietro
    % il serpente è sempre inzializzato con la testa verso il basso, e l'azione
    % precedente verso il basso. 
    % lo stato terminale è raggiunto quanto il serpente raggiunge il target, e
    % il punteggio viene aumentato di 1
    % se il serpente si morde la coda, il punteggio viene azzerato, e il
    % serpente viene reinizializzato nella posizione iniziale

%% REWARD
    % R = 10 -> quando il serpente raggiunge il target, ottiene un reward di 10
    % R = -5 -> se il serpente si morde la coda da solo
    % R = -1 -> reward starndard, per minimizzare il numero di passi per
    %           raggiungere il target

%% ARGORITMO SARSA
    % è un algortimo temporal difference on-policy, in cui stimiamo
    % direttamente la funzione qualità, invece della funzione valore. 
    % è un algoritmo model-free, non conosciamo l'ambiente.
    % l'algoritmo è descritto dai seguenti passi:
    %   - ci troviamo in uno stato
    %   - prendiamo l'azione che massimizza la funzione qualità
    %   - riceviamo una ricompensa e andiamo in uno stato successivo
    %   - prendiamo azione che massimizza funzione qualità rispetto allo stato successivo 
    %   - aggiorniamo la stima della funzione qualità
    
    % per evitare di fare sempre le stesse azioni, abbiamo usato una policy
    % epsilon-greedy che diminuisce ogni cento episodi. 

%% GRAFICI
    % stampiamo:
    %   - la frequenza della scelta delle azioni
    %   - il numero di volte che si morde la coda per ogni episodio
    %   - l'andamento del punteggio
    %   - quante volte è stato visitato ogni stato






















