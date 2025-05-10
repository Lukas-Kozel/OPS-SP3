close all
clear 
clc

% Nacteni dat
%           N = [N_1;N_2] ... kapacita parkovišť
%           rp ... zisk z půjčení jednoho auta
%           rt ... cena za transport jednoho auta
%           Nt ... maximální počet přesouvaných aut
%           alpha ... zhodnocení vkladu v procentech
%           lambda ... parametry rozdělení náhodných veličin
%           x0 ... zadaný testovací počáteční stav
[N,rp,rt,Nt,alpha,lambda,x0] = carrental_data(2);
c = exp(-lambda);
eta = 1/(1+alpha/100);

f = @(x,u,w) f_fce(x,u,w,N);
U = @(x) U_fce(x,N,Nt);
L = @(x,u,w) L_fce(x,u,w,rp,rt);

%%
 [V, gamma, g] = Bellman(N,f,U,L,eta,lambda, 1, 0); 

%% vykresleni
load('data/BellmanIter_136.mat')



figure
plot(g(:,:,1))
xlabel('$i$','Interpreter','latex')
ylabel('$g^{(i)}$','Interpreter','latex')
title('$g^{(i)} = \vert \vert V^{(i+1)} - V^{(i)} \vert \vert_{\infty}$','Interpreter','latex')
set(gcf,'color','w');
grid minor
box on

figure
semilogy(g(:,:,1))
xlabel('$i$','Interpreter','latex')
ylabel('$g^{(i)}$','Interpreter','latex')
title('$g^{(i)} = \vert \vert V^{(i+1)} - V^{(i)} \vert \vert_{\infty}$','Interpreter','latex')
set(gcf,'color','w');
grid minor
box on
%%

function y = f_fce(x, u, w, N)
    y = max([0;0], min(N, x+[-1;1]*u+[-1 1 0 0; 0 0 -1 1]*w));
end

function y = U_fce(x, N, Nt)
    y = -min([x(2), N(1)-x(1), Nt]):min([x(1), N(2)-x(2), Nt]);
end

function y = L_fce(x,u,w,rp,rt)
    y = rp*min([x(1)-u, w(1)]) +rp*min([x(2)+u, w(3)]) -rt*abs(u);
end
