clear all
close all
clc

rng(1)
load gambler_model.mat
gamma = 1;%fattore di sconto

% inizializziamo il vettore della funzione valore e la policy
% arbitrariamente
vpi = zeros(S,1);
policy = randi(A, [S, 1]);%policy casuale


n1 = 100;
n2 = 100;

%vettori azioni ottime
a1 = zeros(S,1);
a2 = zeros(S,1); % qui rompiamo la parità in modo diverso
%aa = zeros(101,99); %ogni riga è una policy ottima
aa = {};
% aa = cell(2);

% XX = zeros(n1+1, n2+1);
% YY = zeros(n1+1, n2+1);
% ZZ = zeros(n1+1, n2+1);
% PP = zeros(n1+1, n2+1);
% AA = zeros(n1+1, n2+1);
XX = zeros(n1+1, 1);
YY = zeros(n1+1, 1);
ZZ = zeros(n1+1, 1);
PP = zeros(n1+1, 1);
AA = zeros(n1+1, 1);

% tic
while true
    % policy evaluation step
    % vpi = policy_eval(S,P,R,policy,gamma);
    vpi = iterative_policy_eval(S,Pt,R,policy,gamma,vpi); %funzione valore policy corrente
    % quality function
    qpi = zeros(S,A);
    % new policy
    policyp = zeros(S,1);
    %sommatoria Bellman
    for s = 1:S
        for a = 1:A
            % definition
            qpi(s,a) = R(s,a) + gamma*Pt(s,:,a)*vpi; %funzione qualità tutta policy
        end 
        % policy improvement
        policyp(s) = find(qpi(s,:) == max(qpi(s,:)),1,"first"); %policy ottima, insieme azioni ottime
        a1(s) = find(qpi(s,:) == max(qpi(s,:)),1,"first");
        
        %a2 = find(qpi(s,:) == max(qpi(s,:))); % list all optimal actions;
        a2(s) = find(qpi(s,:) == max(qpi(s,:)),1,"last");
        aa{s} = find(qpi(s,:) == max(qpi(s,:)));
        % aa{end+1} = a1(s);
        
    end
    % salviamo l'azione ottima da prendere in uno stato se rompiamo la parità a favore dell'incice piu
    % basso
    % aa{1}=a1;
    % % e se rompiamo la parita a favore dll'indice piu alto
    % aa{2}=a2;

    % condition to interrupt the while - policy stable
    if norm(policy-policyp,inf) == 0 %convergenza
        %aa = find(qpi(s,:) == max(qpi(s,:)));
        break;
    else
        policy = policyp; %aggiorna policy
    end
end
% toc

% plot the obtained results
for s = 1:S
    [num1, num2] = ind2sub([n1+1 n2+1], s);
    XX(s) = num1-1;
    % YY(s) = num2-1;
    ZZ(s) = vpi(s);
    PP(s) = policy(s);
    % AA(s) = aa{s};
end

% plot the policy
f = figure;
f.Position = [0 50 1000 800];
subplot(3,1,1);
%contourf(XX,YY,PP,1:A)
plot(XX,PP);
grid on
title("Policy ottima"); 

% plot the value function
%figure(2)
%surf(XX,YY,ZZ)
subplot(3,1,2);
plot(XX,ZZ);
grid on
title("Stima funzione valore")

% stampiamo le a ottime rispetto a funz qualità ottima 

%figure(3)
% subplot(3,1,3);
% % plot(A(1:99),aa{1,99},"Marker","*");
% % plot(XX, aa{1}, 'b')
% hold on
% % plot(XX, aa{2},'g')
% legend('parita minore', 'parita maggiore')
% hold off
% % plot(XX,PP,"Marker","o");
% grid on
% title("azioni ottime")
%%
figure(4)
for s = 1:S
    % disp(aa{1})
    m = numel(aa{s});
    plot(1:m,aa{s},"Marker","*","Color",[rand(1) rand(1) rand(1)]);
    hold on;
end
%plot(XX,PP,"Marker","o");
%%
% figure(5)
% m = numel(aa{45})
% plot(1:m,aa{45},"Marker","o")
% disp(aa{45})