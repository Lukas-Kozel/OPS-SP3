function [N,rp,rt,Nt,alpha,lambda,x0] = carrental_data(id)
% [N,rp,rt,Nt,alpha,lambda,x0] = carrental_data(id) funkce vr�t� parametry
% zad�n�:
%           N = [N_1;N_2] ... kapacita parkovi��
%           rp ... zisk z p�j�en� jednoho auta
%           rt ... cena za transport jednoho auta
%           Nt ... maxim�ln� po�et p�esouvan�ch aut
%           alpha ... zhodnocen� vkladu v procentech
%           lambda ... parametry rozd�len� n�hodn�ch veli�in
%           x0 ... zadan� testovac� po��te�n� stav

switch id
    case 1
        N = [20
            20];
        rp = 10;
        rt = 2;
        Nt = 5;
        alpha = 10;
        lambda = [3
            3
            4
            2];
        x0 = [6
            3];
    case 2
        N = [16
            25];
        rp = 11;
        rt = 2;
        Nt = 6;
        alpha = 5;
        lambda = [2
            3
            4
            2];
        x0 = [12
            14];
    case 3
        N = [16
            25];
        rp = 12;
        rt = 3;
        Nt = 10;
        alpha = 2;
        lambda = [1
            2
            4
            3];
        x0 = [2
            7];
    case 4
        N = [20
            20];
        rp = 6;
        rt = 1;
        Nt = 18;
        alpha = 3;
        lambda = [6
            4
            2
            3];
        x0 = [10
            10];
    case 5
        N = [16
            21];
        rp = 6;
        rt = 3;
        Nt = 4;
        alpha = 3;
        lambda = [6
            4
            4
            6];
        x0 = [10
            10];
    otherwise
        error('Neplatn� ��slo zad�n�.')
end


end