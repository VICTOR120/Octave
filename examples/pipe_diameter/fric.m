% Ecuación de Darcy para calcular el factor de f

function [f] = fric(D,e,Re)
    ru = D/e;
    L = (log10((1/(3.7*ru)) + (5.74/(Re.^(0.9))))).^2;
    f = 0.25/L;
    return
endfunction
