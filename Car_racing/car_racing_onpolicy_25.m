close all
clc
clear all
load grid.mat
rng('default')
% 
% griglia = ones(25,25);
% 
% griglia(1:10,:) = 0;
% 
% griglia(20:25,15:25) =0;
% 
% griglia(11:19,25) = 2;
% 
% griglia(25,1:14) = 3;

griglia2 = griglia;
% griglia2 = [0,0,0,0,0,0,0,0;
%            0,0,0,0,1,1,1,2;
%            0,0,0,1,1,1,1,2;
%            0,0,1,1,1,1,1,2;
%            0,0,1,1,1,0,0,0;
%            0,1,1,1,0,0,0,0;
%            0,1,1,1,0,0,0,0;
%            0,3,3,3,0,0,0,0];
[numrow, numcol] = size(griglia2);
griglia = zeros(numrow,numcol);
for i = 1:numrow
    griglia(numrow-i+1,:) = griglia2(i,:); 
end
%
Vx = 6;                 % velocità va da 0 a 5
Vy = 6;
D  = numcol;                 % dimensione griglia
d = numcol +1;
posizione = D*D;        % numero posizioni della griglia
S = posizione*Vx*Vy;    % numero degli stati totali
A = 9;                  % numero azioni totali

gamma = 1;              % discount factor;
numEpisodes = 1e4;      % number of episodes to mean
lenEpisodes = 1e4;
epsilon = 0.3;
%%

% figura
figure(1)
clf
hold on
xt = numcol -15+1;
yt = numrow;

axis equal
xlim([1 D+1])
ylim ([1 D+1])
set(gca,'xtick',1:D+1)
set(gca,'ytick',1:D+1)
set(gca,'xticklabels',[1:D+1]);
set(gca,'yticklabels',[1:D+1]);

% [numrow, numcol] = size(griglia2);
for i = 1:numrow
    for j = 1:numcol
        if griglia(i,j) == 1 
            rectangle('Position',[j,i, 1 1],'FaceColor','w','EdgeColor','k');
        elseif griglia(i,j) == 2 
            rectangle('Position',[j,i, 1 1],'FaceColor','r','EdgeColor','k');
        elseif griglia(i,j) == 3
            rectangle('Position',[j,i, 1 1],'FaceColor','g','EdgeColor','k');
            elseif griglia(i,j) == 0
            rectangle('Position',[j,i, 1 1],'FaceColor','k','EdgeColor','k');
        end
    end
end
% rectangle('Position',[yt, xt, 1, 8],'FaceColor','r','EdgeColor','r');
grid on
box on
%


% calcolo delle posizioni di partenza
[y_s,x_s] = find(griglia ==3);
s_iniziale = sub2ind(size(griglia),y_s,x_s);
% plot(x_s(1)+0.5,y_s(1)+0.5,'o')
% plot(x_s(1)+0.5,y_s(1)+1+0.5,'o')
% s0 = s_iniziale(randi(3))
%
policy = randi(A,[S,1]); % policy
tic

