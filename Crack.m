% PROBLEM DEFINITION:PARAMETER DEFINITION 

WorkName = 'Crack';
TimeUnit = 'cycles';
dN = 20;
measureData = [0.0119 0.0103 0.0118 0.0095 0.0085 0.0122 0.0110 0.0120 0.0113 0.0122 0.0110 0.0124 0.0117 0.0138 0.0127 0.0115 0.0135 0.0124 0.0141 0.0160 0.0157 0.0149 0.0156 0.0153 0.0155];
thres=0.0463;
ParamName=['a';'m'; 'C'; 's'];
initDisPar=[0.01 5e-4; 4 0.2; -22.33 1.12; 0.001 0]; 
       % probability paramaters of initial distrubution, pxq 
       % (p: num. of param, q: num. of probability param)     
n = 5e3;
signiLevel=2.5; 
delSigma=78;
%%%  PROGNOSTICS  using PARTICLE FILTER
p=size(ParamName,1);
for j=1:p;
param(j,:)=normrnd(initDisPar(j,1),initDisPar(j,2),1,n);
ParamResul (j,:)=[ParamName(j,:) 'Resul'];
eval([ParamResul(j,:) '=param(j,:);']);
end
k1=length(measureData) ; k=1;
if measureData(end)-measureData(1)<0; cofec =-1 ; else cofec=1; end
while min(eval([ParamResul(1,:) '(k,:)'])*cofec)<thres*cofec; k=k+1 ;
   %step1.prediction (prior)
paramPredi= param;
for j=1:p; eval([ParamName(j,:) '=paramPredi(j,:);']); end
paramPredi(1,: )= ...  % PROBLEM DEFINITION:MODEL DEFINITION
exp(C).*(delSigma.*sqrt(pi*a)).^m.*dN+a;
if k<k1
%step2. updqte (likehood)
sigl=sqrt(log(1+(paramPredi(end,:)./ paramPredi(1,:)).^2)); mul=log(paramPredi(1,:))-0.5*sigl.^2; likel=lognpdf(measureData(k),mul,sigl);
%step3. resampling
cdf = cusum(likel)./max(sum(likel));
for i= 1:n ;
u= rand ;
loca=find(cdf >= u);
param(:,i)=paramPredi(:,loca(1));
end
else                                        % (Prognosis)
param = paramPredi;
end
for j=1:p; eval([ParamResul(j,:) '(k,:)=param(j,:);']); end
if k>k1
sigl=sqrt(log(1+(param(end,:)./param(1,:)).^2)); mul=log(param(1,:))-0.5*sigl.^2; eval([ParamResul(1,:) '(k,:)= lognrnd (mul,sigl,1,n);']);
end
end
 %%% POST_PROCESSING
 time=[0:dN:dN*(k-1)]';
perceValue=[50 signiLevel 100-signiLevel];
for i=1:n;
loca=find(eval([ParamResul(1,:) '(:,i)'])*cofec>=t*cofec);
Rul(i)=time(loca(1))-ti(k1);
end
RULPerce=prctile(RUL',perceValue);
figure; set(gca,'frontsize',14); hist(RUL,30);
xlim([min(RUL) max(RUL)]);
xlabel(['RUL'  ('TimeUnit')]);
titleName=['at' num2str(time(k1)) '' TimeUnit]; 
title(titleName)
fprintf('\n # Percentiles of RUL at %g cyles \n', time(k1))
fprintf('\n %gprct: %g, median: %g, %gprct: %g\n',perceValue(2), RULPerce(2),RULPerce(1),perceValue(3),RULPerce(3))
Name=[WorkName ' at' num2str(time(k1)) '.mat']; save(Name);