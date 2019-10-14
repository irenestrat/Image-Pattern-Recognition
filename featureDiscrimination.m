% Implement algorithm scalar feature selection from S.Theodoridis,
% K. Koutroumbas Pattern Recognition book edition 2009 page 283
% with Fisher’s discriminant ratio ( FDR1 ) results from page 282 
%with ?i as the mean value of the characteristic in the class ?i and ?i^2
%the variance of this characteristic in the class ?i.

% This algorithm is implemented in order to choose the best characteristic
% of the 7 features that distinguish the 3 classes with the most
% appropriate way.
clc;
clear all;
load('results.mat','newCharacteristics','classesnew');
x=newCharacteristics; % Nx7
class=classesnew; 
meanValue=zeros(7,3); % mean value of each characteristic in each one of the three classes
s2d=zeros(7,3); % variance matrix of each characteristic in each one of the three classes
tot=size(x,1); 
tot1=0; % number of elements in class 1
tot2=0; % number of elements in class 2
tot3=0; % number of elements in class 3
 for i=2:tot
   if(class(i)==1)   % find the mean value of each characteristic in class 1
    tot1=tot1+1;
    meanValue(1,1)=meanValue(1,1)+x(i,1);
    meanValue(2,1)=meanValue(2,1)+x(i,2);
    meanValue(3,1)=meanValue(3,1)+x(i,3);
    meanValue(4,1)=meanValue(4,1)+x(i,4);
    meanValue(5,1)=meanValue(5,1)+x(i,5);
    meanValue(6,1)=meanValue(6,1)+x(i,6);
    meanValue(7,1)=meanValue(7,1)+x(i,7);
   elseif(class(i)==2) % class 2
    tot2=tot2+1;
    meanValue(1,2)=meanValue(1,2)+x(i,1);
    meanValue(2,2)=meanValue(2,2)+x(i,2);
    meanValue(3,2)=meanValue(3,2)+x(i,3);
    meanValue(4,2)=meanValue(4,2)+x(i,4);
    meanValue(5,2)=meanValue(5,2)+x(i,5);
    meanValue(6,2)=meanValue(6,2)+x(i,6);
    meanValue(7,2)=meanValue(7,2)+x(i,7);
   else 
    tot3=tot3+1;
    meanValue(1,3)=meanValue(1,3)+x(i,1);
    meanValue(2,3)=meanValue(2,3)+x(i,2);
    meanValue(3,3)=meanValue(3,3)+x(i,3);
    meanValue(4,3)=meanValue(4,3)+x(i,4);
    meanValue(5,3)=meanValue(5,3)+x(i,5);
    meanValue(6,3)=meanValue(6,3)+x(i,6);
    meanValue(7,3)=meanValue(7,3)+x(i,7);
   end
 end
 meanValue(:,1)=meanValue(:,1)/tot1;
 meanValue(:,2)=meanValue(:,2)/tot2;
 meanValue(:,3)=meanValue(:,3)/tot3;
 %co=0;
 for i=2:tot
  if(class(i)==1)   % find the variance of each characteristic in class 1 etc
   s2d(1,1)=s2d(1,1)+(x(i,1)-meanValue(1,1))^2. ;
   s2d(2,1)=s2d(2,1)+(x(i,2)-meanValue(2,1))^2. ;
   s2d(3,1)=s2d(3,1)+(x(i,3)-meanValue(3,1))^2. ;
   s2d(4,1)=s2d(4,1)+(x(i,4)-meanValue(4,1))^2. ;
   s2d(5,1)=s2d(5,1)+(x(i,5)-meanValue(5,1))^2. ;
   s2d(6,1)=s2d(6,1)+(x(i,6)-meanValue(6,1))^2. ;
   s2d(7,1)=s2d(7,1)+(x(i,7)-meanValue(7,1))^2. ;
  elseif(class(i)==2)
   s2d(1,2)=s2d(1,2)+(x(i,1)-meanValue(1,2))^2. ;
   s2d(2,2)=s2d(2,2)+(x(i,2)-meanValue(2,2))^2. ;
   s2d(3,2)=s2d(3,2)+(x(i,3)-meanValue(3,2))^2. ;
   s2d(4,2)=s2d(4,2)+(x(i,4)-meanValue(4,2))^2. ;
   s2d(5,2)=s2d(5,2)+(x(i,5)-meanValue(5,2))^2. ;
   s2d(6,2)=s2d(6,2)+(x(i,6)-meanValue(6,2))^2. ;
   s2d(7,2)=s2d(7,2)+(x(i,7)-meanValue(7,2))^2. ;   
  else
   s2d(1,3)=s2d(1,3)+(x(i,1)-meanValue(1,3))^2. ;
   s2d(2,3)=s2d(2,3)+(x(i,2)-meanValue(2,3))^2. ;
   s2d(3,3)=s2d(3,3)+(x(i,3)-meanValue(3,3))^2. ;
   s2d(4,3)=s2d(4,3)+(x(i,4)-meanValue(4,3))^2. ;
   s2d(5,3)=s2d(5,3)+(x(i,5)-meanValue(5,3))^2. ;
   s2d(6,3)=s2d(6,3)+(x(i,6)-meanValue(6,3))^2. ;
   s2d(7,3)=s2d(7,3)+(x(i,7)-meanValue(7,3))^2. ;  
  end 
 end
 s2d(:,1)=s2d(:,1)/(tot1-1); % devide by N-1 where N: number of elements in the class
 s2d(:,2)=s2d(:,2)/(tot2-1);
 s2d(:,3)=s2d(:,3)/(tot3-1);
 
 fdr=zeros(1,7); % FDR1 type as described in the book 
 for i=1:7
  fdr(i)=fdr(i)+(meanValue(i,1)-meanValue(i,2))^2/(s2d(i,1)+s2d(i,2))+...
   (meanValue(i,2)-meanValue(i,3))^2/(s2d(i,2)+s2d(i,3))+...
   (meanValue(i,3)-meanValue(i,1))^2/(s2d(i,3)+s2d(i,1));
 end
 i1=find(fdr==max(fdr)); % i1 is the characteristic 1 that the algorithm chooses, it must be a number in range 1 to 7
 % characteristic 2
 % choose a1=0.7 and a2=0.3 for scalar feature selection
 % these values can be chosen after experimentation for crossCorrelationCoefficient and FDR
 a1=.9;
 a2=.1;
 xar2=zeros(6,2);
 cou=0;
 for j=1:7
     if(j~=i1) % fdr argmax
       cou=cou+1;
       xar2(cou,1)=a1*fdr(j)-a2*abs(crossCorrelationCoefficient(x,tot,i1,j));
       xar2(cou,2)=j;
     end
 end
 ii2=find(xar2(:,1)==max(xar2(:,1)));
 i2=xar2(ii2,2);
 % characteristic 3
 xar3=zeros(5,2);
 cou=0;
 for j=1:7
  if(j~=i1&j~=i2)
  cou=cou+1;
  xar3(cou,1)=a1*fdr(j)-.5*a2*(abs(crossCorrelationCoefficient(x,tot,i1,j))+abs(crossCorrelationCoefficient(x,tot,i2,j)));
  xar3(cou,2)=j;
  end
 end
 ii3=find(xar3(:,1)==max(xar3(:,1)));
 i3=xar3(ii3,2);
 % characteristic 4
 xar4=zeros(4,2);
 cou=0;
 for j=1:7
  if(j~=i1&j~=i2&j~=i3)
  cou=cou+1;
  xar4(cou,1)=a1*fdr(j)-(a2/3.)*(abs(crossCorrelationCoefficient(x,tot,i1,j))+...
  abs(crossCorrelationCoefficient(x,tot,i2,j))+abs(crossCorrelationCoefficient(x,tot,i3,j)));
  xar4(cou,2)=j;
  end
 end
 ii4=find(xar4(:,1)==max(xar4(:,1)));
 i4=xar4(ii4,2);
 % characteristic 5
 xar5=zeros(3,2);
 cou=0;
 for j=1:7
  if(j~=i1&j~=i2&j~=i3&j~=i4)
  cou=cou+1;
  xar5(cou,1)=a1*fdr(j)-(a2/4.)*(abs(crossCorrelationCoefficient(x,tot,i1,j))+...
  abs(crossCorrelationCoefficient(x,tot,i2,j))+abs(crossCorrelationCoefficient(x,tot,i3,j))+abs(crossCorrelationCoefficient(x,tot,i4,j)));
  xar5(cou,2)=j;
  end
 end
 ii5=find(xar5(:,1)==max(xar5(:,1)));
 i5=xar5(ii5,2);
 
 % IMPORTANT NOTE !
 % THE ALGORITHM IS ENDED IN CHARACTERISTIC 5 BECAUSE FOR 6 AND 7 THE TWO
 % NUMBERS THAT THE ALGORITHM CHOOSE COULD NOT BE DISTINGUISHED AS THEY
 % WERE ALMOST THE SAME. EVEN FOR THE 5TH CHARACTERISTIC IT WAS DIFFICULT
 % DISCRIMINATION SINCE THE THREE VALUES WERE ALMOST THE SAME!
 