for e = 1:lenEpisodes
    Q = zeros(S, A); % quality function
    N = zeros(S, A); % counter of visits
    for j = 1:numEpisodes
        % beginning of episode 
        % uno una policy epsilon- soft come policy comportamentale
        % min = randi(3) + 1;
        % s0 = ind2sub([posizione,Vx,Vy], min);
        s0 = s_iniziale(randi(length(s_iniziale)));
        [y_start, x_start]=ind2sub(size(griglia),s0);
        % fprintf("stato iniziale (%d,%d)", x_start,y_start)
        x_start = x_start;
        a0 = randi(A);
        states = s0;
        actions = a0;
        rewards = [];
        s = s0;
        a = a0;
        sp = s0;
        
        [y_past, x_past] = ind2sub([D, D], s);
        x_past = x_past;
        while sp ~= -1
            [sp,r,s_finale] = car25(s,a, griglia);
            rewards = [rewards, r];
            if sp ~= -1 
                states = [states, sp];
                a = policy(sp);
                if rand < epsilon
                    a = randi(A);
                end
                actions = [actions, a];
                s = sp;
            
            end
            if s_finale ~= 0
                states = [states s_finale];
            end
             % if sp == -2 % sono uscito da pista
             %    % min = randi(3) + 1;
             %    % s = ind2sub([posizione,Vx,Vy], min);
             %    s = s_iniziale(randi(length(s_iniziale)));
             %    [y_start, x_start]=ind2sub(size(griglia),s);
             %    % fprintf("ricominciamo stato iniziale (%d,%d)", x_start,y_start)
             %    % fprintf("\nstato dopo essere uscito dalla pista %d\n", s);
             % end
        %      figure(1)
        % 
        % H = s;
        % 
        % % for ii = 1:numx
        % %     text(ii+0.5, 0.5, num2str(wind(ii)),'interpreter','latex');
        % % end
        % 
        % grid on

        % figure = fig;


        % [pos,vx,vy] = ind2sub([posizione,Vx,Vy],H);
        % [y, x] = ind2sub(size(griglia),pos );
        % x = x;
        % if (griglia(y,x)==3)
        %     delete(pat);
        %     x= x(end);
        %     y = y(end);
        %     x_past = x
        %     y_past = y
        %     % disp('del')
        % 
        % end
        % % x = [x, xt];
        % % y = [y, yt];
        % x = [x, x_past];
        % y = [y, y_past];
        % pat = plot(x+0.5,y+0.5,'Marker','o','MarkerSize',5,'MarkerFaceColor','g','LineWidth',3);
        % title(['Episode - ',num2str(e)],'Interpreter','latex')
        % pause(1);
        % x_past = x;
        % y_past = y;
        end
        G = 0;
        Q = Q; 
        % disp('modifica funzione qualita')
        for i = length(actions):-1:1 % explore the episode backwards

            G = gamma*G + rewards(i);
            St = states(i);
            At = actions(i);
            N(St, At) = N(St, At) + 1;
            Q(St, At) = Q(St, At) + 1/N(St, At)*(G - Q(St, At));
        end
        % [c1,c2,ua] = ind2sub([C1,C2,UA], states)
        % myHand = c1 + 11;
        % disp('nuovo episodio')
    end
    newpolicy = zeros(S,1);
    % update the policy as greedy w.r.t. Q
    for s = 1:S
        newpolicy(s) = find(Q(s,:) == max(Q(s, :)), 1, 'first');
    end
    % if policy doesn't change stop
    if norm(newpolicy-policy,2) <= 0.2
    % if norm(Q_new - Q, 2) ==0
        % disp('convergenza')
        break
    else
        % disp(norm(newpolicy-policy,inf))
        policy = newpolicy;
        % Q = Q_new;
    end
    % disp(e)
    if (mod(e,10)==0)
        % figure
        % H = s;
        
        % states = [states sp];
        % for ii = 1:numx
        %     text(ii+0.5, 0.5, num2str(wind(ii)),'interpreter','latex');
        % end
        figure(1)
        hold on
        axis equal
        xlim([1 D+1])
        ylim ([1 D+1])
        set(gca,'xtick',1:D+1)
        set(gca,'ytick',1:D+1)
        set(gca,'xticklabels',[1:D+1])
        set(gca,'yticklabels',[1:D+1])

        % [numrow, numcol] = size(griglia2);
        for i = 1:numrow
            for j = 1:numcol
                if griglia(i,j) == 1 
                    rectangle('Position',[j,i, 1 1],'FaceColor','w','EdgeColor','k');
                elseif griglia(i,j) == 2 
                    rectangle('Position',[j,i, 1 1],'FaceColor','r','EdgeColor','k');
                elseif griglia(i,j) == 3
                    rectangle('Position',[j,i, 1 1],'FaceColor','g','EdgeColor','k');
                elseif griglia(i,j) == 0
                    rectangle('Position',[j,i, 1 1],'FaceColor','k','EdgeColor','k');
                end
            end
        end
        % rectangle('Position',[yt, xt, 1, 3],'FaceColor','r','EdgeColor','r');
        grid on
        box on
        hold on
        [pos,vx,vy] = ind2sub([posizione,Vx,Vy],states);
        [y, x] = ind2sub(size(griglia),pos );

        % x = [x, yt];
        % y = [y, xt];
        % x = [x, x_past];
        % y = [y, y_past];
        plot(x+0.5,(y+0.5),'Marker','o','MarkerSize',5,...
            'MarkerFaceColor','b','LineWidth',3);
        title(['Episode - ',num2str(e)],'Interpreter','latex')
        pause(1);
        x_past = x;
        y_past = y;
        % epsilon = epsilon*0.8
        

        % figure(2)
        % surf(Q)
        % pause(1)
        % hold off

        
    end

end
toc
H = s;

% for ii = 1:numx
%     text(ii+0.5, 0.5, num2str(wind(ii)),'interpreter','latex');
% end

% figure
axis equal
xlim([1 D+1])
ylim ([1 D+1])
set(gca,'xtick',1:D+1)
set(gca,'ytick',1:D+1)
set(gca,'xticklabels',[1:D+1])
set(gca,'yticklabels',[1:D+1])

% [numrow, numcol] = size(griglia2);
for i = 1:numrow
    for j = 1:numcol
        if griglia(i,j) == 1 
            rectangle('Position',[j,i, 1 1],'FaceColor','w','EdgeColor','k');
        elseif griglia(i,j) == 2 
            rectangle('Position',[j,i, 1 1],'FaceColor','r','EdgeColor','k');
        elseif griglia(i,j) == 3
            rectangle('Position',[j,i, 1 1],'FaceColor','g','EdgeColor','k');
        elseif griglia(i,j) == 0
            rectangle('Position',[j,i, 1 1],'FaceColor','k','EdgeColor','k');
        end
    end
end
% rectangle('Position',[yt, xt, 1, 3],'FaceColor','r','EdgeColor','r');
grid on
box on
hold on
[pos,vx,vy] = ind2sub([posizione,Vx,Vy],states);
[y, x] = ind2sub(size(griglia),pos );

% x = [x, ];
% y = [y, xt];
% x = [x, x_past];
% y = [y, y_past];
plot(x+0.5,(y+0.5),'Marker','o','MarkerSize',5,...
    'MarkerFaceColor','b','LineWidth',3);
title(['Episode - ',num2str(e)],'Interpreter','latex')
pause(1);

%%
% for i = 1:numrow
%     for j = 1:numcol
%         pos = sub2ind([D D],i,j); % ricavo indice sulla griglia
% 
%     end
% 
% end
% 
% figure(3)
%         quiver([1:numrow],[1:numrow],vx,vy)
% 












