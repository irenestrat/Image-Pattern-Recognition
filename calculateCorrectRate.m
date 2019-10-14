% For the model with 3 different gaussians per class in this file it is
% calculated the correct rate.

clc;
clear all;
load('results.mat','newCharacteristics','classesnew');
x=newCharacteristics;
classes=classesnew;
x=[x(:,1) x(:,2) x(:,3) x(:,4) x(:,5)];
N=length(x(:,1));
P11=0.333;
P33=0.334;
m=[0.3 .3 .3 .3 .3];
s=0.1;
meanValue1=zeros(3,5); 
meanValue2=zeros(3,5);
meanValue3=zeros(3,5);
meanValue11=zeros(3,5);
meanValue22=zeros(3,5);
s2=zeros(3,3);
P1=zeros(1,3);
P2=zeros(1,3);
P3=zeros(1,3);
%class 1
c=1;
 [meanValue11(1,:) meanValue11(2,:) meanValue11(3,:)]=kMeansAlgorithm(x,classes,m,N,c);
[meanValue1(1,:) meanValue1(2,:) meanValue1(3,:) s2(1,1) s2(1,2) s2(1,3) P1(1) P1(2)... 
    P1(3)]=GaussianMixtureModel(x,classes,meanValue11(1,:),meanValue11(2,:),meanValue11(3,:),s,s+.05,...
    s+.1,P11,P11,P33,N,c);
%class 2
c=2;
[meanValue22(1,:) meanValue22(2,:) meanValue22(3,:)]=kMeansAlgorithm(x,classes,m,N,c);
s=s+.05;
[meanValue2(1,:) meanValue2(2,:) meanValue2(3,:) s2(2,1) s2(2,2) s2(2,3) P2(1) P2(2)... 
    P2(3)]=GaussianMixtureModel(x,classes,meanValue22(1,:),meanValue22(2,:),meanValue22(3,:),s,s+.05,...
    s+.1,P11,P11,P33,N,c);
%class 3
m=m+.1;
s=s+.05;
c=3;
[meanValue3(1,:) meanValue3(2,:) meanValue3(3,:) s2(3,1) s2(3,2) s2(3,3) P3(1) P3(2)... 
    P3(3)]=GaussianMixtureModel(x,classes,m,m+.1,m+.2,s,s+.06,s+.1,P11,P11,P33,N,c);
% After the learning part of the GMM model has been completed it is time to
% classify the 20 new pictures and calculate the correct rate of them. 
load('final_results.mat','newCharacteristics','classesnew');
xar=newCharacteristics;
clas=classesnew;
N=length(clas);
sum=0;
for k=2:N
 sump11=0;
 sump12=0;
 sump13=0;
 sump21=0;
 sump22=0;
 sump23=0;
 sump31=0;
 sump32=0;
 sump33=0;
 for j=1:5
  sump11=sump11+(xar(k,j)-meanValue1(1,j))^2.;
  sump12=sump12+(xar(k,j)-meanValue1(2,j))^2.;
  sump13=sump13+(xar(k,j)-meanValue1(3,j))^2.;
  sump21=sump21+(xar(k,j)-meanValue2(1,j))^2.;
  sump22=sump22+(xar(k,j)-meanValue2(2,j))^2.;
  sump23=sump23+(xar(k,j)-meanValue2(3,j))^2.;
  sump31=sump31+(xar(k,j)-meanValue3(1,j))^2.;
  sump32=sump32+(xar(k,j)-meanValue3(2,j))^2.;
  sump33=sump33+(xar(k,j)-meanValue3(3,j))^2.;
 end
 pxk_11=(1./power(2*pi*s2(1,1),5/2))*exp(-sump11/(2*s2(1,1)));
 pxk_12=(1./power(2*pi*s2(1,2),5/2))*exp(-sump12/(2*s2(1,2)));
 pxk_13=(1./power(2*pi*s2(1,3),5/2))*exp(-sump13/(2*s2(1,3)));
 cla1=P1(1)*pxk_11+P1(2)*pxk_12+P1(3)*pxk_13;
 pxk_21=(1./power(2*pi*s2(2,1),5/2))*exp(-sump21/(2*s2(2,1)));
 pxk_22=(1./power(2*pi*s2(2,2),5/2))*exp(-sump22/(2*s2(2,2)));
 pxk_23=(1./power(2*pi*s2(2,3),5/2))*exp(-sump23/(2*s2(2,3)));
 cla2=P2(1)*pxk_21+P2(2)*pxk_22+P2(3)*pxk_23;
 pxk_31=(1./power(2*pi*s2(3,1),5/2))*exp(-sump31/(2*s2(3,1)));
 pxk_32=(1./power(2*pi*s2(3,2),5/2))*exp(-sump32/(2*s2(3,2)));
 pxk_33=(1./power(2*pi*s2(3,3),5/2))*exp(-sump33/(2*s2(3,3)));
 cla3=P3(1)*pxk_31+P3(2)*pxk_32+P3(3)*pxk_33;
 clasi=[cla1 cla2 cla3];
 cla=find(clasi==max(clasi));
 if(clas(k)==cla)
     sum=sum+1;
 end
end
 corect=sum/(N-1)