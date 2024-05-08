clear all
close all
clc
load grid.mat

Vx = 6; %velocità va da 0 a 5
Vy = 6;
D = 50; %dimensione griglia
posizione = D*D;

S = posizione * Vx*Vy;
A = 9; %modifica velocità: +1,-1,0 per dx, sx, su

gamma = 1; % discount factor;
%numEpisodes = 1e6; % number of episodes to mean
numEpisodes = 100;
epsilon = 0.1;

%policy soft
psoft = zeros(S,1); 

%while true
for e = 1: numEpisodes
    Q = randi(A,[S,A]); % funzione qualità random
    C = zeros(S,A); %somma cumulativa dei ritorni
    pi = zeros(S, 1); %policy ottima di output
    for s = 1:S %inizializza
        %policy ottima output
        pi(s) = find(Q(s,:) == max(Q(s, :)), 1, 'first');

        %soft policy 
        if rand < epsilon/A
            psoft(s) = randi(A); % we take a random action
        else
            % to break parity
            psoft(s) = find(Q(s,:) == max(Q(s,:)), 1, 'first');  % either we take the one with lower index
            % a = find(Q == max(Q)); % list all optimal actions;
            % a = a(randi(length(a))); % take a random action among the optimal ones
        end
    end

    

    for j = 1:numEpisodes
        % inizializzo episodio su linea verde
        %random tra 0-10 ma sommiamo 10 per spostare l'intervallo in 10-20
        min = randi(10) + 10;
        s0 = sub2ind([posizione,Vx,Vy], min);
        a0 = psoft(s0); %seguiamo soft policy 
        states = s0;
        actions = a0;
        rewards = [];
        s = s0;
        a = a0;
        sp = s0;
        while sp ~= -1 %finchè non sono a fine episodio
            [sp,r] = car_racing(s,a,griglia);
            rewards = [rewards, r];
            if sp ~= -1 && sp ~= -2
                states = [states, sp];
                a = psoft(sp); %seguiamo soft policy 
                actions = [actions, a];
                s = sp;
            end
            if sp == -2 % sono uscito da pista
                min = randi(10) + 10;
                s = ind2sub([posizione,Vx,Vy], min);
            end
        end

        G = 0;
        W = 1;
        for i = length(actions):-1:1 % explore the episode backwards
            G = gamma*G + rewards(i);
            St = states(i);
            At = actions(i);
            C(St, At) = C(St, At) + W;
            Q(St, At) = Q(St, At) + W/C(St, At)*(G - Q(St, At));

            pi(St) = find(Q(St,:) == max(Q(St,:)), 1, 'first'); %aggiorno policy

            if At ~= pi(St)
                break
            else
                W = W*(1/psoft(St));
               
            end
        end
    end
    
     
    if norm(pi-psoft,2) <= 2.5
        break
    else
        disp(norm(pi-psoft,2))
        psfot = pi;
    end

     xt = 9;
     yt = 49;

    if mod(e, 100) == 0
        % plot the gridword
        figure(1)
        clf
        rectangle('Position',[xt, yt, 1 8],'FaceColor','g',...
            'EdgeColor','g');
        % for ii = 1:numx
        %     text(ii+0.5, 0.5, num2str(wind(ii)),'interpreter','latex');
        % end
        axis equal
        xlim([1 D+1])
        ylim  ([1 D+1])
        set(gca,'xtick',1:D)
        set(gca,'ytick',1:D)
        set(gca,'xticklabels',[])
        set(gca,'yticklabels',[])
        grid on
        box on
        hold on
        [x, y] = ind2sub([D, D], H);
        x = [x, xt];
        y = [y, yt];
        plot(x+0.5,y+0.5,'Marker','o','MarkerSize',10,...
            'MarkerFaceColor','b','LineWidth',3);
        title(['Episode - ',num2str(e)],'Interpreter','latex')
        pause(1);

        % GLIE
        epsilon = epsilon*0.8;
    end

end

%% dsgfs


%% graphics

Vstar = zeros(S, 1);
for s = 1:S
    Vstar(s) = max(Q(s,:));
end

[myHand, dealerHand, usableAce] = ind2sub([C1, C2, UA], 1:S);
myHand = myHand + 11;

figure('Position',[10 10 600 300])
subplot(1,2,1)
indUA = find(usableAce == 1);
mH = reshape(myHand(indUA),[C1,C2]);
dH = reshape(dealerHand(indUA),[C1,C2]);
%pol = reshape(policy(indUA),[C1,C2]);
pol = reshape(pi(indUA),[C1,C2]);
V1 = reshape(Vstar(indUA),[C1,C2]);
contourf(mH, dH, pol, [1,2])

subplot(1,2,2)
indUA = find(usableAce == 2);
mH = reshape(myHand(indUA),[C1,C2]);
dH = reshape(dealerHand(indUA),[C1,C2]);
%pol = reshape(policy(indUA),[C1,C2]);
pol = reshape(pi(indUA),[C1,C2]);
V2 = reshape(Vstar(indUA),[C1,C2]);
contourf(mH, dH, pol, [1,2])

figure('Position',[10 10 600 300])
subplot(1,2,1)
surf(mH, dH, V1)

subplot(1,2,2)
surf(mH, dH, V2)