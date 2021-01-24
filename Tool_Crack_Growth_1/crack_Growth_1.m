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
delta_N = 20;            % [Number of load cycles in 1 session]
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
    

%    scatter(delta_N*(kk-1),a(kk),"x");
%    pause(0.001);
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
   
   if N <= 3.5e5 
      delta_S = 33.7;
   elseif N <= 7.5e5
       delta_S = 16;
   else
       delta_S = 27;
   end     

   a(kk) = a(kk-1) + delta_N*C*(F_a*delta_S*sqrt(pi*a(kk-1)))^m;
   a_noise(kk) = a(kk) + randn()*sigma_n_k(a(kk));
     
%   scatter(N(kk-1),a(kk),"x");
%   pause(0.001);
end

%figure 
plot(N,a_noise,N,a,".","MarkerSize",4);

%% section 3 more then 3 delta_S

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
   
   if N <= 7.5e4 
	   delta_S = 33.7;
   elseif N <= 1.5e5
       delta_S = 16;
   elseif N <= 3.5e5
       delta_S = 27;
   elseif N <= 6.5e5
       delta_S = 15;
   elseif N <= 9.5e5
       delta_S = 25;
   elseif N <= 11e5
       delta_S = 20;
   else 
       delta_S = 30;
   end     

   a(kk) = a(kk-1) + delta_N*C*(F_a*delta_S*sqrt(pi*a(kk-1)))^m;
   a_noise(kk) = a(kk) + randn()*sigma_n_k(a(kk));
     
%   scatter(N(kk-1),a(kk),"x");
%   pause(0.001);
end

%figure 
plot(N,a_noise,N,a,".","MarkerSize",4);

%% Section -4 storing data with structures
clc
clear all

struct_size = 3;
data1(struct_size) = struct();

a_0 = 3 ;                % Initial crack length [mm]
sigma_n_0 = sqrt(0.2);   % Initial standart deviation  [mm]
C = 2.381e-12;           %  [mm/cycle(Mpa.(mm^0.5))^-m]
m = 3.2;                 %  
delta_S = 40;            % stress amplitude     [MPa]
delta_N = 1000;            % [Number of load cycles in 1 session]
F_a = 1.12;              % crack shape function     
sigma_n_k = @(x) sigma_n_0*sqrt(x/a_0);    % standart deviation
a_lim = 80;              %   max crack length        [mm]


for ss = 1:struct_size
    a(1) = a_0;
    N(1) = 0;
    a_noise(1) = a_0;
    
    data1(ss).randomseed = ss;
    rng(data1(ss).randomseed); % THIS IS THE SEEDING OF RANDOM
    
    data1(ss).a_0 = a_0; % Initial crack length [mm]
    data1(ss).sigma_n_0 = sigma_n_0;   % Initial standart deviation  [mm]
    data1(ss).C = C;           %  [mm/cycle(Mpa.(mm^0.5))^-m]
    data1(ss).m = m;
    
    data1(ss).delta_S = delta_S;            % stress amplitude     [MPa]
    data1(ss).delta_S_noise = random('Uniform',delta_S*(0.95),delta_S*(1.05));
    
    data1(ss).delta_N = delta_N;            % [Number of load cycles in 1 session]
    data1(ss).F_a = F_a;              % crack shape function   
    data1(ss).sigma_n_k = sigma_n_k;    % standart deviation
    data1(ss).a_lim = a_lim;              %   max crack length        [mm]
    
    kk = 1;
    while a(kk) <= a_lim 
        kk = kk + 1;
        N(kk) = N(kk-1) + delta_N;
        
        a(kk) = a(kk-1) + ...
            delta_N*C*(F_a*data1(ss).delta_S_noise*sqrt(pi*a(kk-1)))^m;
        a_noise(kk) = a(kk) + randn()*sigma_n_k(a(kk));
%        scatter(delta_N*(kk-1),a(kk),"x");
%        pause(0.001);
    end
    data1(ss).N = N;
    data1(ss).a = a;
    data1(ss).a_noise = a_noise;
    
    clear N;
    clear a;
    clear a_noise;
    
    figure
    plot(data1(ss).N,data1(ss).a_noise)
    hold on
    plot(data1(ss).N,data1(ss).a,"Linewidth",1.7)
end

%%
figure
plot(data1(1).N,data1(1).a_noise)
hold on
plot(data1(2).N,data1(2).a_noise)
plot(data1(3).N,data1(3).a_noise)
legend("\Delta S = 41.6232 MPa","\Delta S = 39.2751 MPa","\Delta S = 39.7935 MPa");