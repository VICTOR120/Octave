% Función de Caudal

function [Rey] = Re(v,D,rho,nu)
    Rey = v*D*rho/nu;
    return
endfunction
