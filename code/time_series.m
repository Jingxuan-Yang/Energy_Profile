clc,clear
a=textread('CA.txt');  
a=nonzeros(a'); 
r11=autocorr(a)   
r12=parcorr(a)   
da=diff(a);      
r21=autocorr(da)  
r22=parcorr(da)   
n=length(da);  
k=0; 
for i=0:3
    for j=0:3
        if i==0 & j==0
            continue
        elseif i==0
            ToEstMd=arima('MALags',1:j,'Constant',0); 
        elseif j==0
            ToEstMd=arima('ARLags',1:i,'Constant',0); 
        else
            ToEstMd=arima('ARLags',1:i,'MALags',1:j,'Constant',0); 
        end
        k=k+1; R(k)=i; M(k)=j;
        [EstMd,EstParamCov,logL,info]=estimate(ToEstMd,da); 
        numParams = sum(any(EstParamCov)); 
        %compute Akaike and Bayesian Information Criteria
        [aic(k),bic(k)]=aicbic(logL,numParams,n);
    end
end
fprintf('R,M,AIC,BIC values:\n %f');  
check=[R',M',aic',bic']
r=input('R?');m=input('M?');
ToEstMd=arima('ARLags',1:r,'MALags',1:m,'Constant',0); 
[EstMd,EstParamCov,logL,info]=estimate(ToEstMd,da); 
dx_Forecast=forecast(EstMd,50,'Y0',da)  
x_Forecast=a(end)+cumsum(dx_Forecast)   
