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
fa = 0.0138; % Factor de fricción
D = 25.4; % Diámetro [mm] 

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
nr = 60; % número de iteraciones
it = linspace(1,nr,nr);  % iteraciones
tpo = "Arial";
D_cm=[]; % vacía para poder adherir resultados
Q_cm=[]; % vacía
fa_cm=[]; % vacía


%======================================
% Lazo de cálculo para estimar D_c y Q_c
%======================================
for i = 1:nr
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


%======================================
% Figura de Q y el f en función D
%======================================
subplot(1,2,1);
  [Ax, H1, H2] = plotyy(D_cf*1000,Q_cf*1000,D_cf*1000,fa_cf);
  
  xlabel (Ax(1), {"Diámetro de Tubería D "; "[mm]"},"fontsize", 8, "fontname",tpo);
  ylabel (Ax(1), "Caudal Q [L/s]","fontsize", 8,"fontname",tpo);
  ylabel (Ax(2), ["Factor de Fricción $f$"],"fontsize", 8,"fontname",tpo);
  
  set(Ax(1),"fontsize", 8, "linewidth",1,'ycolor','k',"fontname",tpo);
  %set(H1, "linestyle","none","linewidth",1.2,'color','k','marker','o','MarkerSize',5, 'MarkerFaceColor','k');
  set(H1, "linestyle","-","linewidth",1.2,'color','k');
  xp = D_cf(nr)*1000;
  yp = Q_cf(nr)*1000;
  text (xp,yp , ['$D_e~\displaystyle\longrightarrow$ '], ...
       "color", 'k', "horizontalalignment", "right",'fontsize', 8,"fontname",tpo,"parent",Ax(1));
  annotation('textbox', [0.17, 0.02, 0, 0], 'string',['(a) Q y $f$ en función de D'],'fontsize', 10);

    % Segundo eje en y
  set(Ax(2),"fontsize", 8, "fontname",tpo,"linewidth",1,'ycolor','k');
  set(H2, "linestyle","-","linewidth",1.1,'color','k','marker','+','MarkerSize',4, 'MarkerFaceColor','k');
  yp2 = fa_cf(nr);
  text (xp,yp2 , ['$f_e~\displaystyle\longrightarrow$ '], ...
       "color", 'k', "horizontalalignment", "right",'fontsize', 8,"fontname",tpo,"parent",Ax(2));
  hold on;

  De = D_cf(nr)*1000;
  Qe = Q_cf(nr)*1000;

  plot(De,Qe,"linestyle","none","linewidth",1.1,'color','k','marker','o','MarkerSize',4, 'MarkerFaceColor','k')

% add legends for these 2 curves
  legend('Q', ['Diámetro deducido $D_e$'],['$f$'], 'fontsize',8,"fontname","Arial",'box',"off","location", "north","fontname",tpo);

  hold off;

  box off;

%======================================
% Figura de D en función del número de 
% iteraciones
%======================================
subplot(1,2,2);
  plot(it, D_cf*1000,'-k','linewidth',1.2);
  h=get(gcf, "currentaxes");
  set(h, "fontsize", 8, "linewidth", 1,"fontname",tpo);
  legend('D', 'fontsize',8,'box',"off",'location','east',"fontname",tpo)
  ylabel("Diámetro de Tubería D [mm]","fontsize", 8,"fontname",tpo);
  xlabel({"Número de"; "iteraciones"; 'en el lazo for'},"fontsize", 8,"fontname",tpo);
  annotation('textbox', [0.595, 0.02, 0, 0], 'string',['(b) D en función del número de iteraciones'],'fontsize', 10);
  yt = D_cf(nr)*1000 + 2;
  xt = nr - 8
  text (xt, yt, ['Convergencia de D'], ...
       "color", 'k', "horizontalalignment", "right",'fontsize', 8,"fontname",tpo)
  %text (15, 20, ['$\displaystyle\leftarrow x = {2 \over \sqrt{\pi}}'...
  %                   '\int_{0}^{x} e^{-t^2} dt = 0.6175$'],
  %    "interpreter", "latex");
  %set(h, 'xaxislocation', "origin");

  box off;

%======================================
% Configuración de tamaño 
%======================================
set(gcf, 'PaperUnits', 'inches');
set(gcf,'PaperSize', [8.5 4]);
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'PaperPosition', [0 0 8.5 4]);
%set(gcf, 'position', [1 0 0.1 2]);

%======================================
% Guardar archivo en pdf 
%======================================
%print  diamtroDe.pdf;
%print -deps diamtroDe.eps;
%print ("diamtroDe2.pdf", "-dpdflatexstandalone");
print -dpdflatexstandalone diamtroDe4.pdf
system ("pdflatex diamtroDe4");

