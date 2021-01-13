%% PROGRAM TO CALCULATE CRACK PROPAGATION**********************************
clear all
close all


%% SECTION 1:
clc

a_0 = 3 ;                % Initial crack length [mm]
sigma_n_0 = sqrt(0.2);   % Initial standart deviation  [mm]

C = 2.381e-12;           %  [mm/cycle(Mpa.(mm^0.5))^-m]
m = 3.2;                 %  
delta_S = 40;            % stress amplitude     [MPa]
delta_N = 10000;            % [Number of load cycles in 1 session]
F_a = 1.12;              % crack shape function     
sigma_n_k = @(x) sigma_n_0*sqrt(x/a_0);    % standart deviation
a_lim = 80;              %   max crack length        [mm]
a(1) = a_0;
n(1) = 0;


rng(1002);

scatter(0,a(1),"x");
grid on
hold on
kk = 1;
while a(kk) <= a_lim 
    kk = kk + 1;
    n(kk) = n(kk-1) + delta_N;
    
    a(kk) = a(kk-1) + delta_N*C*(F_a*delta_S*sqrt(pi*a(kk-1)))^m;
    a_noise(kk) = a(kk) + randn()*sigma_n_k(a(kk));
    
%     if a_noise(kk) >= a_lim   
%       a(kk) = a_lim + 1
%     end
    scatter(delta_N*(kk-1),a(kk),"x");
    pause(0.001);
end
%figure 
plot(n,a_noise,n,a,".","MarkerSize",4);


%% SECTION 2 : Different delta_s 
 
clc

a_0 = 3 ;                % Initial crack length [mm]
sigma_n_0 = sqrt(0.2);   % Initial standart deviation  [mm]

C = 2.381e-12;           %  [mm/cycle(Mpa.(mm^0.5))^-m]
m = 3.2;                 %  
delta_S = 40;            % stress amplitude     [MPa]
delta_N = 20;            % [Number of load cycles in 1 session]
F_a = 1.12;              % crack shape function     
sigma_n_k = @(x) sigma_n_0*sqrt(x/a_0);    % standart deviation
a_lim = 80;              %   max crack length        [mm]
a(1) = a_0;
N(1) = 0;

rng(100201);
figure
scatter(0,a(1),"x");
grid on
hold on
kk = 1;
while a(kk) <= a_lim
   kk = kk + 1;
  N(kk) = N(kk-1) + delta_N;
   
   if N <= 3.5e3 
	   delta_S = 33.7;
   elseif N <= 7.5e3
       delta_S = 16;
   else
       delta_S = 27;
   end     

    a(kk) = a(kk-1) + delta_N*C*(F_a*delta_S*sqrt(pi*a(kk-1)))^m;
    a_noise(kk) = a(kk) + randn()*sigma_n_k(a(kk));
     
%     scatter(N(kk-1),a(kk),"x");
%     pause(0.001);
end
figure 
plot(N,a_noise,N,a,".","MarkerSize",4);