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

f = @f_fce; %je tohle vůbec nutný???
U = @U_fce;
L = @L_fce;





function y = f_fce(x, u, w)
    y = max([0;0], min(N, x+[-1;1]*u+[-1 1 0 0; 0 0 -1 1]*w));
end

function y = U_fce(x)
    y = -min([x(2), N(1)-x(1), Nt]):min([x(1), N(2)-x(2), Nt]);
end

function y = L_fce(x,u,w)
    y = rp*min([x(1)-u, w(1)]) +rp*min([x(2)+u, w(3)]) -rt*abs(u);
end
