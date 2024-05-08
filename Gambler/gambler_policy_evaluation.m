clear all
close all
clc

rng(1)
load gambler_model.mat
gamma = 0.9; %fattore di sconto per il calcolo dei valori di utilità futura

%policy casuale
policy = randi(A, [S, 1]); %vettore lungo S con numeri casuali fino ad A (100)

tic
vpi = policy_eval(S,Pt,R,policy,gamma); %trova valore di vpi con Bellman
toc

vpi0 = zeros(S,1);

tic
vpi2 = iterative_policy_eval(S,Pt,R,policy,gamma,vpi0); %trovo vpi ottima
toc

%possibili stati
 %n1 = 30;
 n1 = 100;
 n2 = 100;
 cash = 100;


XX = zeros(n1+1, n2+1);%coordinate sull'asse x della griglia 
YY = zeros(n1+1, n2+1);%coordinate sull'asse y
ZZ = zeros(n1+1, n2+1);
PP = zeros(n1+1, n2+1);%matrice dei valori della politica da rappresentare graficamente

for s = 1:S
    [num1, num2] = ind2sub([n1+1 n2+1], s);
    %num1 = ind2sub(cash, s);
    XX(s) = num1-1;
    YY(s) = num2-1;
    ZZ(s) = vpi(s);
    PP(s) = policy(s);
end

% plot the policy
figure(1)
% contourf(XX,YY,PP,1:A) %indica i livelli dei contorni da tracciare

% la chiamata contourf(XX, YY, PP, 1:A) genera un grafico a contorni riempito dove:
% Gli assi x e y sono definiti dalle matrici XX e YY rispettivamente.
% I valori della politica PP determinano i valori dei contorni su questa griglia.
% I contorni vengono disegnati usando i livelli specificati da 1 a A.

plot(XX,PP);
title("Policy ottima");

% plot the value function
figure(2)
% Plotta una superficie 3D della funzione valore ZZ rispetto agli stati XX e YY.
%surf(XX,YY,ZZ)
plot(XX,ZZ);
title("Stima funzione valore")

