%======================================
% PROGRAMA DE ESTIMACIÓN DE DIÁMETRO POR APROXIMACIONES SUCESIVAS
% Autor: Víctor Hugo Hidalgo, DSc.
% Fecha: 2022 - 02 - 07
%======================================

%======================================
% Datos del problema a diseñar 
%======================================
LT = 84; % Longitud de tubería [m]
z1 = 50; % Cota inicial [m]
z2 = 1.5; % Cota final [m]
rho = 998; % Densidad del agua [kg/m3]
nu = 0.001005; % Viscosidad del agua [kg/(m*s)]
e_r = 0.0015; % Rugosidad de la tubería [mm]
Qmax = 20/1000; % Caudal máximo permitido [m3/s] 
Qmin = 15/1000; % Caudal mínimo permitido [m3/s]

%======================================
% Valores asumidos para ejercicio
%======================================
fa = 0.0138; % Factor de friccion
D = 20; % Diámetro [mm] 

%======================================
% Transformación de [mm] --> [m]
%======================================
D_c = D / 1000; % 
e_r = 0.0015/1000;

%======================================
% Cálulos inciales de velocidad en ducto v_c y caudal en ducto Q_c
%======================================
v_c = ve(z1,z2,fa,LT,D_c);
Q_c = Q_t(D_c, v_c);
D_cm=[];
Q_cm=[];
fa_cm=[];
it = linspace(1,100,100);

%======================================
% Lazo de cálculo para estimar D_c y Q_c
%======================================
for i = 1:100
    if Q_c < Qmin
        D_c = D_c + 0.001; % se suma 1 [mm] al diámetro
        v_c = ve(z1,z2,fa,LT,D_c);
        Q_c = Q_t(D_c, v_c);
        D_cm{end+1} = D_c;
        Q_cm{end+1} =Q_c;
        Rey = Re(v_c, D_c, rho, nu); 
        fa  = fric(D_c,e_r,Rey);
        fa_cm{end+1} = fa;
    elseif Q_c > Qmax
        D_c = D_c - 0.001; % se resta 1 [mm] al diámetro
        v_c = ve(z1,z2,fa,LT,D_c);
        Q_c = Q_t(D_c, v_c);
        D_cm{end+1} = D_c;
        Q_cm{end+1} =Q_c;
        Rey = Re(v_c, D_c, rho, nu);
        fa  = fric(D_c,e_r,Rey);
        fa_cm{end+1} = fa;
    else
        Q_c = Q_c;
        Rey = Re(v_c, D_c, rho, nu);
        fa  = fric(D_c,e_r,Rey);
        D_cm{end+1} = D_c;
        Q_cm{end+1} =Q_c;
        fa_cm{end+1} = fa;
    end
    D_cf = horzcat(D_cm);
    D_cf = cell2mat(D_cf);
    Q_cf = horzcat(Q_cm);
    Q_cf = cell2mat(Q_cf);
    fa_cf = horzcat(fa_cm);
    fa_cf = cell2mat(fa_cf);
end

%======================================
% Transformación de:
%                       [m]     --> [mm]
%                       [m^3/s] --> [Lit./s]
%======================================
D_c = D_c*1000; % Diámtro calculado en [mm]
Q_c = Q_c*1000; % Caudal en [Lit./s]

%======================================
% Impresión de resultados
%======================================
fprintf('El valor de Reynols: %d\n',Rey);
disp(' ');
disp('--------------------');
fprintf('El valor de la fricción: %d\n',fa);
disp(' ');
disp('--------------------');
fprintf('El valor del diámetro: %d\n[mm]',D_c);
disp(' ');
disp('--------------------');
fprintf('El valor del caudal: %d\n[Lit./s]',Q_c);
%display(D_cf);

subplot(1,2,1);
  plot(D_cf,Q_cf);
  
subplot(1,2,2);
  plot(D_cf,fa_cf);


