% K-means algorithm is used to produce the mean values of the gaussian for the GMM
% algorithm with 3 gaussians (we have 3 gaussians so we need 3 mean values) as described in the book page 742
 
%xarakt are the characteristics features Nx7 dimension
%c is a class decleration
%m1 is a random mean value that initiates the kmean algorithm
function [mj1 mj2 mj3]=kMeansAlgorithm(xarakt,classes,m1,N,c)
th1=m1;
th2=m1+.1;
th3=m1+.2;
th=zeros(3,5);
th(1,:)=th1;
th(2,:)=th2;
th(3,:)=th3;
for i=1:10000
    tot=0;
     for k=2:N
     if(classes(k)==c)      
    tot=tot+1;
     end
     end
     b=zeros(1,tot);
     tot1=0;
    for k=2:N
     if(classes(k)==c)
    xnorm=zeros(1,3);     
    tot1=tot1+1;
    for ii=1:3
      xnorm(ii)=norm(th(ii,:)-(xarakt(k,:)+.00001));  
    end
    b(tot1)=find(xnorm==min(xnorm));
     end
    end
    for j=1:3
      sumj=zeros(1,3);  
      sum=zeros(3,5);
      tot1=0;
      for kk=2:N
          if(classes(kk)==c)
          tot1=tot1+1;
       if(b(tot1)==j)
         sumj(j)=sumj(j)+1;
         sum(j,:)=sum(j,:)+xarakt(kk,:);
       end
          end
      end
      th(j,:)=sum(j,:)/sumj(j);
    end
    eps=0.05;
    a1=norm(th(1,:)-th1);
    a2=norm(th(2,:)-th2);
    a3=norm(th(3,:)-th3); 
    if(a1<=eps&&a2<=eps&&a3<=eps)
        i
     mj1=th(1,:);
     mj2=th(2,:);
     mj3=th(3,:);     
     return
    else
     th1=th(1,:);
     th2=th(2,:);
     th3=th(3,:);
    end
end
     