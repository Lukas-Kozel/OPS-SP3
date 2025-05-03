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
c1= exp(-lambda(1))
c2= exp(-lambda(2))
c3= exp(-lambda(3))
c4= exp(-lambda(4))