clc; clear; close all
%load Urban.mat
% load CBCL.mat
% load Swimmer.mat
load tdt2_top30.mat

% Urban Swimmer trans
V = X';
[n, m] = size(V);
% m = 250; %250
% n = 500; %500
% V = abs(rand(n,m));
k = 20;  % 80 greedy 1000/900 Urban 
         % 6 CBCL 49 SWIMER 17 tdt2_top30 20
tol = 1e-2; 
max_iter = 1e2;
stop = 0;

mark_number = 10;
linestyle = {'--*', '-.o', ':v', ':^', '-.x'};
set(groot,'defaultLineLineWidth',1);
set(groot,'defaultLineMarkerSize',8);

rng(2023);
W = abs(rand(n,k));
H = abs(rand(k,m));

% [innner_iter, obj, time, projnorm,~,~,~,~, residual]...
%     = GCD(V, max_iter, tol, W, H);
% 1
[W_o,H_o,~,normR_o,normRes_o,T_o]...
    = HALS_ori(V,W,H,tol,max_iter,stop);
2

[W_g,H_g,~,normR_g,normRes_g,T_g]...
    = HALS_greedy(V,W,H,tol,max_iter,stop);
3
figure
% plot(time, residual,linestyle{1},...
%     'MarkerIndices',1:ceil(length(time)/mark_number):length(time))
% hold on
plot(T_o, normRes_o./normRes_o(1),linestyle{2},...
    'MarkerIndices',1:ceil(length(T_o)/mark_number):length(T_o))
hold on
plot(T_g, normRes_g./normRes_g(1),linestyle{3},...
    'MarkerIndices',1:ceil(length(T_g)/mark_number):length(T_g))
legend("HALS","GHALS")
xlabel("CPU")
ylabel("Relative Residual")
MyPlotStyle(20, "log")

figure
% plot(time, obj./obj(1), linestyle{1},...
%     'MarkerIndices',1:ceil(length(time)/mark_number):length(time))
% hold on
plot(T_o, normR_o./normR_o(1), linestyle{2},...
    'MarkerIndices',1:ceil(length(T_o)/mark_number):length(T_o))
hold on
plot(T_g, normR_g./normR_g(1), linestyle{3},...
    'MarkerIndices',1:ceil(length(T_g)/mark_number):length(T_g))
hold on
legend("HALS","GHALS")
xlabel("CPU")
ylabel("Relative Objective Function")
MyPlotStyle(20, "log")
%%%% tdt2_top30
%%
for i = 1 : k
    [a,b] = sort(-W_o(:,i));
    for j = 1 : 10 % Keep the 10 words with the largest value in W(:,i) 
        Topics_o{j,i} = words{b(j)};
    end
end 
for i = 1 : k
    [a,b] = sort(-W_g(:,i));
    for j = 1 : 10 % Keep the 10 words with the largest value in W(:,i) 
        Topics_g{j,i} = words{b(j)};
    end
end 
%%%% Swimmer
% affichage(H_o',17,20,11); 
% affichage(H_g',17,20,11); 
%%%% CBCL
% affichage(W_o,7,19,19,1);
% affichage(W_g,7,19,19,1);
%%%% Urban
% H_bar_o = NNLS(H_o', X); 
% affichage(H_bar_o',3,307,307,1); 
% title("Constitutive Materials (HALS) ")
% H_bar_g = NNLS(H_g', X); 
% affichage(H_bar_g',3,307,307,1); 
% title("Constitutive Materials (GHALS) ")
% norm(H_bar_o - H_bar_g)