clear all
close all
clc

rng(1)
load gambler_model.mat
gamma = 1;%fattore di sconto

policy = randi(A, [S, 1]);%policy casuale


n1 = 100;
n2 = 100;

%vettori azioni ottime
a1 = zeros(S,1);
a2 = zeros(S,1); %qui rompiamo la parità in modo diverso
%aa = zeros(101,99); %ogni riga è una policy ottima
aa = {};

XX = zeros(n1+1, n2+1);
YY = zeros(n1+1, n2+1);
ZZ = zeros(n1+1, n2+1);
PP = zeros(n1+1, n2+1);
AA = zeros(n1+1, n2+1);

vpi = zeros(S,1);
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
        aa{end+1} = find(qpi(s,:) == max(qpi(s,:)));
    end

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
    YY(s) = num2-1;
    ZZ(s) = vpi(s);
    PP(s) = policy(s);
    %AA(s) = aa(s);
end
%%
% plot the policy
figure(1)
subplot(3,1,1);
%contourf(XX,YY,PP,1:A)
plot(XX,PP);
title("Policy ottima"); 

% plot the value function
%figure(2)
%surf(XX,YY,ZZ)
subplot(3,1,2);
plot(XX,ZZ);
title("Stima funzione valore")

% stampiamo le a ottime rispetto a funz qualità ottima 

%figure(3)
% subplot(3,1,3);
% plot(A(1:99),aa{1,99},"Marker","*");
% hold on;
% plot(XX,PP,"Marker","o");
% 
% title("azioni ottime")

subplot(3,1,3);
plot(XX,a1,"Marker","*");
hold on;
plot(XX,a2,"Marker","o");
legend("policy 1", "policy 2");

title("azioni ottime")