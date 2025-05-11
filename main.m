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
close all

figure %g = ||V^i+1 - V^i||inf
plot(g(:,:,1))
xlabel('$i$','Interpreter','latex')
ylabel('$g^{(i)}$','Interpreter','latex')
title('$g^{(i)} = \vert \vert V^{(i+1)} - V^{(i)} \vert \vert_{\infty}$','Interpreter','latex')
set(gcf,'color','w');
grid minor
box on

figure %g = ||V^i+1 - V^i||inf, log scale
semilogy(g(:,:,1))
xlabel('$i$','Interpreter','latex')
ylabel('$g^{(i)}$','Interpreter','latex')
title('$g^{(i)} = \vert \vert V^{(i+1)} - V^{(i)} \vert \vert_{\infty}$','Interpreter','latex')
set(gcf,'color','w');
grid minor
box on

figure %V dle stavu
X1 = 0:N(1);
X2 = 0:N(2);
[X,Y] = meshgrid(X2,X1);
surf(X,Y,V(:,:,end-1))
xlim([0 N(2)])
ylim([0 N(1)])
xlabel('$x_2$','Interpreter','latex')
ylabel('$x_1$','Interpreter','latex')
title('$V^{(i_f)}(x_1, x_2)$','Interpreter','latex')
set(gcf,'color','w');
view([-15.3 27])
saveit(1,'Vx1x2_normal')
view(2)
colorbar
saveit(1,'Vx1x2_updown')

figure %gamma dle stavu
surf(X,Y,gamma(:,:,end))
colormap(parulaDivergent)
xlim([0 N(2)])
ylim([0 N(1)])
xlabel('$x_2$','Interpreter','latex')
ylabel('$x_1$','Interpreter','latex')
title('$\gamma^{(i_f)}(x_1, x_2)$','Interpreter','latex')
set(gcf,'color','w');
clim([-6 +6])
view([-15.3 27])
saveit(1,'gammax1x2_normal')
view(2)
colorbar
saveit(1,'gammax1x2_updown')

%% Montyho Karel
rng(120)

gamma_optimal = gamma(:,:,end);
V_optimal = V(:,:,end);

I = 10000;
tmax = 500;
J = zeros(I,1);
x = cell(I,tmax);

for i = 1:I
    x{i,1} = x0;
    for t = 1:tmax

        w = poissrnd(lambda);
        while any(w > 10)
            w = poissrnd(lambda);
        end
        
        x1 = x{i,t}(1) + 1;
        x2 = x{i,t}(2) + 1;
        J(i) = J(i) + eta^(t-1) * L_fce(x{i,t}, gamma_optimal(x1, x2), w, rp, rt);
        x{i,t+1} = f_fce(x{i,t}, gamma_optimal(x1, x2), w, N);
    end
end

mean(J)
V_optimal(x0(1)+1, x0(2)+1)

figure
hold on
plot(J,'.')
plot(mean(J)*ones(1,length(J)),'LineWidth',2)
plot(V_optimal(x0(1)+1,x0(2)+1)*ones(1,length(J)),'LineWidth',2)
xlabel('$i$','Interpreter','latex')
legend('$J$','$\hat{E[J]}$','$V^*$','Interpreter','latex')
title('Monte Carlo simulace','Interpreter','latex')
set(gcf,'color','w');
box on
saveit(1, 'Monty')
%%

%funkce od GPT pro hezkou colormapu
function cmap = parulaDivergent(m)
% PARULADIVERGENT  žlutá–modrá–žlutá paleta symetrická kolem středu.
%    cmap = parulaDivergent;      % výchozích 256 barev
%    cmap = parulaDivergent(N);   % N barev, N libovolné kladné celé

    if nargin < 1,  m = 256;  end           % default

    nHalf = ceil(m/2);                      % délka půl-palety
    p     = parula(nHalf);                  % horní (žlutý) konec paruly

    % Postavíme paletu tak, aby měla alespoň m řádků:
    if mod(m,2)==0                         % sudý počet → klidně duplikuj střed
        cmap = [flipud(p) ; p];
    else                                   % lichý počet → střed jen jednou
        cmap = [flipud(p(2:end,:)) ; p];
    end

    cmap = cmap(1:m,:);                    % přesné oříznutí
end

function y = f_fce(x, u, w, N)
    y = max([0;0], min(N, x+[-1;1]*u+[-1 1 0 0; 0 0 -1 1]*w));
end

function y = U_fce(x, N, Nt)
    y = -min([x(2), N(1)-x(1), Nt]):min([x(1), N(2)-x(2), Nt]);
end

function y = L_fce(x,u,w,rp,rt)
    y = rp*min([x(1)-u, w(1)]) +rp*min([x(2)+u, w(3)]) -rt*abs(u);
end
