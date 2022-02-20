% Ecuación de velocidad

function [v] = ve(z1,z2,f,L,D)
    v = (2*9.81*(z1-z2)/(1 + (f*L/D))).^0.5;
    return
endfunction
