% This file implements the Expectation Maximization algorithm for the gmm
% model with three gaussian mixture per class page 47 from book 

function [mj1 mj2 mj3 sj1 sj2 sj3 Pj1 Pj2 Pj3]=GaussianMixtureModel(xarakt,classes,...
m1,m2,m3,s1,s2,s3,P1,P2,P3,N,c)
dimension=length(m1);
for i=1:10000
    tot=0;
 for k=2:N
  if(classes(k)==c)
   tot=tot+1;
 sump1=0;
 sump2=0;
 sump3=0;
 for j=1:dimension
  sump1=sump1+(xarakt(k,j)-m1(j))^2.;
  sump2=sump2+(xarakt(k,j)-m2(j))^2.;
  sump3=sump3+(xarakt(k,j)-m3(j))^2.;
 end
 pxk_1(tot)=(1./power(2*pi*s1,dimension/2))*exp(-sump1/(2*s1));
 pxk_2(tot)=(1./power(2*pi*s2,dimension/2))*exp(-sump2/(2*s2));
 pxk_3(tot)=(1./power(2*pi*s3,dimension/2))*exp(-sump3/(2*s3));
 end
 end
for j=1:tot
 pxk_th(j)=pxk_1(j)*P1+pxk_2(j)*P2+pxk_3(j)*P3;
end
for j=1:tot
 p1_xk(j)=pxk_1(j)*P1/pxk_th(j);
 p2_xk(j)=pxk_2(j)*P2/pxk_th(j);
 p3_xk(j)=pxk_3(j)*P3/pxk_th(j);
end
% calculate new m s Pj
sum1=0;
sum2=0;
sum3=0;
for j=1:tot
 sum1=sum1+p1_xk(j); 
 sum2=sum2+p2_xk(j);   
 sum3=sum3+p3_xk(j); 
end
%calculate mean value 
x1=zeros(1,dimension);
x2=x1;
x3=x1;
tot=0;
for k=2:N
    
 if(classes(k)==c)
     tot=tot+1;
 for j=1:dimension   
 x1(j)=x1(j)+p1_xk(tot)*xarakt(k,j);
 x2(j)=x2(j)+p2_xk(tot)*xarakt(k,j);
 x3(j)=x3(j)+p3_xk(tot)*xarakt(k,j);
 end
 end
end
m1new=x1/sum1;
m2new=x2/sum2;
m3new=x3/sum3;
% calculate variance
sums1=0;
sums2=0;
sums3=0;
tot=0;
for k=2:N
 sumss1=0;
 sumss2=0;
 sumss3=0;
 if(classes(k)==c)
     tot=tot+1;
 for j=1:dimension
   sumss1=sumss1+(xarakt(k,j)-m1new(j))^2.;
   sumss2=sumss2+(xarakt(k,j)-m2new(j))^2.;
   sumss3=sumss3+(xarakt(k,j)-m3new(j))^2.;
 end  
sums1=sums1+p1_xk(tot)*sumss1;
sums2=sums2+p2_xk(tot)*sumss2;
sums3=sums3+p3_xk(tot)*sumss3;
 end
end
s1new=sums1/(dimension*sum1);
s2new=sums2/(dimension*sum2);
s3new=sums3/(dimension*sum3);
% calculate Pj
P1new=sum1/tot;
P2new=sum2/tot;
P3new=sum3/tot;
% check for exiting the algorithm
new=[m1new m2new m3new s1new s2new s3new P1new P2new P3new];
old=[m1 m2 m3 s1 s2 s3 P1 P2 P3];
eps=.005;
if(norm(new-old)<=eps)
   i
 mj1=m1new;
 mj2=m2new;
 mj3=m3new;
 sj1=s1new;
 sj2=s2new;
 sj3=s3new;
 Pj1=P1new;
 Pj2=P2new;
 Pj3=P3new;
 return
else
 P1=P1new;
 P2=P2new;
 P3=P3new;
 m1=m1new;
 m2=m2new;
 m3=m3new;
 s1=s1new;
 s2=s2new;
 s3=s3new;
end 
end