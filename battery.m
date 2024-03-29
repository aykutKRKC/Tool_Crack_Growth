clc
clear all

% PROBLEM DEFINITION:PARAMETER DEFINITION 

WorkName = 'Battery';
TimeUnit = 'weeks';
dt = 5;
measureData = [1.0000 0.9351 0.8512 0.9028 0.7754 0.7114 0.6830 0.6147 0.5628 0.7090];
thres=0.3;
ParamName=['x';'b';'s'];
initDisPar=[0.9 1.1; 0 0.05; 0.01 0.1]; 
       % probability paramaters of initial distrubution, pxq 
       % (p: num. of param, q: num. of probability param)     
n = 5e3;
signiLevel=5; 
delSigma=78;
%%%  PROGNOSTICS  using PARTICLE FILTER
p=size(ParamName,1);
for j=1:p;
param(j,:)=unifrnd(initDisPar(j,1),initDisPar(j,2),1,n);
ParamResul (j,:)=[ParamName(j,:) 'Resul'];
eval([ParamResul(j,:) '=param(j,:);']);
end
k1=length(measureData) ; 
k=1;
if measureData(end)-measureData(1)<0; cofec =-1 ; else cofec=1; end
while min(eval([ParamResul(1,:) '(k,:)'])*cofec)<thres*cofec; k=k+1 ;
   %step1.prediction (prior)
paramPredi= param;
for j=1:p; eval([ParamName(j,:) '=paramPredi(j,:);']); end
paramPredi(1,:)=...  % PROBLEM DEFINITION:MODEL DEFINITION
exp(-b.*dt).*x;
if k<k1
%step2. updqte (likehood)

likel= normpdf(measureData(k),paramPredi(1,:),paramPredi(end,:));
%step3. resampling
  cdf = cusum(likel)./max(sum(likel));
  %% 
  
for i= 1:n ;
 u = 10;
 loca = find(cdf>=u); 
param(:,i)=paramPredi(:,loca(1,1));
 end
else                                        % (Prognosis)
param = paramPredi;
end
for j=1:p; eval([ParamResul(j,:) '(k,:)=param(j,:);']); end
if k>k1 
eval([ParamResul(1,:) '(k,:)= normrnd(param(1,:),param(end,:));']);
 end
end
 %%% POST_PROCESSING
 time=[0:dt:dt*(k-1)]';
perceValue=[50 signiLevel 100-signiLevel];
for i=1:n;
loca=find(eval([ParamResul(1,:) '(:,i)'])*cofec>=thres*cofec);
Rul(i)=time(loca(1))-time(k1);
end
RULPerce=prctile(Rul',perceValue);
figure; set(gca,'fontsize',14); hist(Rul,30);
xlim([min(Rul) max(Rul)]);
xlabel(['Rul'  ('TimeUnit')]);
titleName=['at' num2str(time(k1)) '' TimeUnit]; 
title(titleName)
fprintf('\n # Percentiles of RUL at %g weeks \n', time(k1))
fprintf('\n %gprct: %g, median: %g, %gprct: %g\n',perceValue(2), RULPerce(2),RULPerce(1),perceValue(3),RULPerce(3))
Name=[WorkName ' at' num2str(time(k1)) '.mat']; save(Name);
