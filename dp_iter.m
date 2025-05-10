function [Vnew,gammanew] = dp_iter(N,f_hh,u_hh,L_hh,eta,lambda, V, gamma, Nw, pdf)

    X1 = 0:N(1);
    X2 = 0:N(2);

    for ix1 = X1+1
        for ix2 = X2+1

           x = [X1(ix1);X2(ix2)];
           Uset=u_hh(x);
           eV = NaN(1,length(Uset));
           
           for iu = 1:length(Uset) 
                eL = 0;
                for w1 = 0:Nw
                    for w2 = 0:Nw
                        for w3 = 0:Nw
                            for w4 = 0:Nw
                                
                                w = [w1;w2;w3;w4];
                                xnew = f_hh(x,Uset(iu),w);
                                idx1 = xnew(1)+1;
                                idx2 = xnew(2)+1;

                                pdf_w = pdf(w1+1,w2+1,w3+1,w4+1);
                                eL = eL + (L_hh(x,Uset(iu),w) + eta*V(idx1,idx2))*pdf_w;
                            end
                        end
                    end
                end
                eV(iu) = eL;
           end
           [M,I] = max(eV);
           Vnew(ix1,ix2) = M;
           gammanew(ix1,ix2) = Uset(I);
        end
    end
end

