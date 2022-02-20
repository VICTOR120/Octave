% Ecuación de Darcy para calcular el factor de f

function [f] = fric2(D,e,Re)
    ru = D/e;
    L = (-log((1/(3.7*ru)) + (5.74/(Re.^(0.9))))).^2;
    f = 1.325/L;
    return
endfunction
