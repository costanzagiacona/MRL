clear all
close all
clc

rng(1)
load gambler_model.mat
gamma = 1; %fattore di sconto
toll = 1e-5;
%toll = 0.001;
a = zeros(S,1);

% vp2 = zeros(S,A);
vp2 ={};
vpi = zeros(S,1);
% tic

while true
    % perform a value iteration step
    [vpin, policy, vp2] = value_iteration_step(S,A,Pt,R,gamma,vpi);
    % a(i) = find(qpi == max(qpi),1,"first");

    % condition to interrupt the iteration - value function converged
    if norm(vpin - vpi,inf) < toll
        break; %trovato ottimo
    else
        vpi = vpin;
    end
end
% toc

% plot the obtained results

n1 = 100;
n2 = 100;

XX = zeros(n1+1, n2+1);
YY = zeros(n1+1, n2+1);
ZZ = zeros(n1+1, n2+1);
PP = zeros(n1+1, n2+1);
AA = zeros(n1+1, n2+1);

for s = 1:S
    [num1, num2] = ind2sub([n1+1 n2+1], s);
    XX(s) = num1-1;
    YY(s) = num2-1;
    ZZ(s) = vpi(s);
    PP(s) = policy(s);
    AA(s) = vp2(s);
end



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
subplot(3,1,3);
plot(XX,AA,"Marker","*");
hold on;
plot(XX,PP,"Marker","o");
legend("policy 1", "policy 2");

title("azioni ottime")

%% 
figure(4)
for s = 1:S
    % disp(aa{1})
    m = numel(vp2{s});
    plot(1:m,vp2{s},"Marker","*","Color",[rand(1) rand(1) rand(1)]);
    hold on;
end

