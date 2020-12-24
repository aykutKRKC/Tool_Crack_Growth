%% PROGRAM TO CALCULATE CRACK PROPAGATION**********************************
clear all
close all


%% SECTION 1:
clc

a_0 = 3 ; %Initial crack length [mm]
sigma_n_0 = sqrt(0.2); %        [mm]
C = 2.381e-12; %              [mm/cycle(Mpa.(mm^0.5))^-m]
m = 3.2;
delta_S = 100;%     [MPa]
delta_N = 10;%     [Number of load cycles in 1 session]
F_a = 1.12;
sigma_n_k = @(x) sigma_n_0*sqrt(x/a_0);
a_lim = 20;%           [mm]
a(1) = a_0;



%rng(123123);
figure
scatter(0,a(1),"x");
grid on
hold on
kk = 1;
while a(kk) <= a_lim
    kk = kk + 1;
    a(kk) = a(kk-1) + delta_N*C*(F_a*delta_S*sqrt(pi*a(kk-1)))^m + ...
            sigma_n_k(a(kk-1))*randn();
    if a(kk) < a(kk-1)
        a(kk) = a(kk-1);
    end
    scatter(delta_N*(kk-1),a(kk),"x");
    pause(0.01);
end



%% This section is for plotting

% a_S_20 = a;
% clear a;
% %Run again with different parameters
% a_S_40 = a;
% clear a;
% %Run again with different parameters
% figure
% plot(0:delta_N:delta_N*length(a_S_20)-1,a_S_20);
% grid on
% hold on
% plot(0:delta_N:delta_N*length(a_S_40)-1,a_S_40);
% plot(0:delta_N:delta_N*length(a_S_60)-1,a_S_60);
% legend("$\Delta S = 20$","$\Delta S = 40$","Interpreter","latex");