function [V,gamma,g] = Bellman(N,f_hh,u_hh,L_hh,eta,lambda,newstart,istart)

    if newstart
        i = 1;
        V(1:N(1)+1,1:N(2)+1,1) = 0;
        gamma(1:N(1)+1,1:N(2)+1,1) = 0;
    else
        load(sprintf('BellmanIter_%i',istart))
        i = istart+1;
    end
    
    Nw = 10;
    w  = 0:Nw;
    

    factw = factorial(w);

    p1 = exp(-lambda(1)) * lambda(1).^w ./ factw;   
    p2 = exp(-lambda(2)) * lambda(2).^w ./ factw;
    p3 = exp(-lambda(3)) * lambda(3).^w ./ factw;
    p4 = exp(-lambda(4)) * lambda(4).^w ./ factw;
    

    [P1,P2,P3,P4] = ndgrid(p1, p2, p3, p4);
    pdf = P1 .* P2 .* P3 .* P4;
                                    
    while true

        fprintf('Iteration %d\n', i);
    
        tic
          [Vnew, gammanew] = dp_iter( ...
             N, f_hh, u_hh, L_hh, eta, lambda, ...
             V(:,:,i), gamma(:,:,i), Nw, pdf);
        elapsed = toc;
    
    
        V(:,:,i+1)     = Vnew;
        gamma(:,:,i+1) = gammanew;
    
    
        g(i) = norm(Vnew - V(:,:,i), Inf);
        fprintf('g = %.4f\n', g(i));
    
    
        fn = fullfile('data', sprintf('BellmanIter_%d.mat', i));
        save(fn, 'V', 'gamma', 'g');
        fprintf('Saved to %s\n', fn);
    
        if g(i) < 1
            fprintf('g(%d)<1 ... stopping\n', i);
            break;
        end
    
        i = i + 1;
    end
end

