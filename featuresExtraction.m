%In this file the feature extraction is implemented. 

%Each image contain 2400 x 3500 pixels. We seperate these pixels into groups of 5x5 pixels so
%we end up with approximatelly 336000 groups of pixels. In every group of
%these, we extract 7 features as described in the paper and we end up with feature
%vector. So each image contains 336000 feature vectors. We repeat this
%procedure for 50 images .jpeg in order for the algorithm Gaussian Mixture
%Model to learn the approximate parameters of the problem. 
%
% IMPORTANT NOTE: THIS FILE MUST BE CONTAINED IN THE SAME FOLDER AS THE
% 50 IMAGES OF THE DATASET!
clc;
clear all;
initialFeatureVector=zeros(1,7);
initializeClasses=zeros(1);
for k=1:50 % run this for each image of 50 from the given dataset
  jpg1 = strcat(num2str(k), '.jpg'); %read images
  png1= strcat(num2str(k), '_m.png'); 
  [b,map] = imread(jpg1);    
  [c1,map]=imread(png1);
%index for image,text ,background : 1 -image, 2-text, 3-background
a=rgb2gray(b);
size1=size(b,1); % 2400 pixels
size2=size(b,2); % 3500 pixels 
cc=a;
a=double(a);
a=a/255;  
%choose blocks of 5x5 pixels
divisionRemainderAxis1=mod(size1,5);  
divisionRemainderAxis2=mod(size2,5);
numberOfBlocksAxis1=(size1-divisionRemainderAxis1)/5;
numberOfBlocksAxis2=(size2-divisionRemainderAxis2)/5;
if(divisionRemainderAxis1~=0)
  numberOfBlocksAxis1=numberOfBlocksAxis1+1;
end
if(divisionRemainderAxis2~=0)
  numberOfBlocksAxis2=numberOfBlocksAxis2+1;
end
Thres=.03;  % random choice of threshold - you can play with this value to see what it's best
[gmag,gdir]=imgradient(a);
gmax=max(max(gmag)); 
gmag=gmag/gmax;  %values from 0 to 1, normalization
IntenseMean=zeros(numberOfBlocksAxis1*numberOfBlocksAxis2,1);   %mean intensity of block from 0 to 1 
intenseMeanHelpVariable=zeros(numberOfBlocksAxis1,numberOfBlocksAxis2);    %it is used to calculate the difference between each blocks intensity
std2=zeros(numberOfBlocksAxis1*numberOfBlocksAxis2,1);    %standard deviation matrix
dIxy_column=zeros(numberOfBlocksAxis1*numberOfBlocksAxis2,1); %the mean of the vertical, , and horizontal, ,derivatives of the block; as it is described in paper
mesodif_column=zeros(numberOfBlocksAxis1*numberOfBlocksAxis2,1); % the mean difference of the mean brightnesses of blocks Bk in the 4connected vicinity of the block Bi; as it is described in paper
above_thres=zeros(numberOfBlocksAxis1*numberOfBlocksAxis2,1); % the percentage of pixels with the gradient above the threshold;
meanDifference=zeros(numberOfBlocksAxis1,numberOfBlocksAxis2);  %the mean difference of the mean brightnesses of blocks Bk in the 4connected vicinity of the block Bi;
homogen=zeros(numberOfBlocksAxis1*numberOfBlocksAxis2,1); %homogenity characteristic as described in paper relation 22
energ=zeros(numberOfBlocksAxis1*numberOfBlocksAxis2,1); %energy characteristic as described in paper relation 21
col=zeros(numberOfBlocksAxis1*numberOfBlocksAxis2,1); %variable which contains the real classes of each block - three classes text, image and background represented as blue, red and grey
classes=zeros(numberOfBlocksAxis1*numberOfBlocksAxis2,1);
imageTotalBlockNumber=0; % take values from 1 to the total number of blocks of each image
for i=1:numberOfBlocksAxis1                   
 for j=1:numberOfBlocksAxis2
  imageTotalBlockNumber=imageTotalBlockNumber+1;   
  sumI=0;
  sum_s2=0;
  sumg=0;
  if(j<numberOfBlocksAxis2&i<numberOfBlocksAxis1) 
   color=zeros(5,5);   
   red=c1(5*(i-1)+(1:5),5*(j-1)+(1:5),1);
   green=c1(5*(i-1)+(1:5),5*(j-1)+(1:5),2);
   blue=c1(5*(i-1)+(1:5),5*(j-1)+(1:5),3);
   if(red(:)==255&green(:)==0&blue(:)==0)
    color(:)=1;
   elseif((red(:)==0&green(:)==0&blue(:)==255))
    color(:)=2;
   else
    color(:)=3; 
   end
   col(imageTotalBlockNumber)=mode(mode(color));
   homo=cc(5*(i-1)+(1:5),5*(j-1)+(1:5));
   homo1=graycoprops(graycomatrix(homo),{'Homogeneity','Energy'});
   homogen(imageTotalBlockNumber)=homo1.Homogeneity;
   energ(imageTotalBlockNumber)=homo1.Energy;
   %Mean intensity, gradient above threshold calculation  
   for k=1:5   
     for kk=1:5
      sumI=sumI+a(5*(i-1)+k,5*(j-1)+kk);
      if(gmag(5*(i-1)+k,5*(j-1)+kk)>=Thres) %gmag>= threashold
       sumg=sumg+1;
      end 
     end
   end
   IntenseMean(imageTotalBlockNumber)=sumI/25.;
   above_thres(imageTotalBlockNumber)=sumg/25.; 
   %variance
   for k=1:5   
     for kk=1:5
     sum_s2=sum_s2+(a(5*(i-1)+k,5*(j-1)+kk)-IntenseMean(imageTotalBlockNumber))^2.; 
     end
   end
   std2(imageTotalBlockNumber)=sqrt(sum_s2/25.);
  elseif(j==numberOfBlocksAxis2&i<numberOfBlocksAxis1)           
   if(divisionRemainderAxis2==0)                  
    color=zeros(5,5);    
    red=c1(5*(i-1)+(1:5),5*(j-1)+(1:5),1);
    green=c1(5*(i-1)+(1:5),5*(j-1)+(1:5),2);
    blue=c1(5*(i-1)+(1:5),5*(j-1)+(1:5),3);
    if(red(:)==255&green(:)==0&blue(:)==0)
     color(:)=1;
    elseif((red(:)==0&green(:)==0&blue(:)==255))
     color(:)=2;
    else
     color(:)=3; 
    end   
    col(imageTotalBlockNumber)=mode(mode(color)); 
    %homogenity
    homo=cc(5*(i-1)+(1:5),5*(j-1)+(1:5));
    homo1=graycoprops(graycomatrix(homo),{'Homogeneity','Energy'});
    homogen(imageTotalBlockNumber)=homo1.Homogeneity;   
    energ(imageTotalBlockNumber)=homo1.Energy;
    %Mean intensity, gradient above threshold 
    for k=1:5   
     for kk=1:5
      sumI=sumI+a(5*(i-1)+k,5*(j-1)+kk);
      if(gmag(5*(i-1)+k,5*(j-1)+kk)>=Thres)   
       sumg=sumg+1;
      end 
     end
    end
    IntenseMean(imageTotalBlockNumber)=sumI/25.;
    above_thres(imageTotalBlockNumber)=sumg/25.;
    %variance
    for k=1:5   
     for kk=1:5
     sum_s2=sum_s2+(a(5*(i-1)+k,5*(j-1)+kk)-IntenseMean(imageTotalBlockNumber))^2.; 
     end
    end
    std2(imageTotalBlockNumber)=sqrt(sum_s2/25.);
   else 
    color=zeros(5,divisionRemainderAxis2);    
    red=c1(5*(i-1)+(1:5),5*(j-1)+(1:divisionRemainderAxis2),1);
    green=c1(5*(i-1)+(1:5),5*(j-1)+(1:divisionRemainderAxis2),2);
    blue=c1(5*(i-1)+(1:5),5*(j-1)+(1:divisionRemainderAxis2),3);
    if(red(:)==255&green(:)==0&blue(:)==0)
     color(:)=1;
    elseif((red(:)==0&green(:)==0&blue(:)==255))
     color(:)=2;
    else
     color(:)=3; 
    end     
    col(imageTotalBlockNumber)=mode(mode(color));
    %homogenity
    homo=cc(5*(i-1)+(1:5),5*(j-1)+(1:divisionRemainderAxis2));
    homo1=graycoprops(graycomatrix(homo),{'Homogeneity','Energy'});
    homogen(imageTotalBlockNumber)=homo1.Homogeneity;
    energ(imageTotalBlockNumber)=homo1.Energy;
    %mean intesity, gradient above threshold 
    for k=1:5
     for kk=1:divisionRemainderAxis2
      sumI=sumI+a(5*(i-1)+k,5*(j-1)+kk);
      if(gmag(5*(i-1)+k,5*(j-1)+kk)>=Thres)   
       sumg=sumg+1;
      end 
     end
    end
    IntenseMean(imageTotalBlockNumber)=sumI/(divisionRemainderAxis2*5.); 
    above_thres(imageTotalBlockNumber)=sumg/(5.*divisionRemainderAxis2);
    %variance
    for k=1:5   
     for kk=1:divisionRemainderAxis2
     sum_s2=sum_s2+(a(5*(i-1)+k,5*(j-1)+kk)-IntenseMean(imageTotalBlockNumber))^2.; 
     end
    end
    std2(imageTotalBlockNumber)=sqrt(sum_s2/(divisionRemainderAxis2*5.));
   end 
  elseif(j<numberOfBlocksAxis2&i==numberOfBlocksAxis1)                                    
    if(divisionRemainderAxis1==0)
     color=zeros(5,5);    
     red=c1(5*(i-1)+(1:5),5*(j-1)+(1:5),1);
     green=c1(5*(i-1)+(1:5),5*(j-1)+(1:5),2);
     blue=c1(5*(i-1)+(1:5),5*(j-1)+(1:5),3);
     if(red(:)==255&green(:)==0&blue(:)==0)
      color(:)=1;
     elseif((red(:)==0&green(:)==0&blue(:)==255))
      color(:)=2;
     else
      color(:)=3; 
     end     
     col(imageTotalBlockNumber)=mode(mode(color));
      %homogeneity
     homo=cc(5*(i-1)+(1:5),5*(j-1)+(1:5));
     homo1=graycoprops(graycomatrix(homo),{'Homogeneity','Energy'});
     homogen(imageTotalBlockNumber)=homo1.Homogeneity;  
     energ(imageTotalBlockNumber)=homo1.Energy;
     %mean intensity, gradient above threshold  
     for k=1:5   
      for kk=1:5
       sumI=sumI+a(5*(i-1)+k,5*(j-1)+kk);
       if(gmag(5*(i-1)+k,5*(j-1)+kk)>=Thres)   
        sumg=sumg+1;
       end 
      end
     end
     IntenseMean(imageTotalBlockNumber)=sumI/25.;
     above_thres(imageTotalBlockNumber)=sumg/25.;
     %variance
     for k=1:5   
      for kk=1:5
       sum_s2=sum_s2+(a(5*(i-1)+k,5*(j-1)+kk)-IntenseMean(imageTotalBlockNumber))^2.; 
      end
     end
     std2(imageTotalBlockNumber)=sqrt(sum_s2/25.);
    else
      color=zeros(divisionRemainderAxis1,5);   
      red=c1(5*(i-1)+(1:divisionRemainderAxis1),5*(j-1)+(1:5),1);
      green=c1(5*(i-1)+(1:divisionRemainderAxis1),5*(j-1)+(1:5),2);
      blue=c1(5*(i-1)+(1:divisionRemainderAxis1),5*(j-1)+(1:5),3);
     if(red(:)==255&green(:)==0&blue(:)==0)
      color(:)=1;
     elseif((red(:)==0&green(:)==0&blue(:)==255))
      color(:)=2;
     else
      color(:)=3; 
     end     
     col(imageTotalBlockNumber)=mode(mode(color)); 
     %homogeneity
     homo=cc(5*(i-1)+(1:divisionRemainderAxis1),5*(j-1)+(1:5));
     homo1=graycoprops(graycomatrix(homo),{'Homogeneity','Energy'});
     homogen(imageTotalBlockNumber)=homo1.Homogeneity;
     energ(imageTotalBlockNumber)=homo1.Energy;
     %mean intensity, gradient above threshold    
     for k=1:divisionRemainderAxis1
      for kk=1:5
       sumI=sumI+a(5*(i-1)+k,5*(j-1)+kk);
       if(gmag(5*(i-1)+k,5*(j-1)+kk)>=Thres)   
        sumg=sumg+1;
       end 
      end
     end
     IntenseMean(imageTotalBlockNumber)=sumI/(5.*divisionRemainderAxis1);
     above_thres(imageTotalBlockNumber)=sumg/(5.*divisionRemainderAxis1);
     %variance
     for k=1:divisionRemainderAxis1   
      for kk=1:5
      sum_s2=sum_s2+(a(5*(i-1)+k,5*(j-1)+kk)-IntenseMean(imageTotalBlockNumber))^2.; 
      end
     end
     std2(imageTotalBlockNumber)=sqrt(sum_s2/(divisionRemainderAxis1*5.));
    end
  elseif(i==numberOfBlocksAxis1&j==numberOfBlocksAxis2)                                       
   if(divisionRemainderAxis1==0&divisionRemainderAxis2==0)
     color=zeros(5,5);   
     red=c1(5*(i-1)+(1:5),5*(j-1)+(1:5),1);
     green=c1(5*(i-1)+(1:5),5*(j-1)+(1:5),2);
     blue=c1(5*(i-1)+(1:5),5*(j-1)+(1:5),3);
     if(red(:)==255&green(:)==0&blue(:)==0)
      color(:)=1;
     elseif((red(:)==0&green(:)==0&blue(:)==255))
      color(:)=2;
     else
      color(:)=3; 
     end   
     col(imageTotalBlockNumber)=mode(mode(color));
    %homogeneity
    homo=cc(5*(i-1)+(1:5),5*(j-1)+(1:5));
    homo1=graycoprops(graycomatrix(homo),{'Homogeneity','Energy'});
    homogen(imageTotalBlockNumber)=homo1.Homogeneity;   
    energ(imageTotalBlockNumber)=homo1.Energy;
    %mean intensity, gradient above threshold   
    for k=1:5   
     for kk=1:5
      sumI=sumI+a(5*(i-1)+k,5*(j-1)+kk);
      if(gmag(5*(i-1)+k,5*(j-1)+kk)>=Thres)   
       sumg=sumg+1;
      end 
     end
    end    
    IntenseMean(imageTotalBlockNumber)=sumI/25.;
    above_thres(imageTotalBlockNumber)=sumg/25.;
    %variance
    for k=1:5   
     for kk=1:5
     sum_s2=sum_s2+(a(5*(i-1)+k,5*(j-1)+kk)-IntenseMean(imageTotalBlockNumber))^2.;
     end
    end
    std2(imageTotalBlockNumber)=sqrt(sum_s2/25.);
   elseif(divisionRemainderAxis1~=0&divisionRemainderAxis2==0)   
     color=zeros(divisionRemainderAxis1,5);   
     red=c1(5*(i-1)+(1:divisionRemainderAxis1),5*(j-1)+(1:5),1);
     green=c1(5*(i-1)+(1:divisionRemainderAxis1),5*(j-1)+(1:5),2);
     blue=c1(5*(i-1)+(1:divisionRemainderAxis1),5*(j-1)+(1:5),3);
     if(red(:)==255&green(:)==0&blue(:)==0)
      color(:)=1;
     elseif((red(:)==0&green(:)==0&blue(:)==255))
      color(:)=2;
     else
      color(:)=3; 
     end  
     col(imageTotalBlockNumber)=mode(mode(color));
    %homogeneity
    homo=cc(5*(i-1)+(1:divisionRemainderAxis1),5*(j-1)+(1:5));
    homo1=graycoprops(graycomatrix(homo),{'Homogeneity','Energy'});
    homogen(imageTotalBlockNumber)=homo1.Homogeneity;   
    energ(imageTotalBlockNumber)=homo1.Energy;
    %mean intensity, gradient above threshold   
    for k=1:divisionRemainderAxis1
     for kk=1:5
      sumI=sumI+a(5*(i-1)+k,5*(j-1)+kk);
      if(gmag(5*(i-1)+k,5*(j-1)+kk)>=Thres)   
       sumg=sumg+1;
      end 
     end
    end
    IntenseMean(imageTotalBlockNumber)=sumI/(divisionRemainderAxis1*5.);
    above_thres(imageTotalBlockNumber)=sumg/(divisionRemainderAxis1*5.); 
    %variance
    for k=1:divisionRemainderAxis1   
     for kk=1:5
     sum_s2=sum_s2+(a(5*(i-1)+k,5*(j-1)+kk)-IntenseMean(imageTotalBlockNumber))^2.; 
     end
    end
    std2(imageTotalBlockNumber)=sqrt(sum_s2/(divisionRemainderAxis1*5.));  
   elseif(divisionRemainderAxis1==0&divisionRemainderAxis2~=0) 
     color=zeros(5,divisionRemainderAxis2);   
     red=c1(5*(i-1)+(1:5),5*(j-1)+(1:divisionRemainderAxis2),1);
     green=c1(5*(i-1)+(1:5),5*(j-1)+(1:divisionRemainderAxis2),2);
     blue=c1(5*(i-1)+(1:5),5*(j-1)+(1:divisionRemainderAxis2),3);
     if(red(:)==255&green(:)==0&blue(:)==0)
      color(:)=1;
     elseif((red(:)==0&green(:)==0&blue(:)==255))
      color(:)=2;
     else
      color(:)=3; 
     end  
     col(imageTotalBlockNumber)=mode(mode(color));
    %homogeneity
    homo=cc(5*(i-1)+(1:5),5*(j-1)+(1:divisionRemainderAxis2));
    homo1=graycoprops(graycomatrix(homo),{'Homogeneity','Energy'});
    homogen(imageTotalBlockNumber)=homo1.Homogeneity;   
    energ(imageTotalBlockNumber)=homo1.Energy;
    %mean intensity, gradient above threshold    
    for k=1:5
      for kk=1:divisionRemainderAxis2
       sumI=sumI+a(5*(i-1)+k,5*(j-1)+kk);
       if(gmag(5*(i-1)+k,5*(j-1)+kk)>=Thres)   
        sumg=sumg+1;
       end 
      end
    end
    IntenseMean(imageTotalBlockNumber)=sumI/(divisionRemainderAxis2*5.);
    above_thres(imageTotalBlockNumber)=sumg/(divisionRemainderAxis2*5.);   
    %variance
    for k=1:5   
     for kk=1:divisionRemainderAxis2
     sum_s2=sum_s2+(a(5*(i-1)+k,5*(j-1)+kk)-IntenseMean(imageTotalBlockNumber))^2.; 
     end
    end
    std2(imageTotalBlockNumber)=sqrt(sum_s2/(divisionRemainderAxis2*5.));
   elseif(divisionRemainderAxis1~=0&divisionRemainderAxis2~=0)                                   
     color=zeros(divisionRemainderAxis1,divisionRemainderAxis2);   
     red=c1(5*(i-1)+(1:divisionRemainderAxis1),5*(j-1)+(1:divisionRemainderAxis2),1);
     green=c1(5*(i-1)+(1:divisionRemainderAxis1),5*(j-1)+(1:divisionRemainderAxis2),2);
     blue=c1(5*(i-1)+(1:divisionRemainderAxis1),5*(j-1)+(1:divisionRemainderAxis2),3);
     if(red(:)==255&green(:)==0&blue(:)==0)
      color(:)=1;
     elseif((red(:)==0&green(:)==0&blue(:)==255))
      color(:)=2;
     else
      color(:)=3; 
     end 
     col(imageTotalBlockNumber)=mode(mode(color));     
     %homogeneity
     homo=cc(5*(i-1)+(1:divisionRemainderAxis1),5*(j-1)+(1:divisionRemainderAxis2));
     homo1=graycoprops(graycomatrix(homo),{'Homogeneity','Energy'});
     homogen(imageTotalBlockNumber)=homo1.Homogeneity;  
     energ(imageTotalBlockNumber)=homo1.Energy;
     %mean intensity, gradient above threshold   
     for k=1:divisionRemainderAxis1
      for kk=1:divisionRemainderAxis2
       sumI=sumI+a(5*(i-1)+k,5*(j-1)+kk);
       if(gmag(5*(i-1)+k,5*(j-1)+kk)>=Thres)   
        sumg=sumg+1;
       end 
      end
     end
     IntenseMean(imageTotalBlockNumber)=sumI/(divisionRemainderAxis1*divisionRemainderAxis2);
     above_thres(imageTotalBlockNumber)=sumg/(divisionRemainderAxis2*divisionRemainderAxis1);    
     %variance
     for k=1:divisionRemainderAxis1   
      for kk=1:divisionRemainderAxis2
      sum_s2=sum_s2+(a(5*(i-1)+k,5*(j-1)+kk)-IntenseMean(imageTotalBlockNumber))^2.; 
      end
     end
     std2(imageTotalBlockNumber)=sqrt(sum_s2/(divisionRemainderAxis1*divisionRemainderAxis2));  
   end
  end
  intenseMeanHelpVariable(i,j)=IntenseMean(imageTotalBlockNumber);
 end
end

%the mean difference of the mean brightnesses of blocks Bk in the
%4connected vicinity of the block Bi; relation 8 as described in the paper

for i=1:numberOfBlocksAxis1
for j=1:numberOfBlocksAxis2
 if(i==1&j==1) 
  meanDifference(i,j)=(abs(intenseMeanHelpVariable(i+1,j)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i,j+1)-intenseMeanHelpVariable(i,j)))/2;
 elseif(i==1&j==numberOfBlocksAxis2) 
  meanDifference(i,j)=(abs(intenseMeanHelpVariable(i+1,j)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i,j-1)-intenseMeanHelpVariable(i,j)))/2;
 elseif(i==numberOfBlocksAxis1&j==1) 
  meanDifference(i,j)=(abs(intenseMeanHelpVariable(i-1,j)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i,j+1)-intenseMeanHelpVariable(i,j)))/2;
 elseif(i==numberOfBlocksAxis1&j==numberOfBlocksAxis2) 
  meanDifference(i,j)=(abs(intenseMeanHelpVariable(i-1,j)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i,j-1)-intenseMeanHelpVariable(i,j)))/2;
 elseif(i==1&j>1&j<numberOfBlocksAxis2)     
  meanDifference(i,j)=(abs(intenseMeanHelpVariable(i,j-1)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i,j+1)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i+1,j)-intenseMeanHelpVariable(i,j)))/3;   
 elseif(i==numberOfBlocksAxis1&j>1&j<numberOfBlocksAxis2)
  meanDifference(i,j)=(abs(intenseMeanHelpVariable(i,j-1)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i,j+1)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i-1,j)-intenseMeanHelpVariable(i,j)))/3;
 elseif(j==1&(i>1&i<numberOfBlocksAxis1))  
  meanDifference(i,j)=(abs(intenseMeanHelpVariable(i-1,j)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i+1,j)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i,j+1)-intenseMeanHelpVariable(i,j)))/3;
 elseif(j==numberOfBlocksAxis2&i>1&i<numberOfBlocksAxis1) 
  meanDifference(i,j)=(abs(intenseMeanHelpVariable(i-1,j)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i+1,j)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i,j-1)-intenseMeanHelpVariable(i,j)))/3;
 else                            
  meanDifference(i,j)=(abs(intenseMeanHelpVariable(i-1,j)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i+1,j)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i,j-1)-intenseMeanHelpVariable(i,j))+abs(intenseMeanHelpVariable(i,j+1)-intenseMeanHelpVariable(i,j)))/4;
 end
end
end

% the mean vertical, dBy, and horizontal, dBx, derivatives of a block
% relation 9 as described in the paper

dIxy=zeros(numberOfBlocksAxis1,numberOfBlocksAxis2);
for i=1:numberOfBlocksAxis1
 for j=1:numberOfBlocksAxis2
  sum_dx=0;
  sum_dy=0;
  if(j==numberOfBlocksAxis2&divisionRemainderAxis2~=0&i<numberOfBlocksAxis1|(j==numberOfBlocksAxis2&divisionRemainderAxis2~=0&i==numberOfBlocksAxis1&divisionRemainderAxis1==0))
   %dIx   
   if(divisionRemainderAxis2==2)
    for k=1:5
     sum_dx=sum_dx+abs(a(5*(i-1)+k,5*(j-1)+1)-a(5*(i-1)+k,5*(j-1)+2));
    end
    count_dx=5;
   elseif(divisionRemainderAxis2==3)
    for k=1:5   
    sum_dx=sum_dx+abs(a(5*(i-1)+k,5*(j-1)+1)-a(5*(i-1)+k,5*(j-1)+2))+(abs(a(5*(i-1)+k,5*(j-1)+1)-a(5*(i-1)+k,5*(j-1)+2))+abs(a(5*(i-1)+k,5*(j-1)+2)-a(5*(i-1)+k,5*(j-1)+3)))/2+abs(a(5*(i-1)+k,5*(j-1)+2)-a(5*(i-1)+k,5*(j-1)+3));  
    end  
    count_dx=15;
   elseif(divisionRemainderAxis2==4)
    for k=1:5   
    sum_dx=sum_dx+abs(a(5*(i-1)+k,5*(j-1)+1)-a(5*(i-1)+k,5*(j-1)+2))+(abs(a(5*(i-1)+k,5*(j-1)+1)-a(5*(i-1)+k,5*(j-1)+2))+abs(a(5*(i-1)+k,5*(j-1)+2)-a(5*(i-1)+k,5*(j-1)+3)))/2+(abs(a(5*(i-1)+k,5*(j-1)+2)-a(5*(i-1)+k,5*(j-1)+3))+abs(a(5*(i-1)+k,5*(j-1)+3)-a(5*(i-1)+k,5*(j-1)+4)))/2+abs(a(5*(i-1)+k,5*(j-1)+3)-a(5*(i-1)+k,5*(j-1)+4));  
    end
    count_dx=20;
   end
   %dIy
   for kk=1:divisionRemainderAxis2
    for k=1:5 
     if(k==1)   
      sum_dy=sum_dy+abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k+1,5*(j-1)+kk));
     elseif(k==5)
      sum_dy=sum_dy+abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k-1,5*(j-1)+kk));
     else
      sum_dy=sum_dy+(abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k+1,5*(j-1)+kk))+abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k-1,5*(j-1)+kk)))/2.;
     end
    end
   end
   count_dy=divisionRemainderAxis2*5.;
  elseif(j==numberOfBlocksAxis2&divisionRemainderAxis2~=0&i==numberOfBlocksAxis1&divisionRemainderAxis1~=0)
   %dIx   
   if(divisionRemainderAxis2==2)
    for k=1:divisionRemainderAxis1
     sum_dx=sum_dx+abs(a(5*(i-1)+k,5*(j-1)+1)-a(5*(i-1)+k,5*(j-1)+2));
    end
    count_dx=divisionRemainderAxis1;
   elseif(divisionRemainderAxis2==3)
    for k=1:divisionRemainderAxis1   
    sum_dx=sum_dx+abs(a(5*(i-1)+k,5*(j-1)+1)-a(5*(i-1)+k,5*(j-1)+2))+(abs(a(5*(i-1)+k,5*(j-1)+1)-a(5*(i-1)+k,5*(j-1)+2))+abs(a(5*(i-1)+k,5*(j-1)+2)-a(5*(i-1)+k,5*(j-1)+3)))/2+abs(a(5*(i-1)+k,5*(j-1)+2)-a(5*(i-1)+k,5*(j-1)+3));  
    end  
    count_dx=divisionRemainderAxis1*3;
   elseif(divisionRemainderAxis2==4)
    for k=1:divisionRemainderAxis1   
    sum_dx=sum_dx+abs(a(5*(i-1)+k,5*(j-1)+1)-a(5*(i-1)+k,5*(j-1)+2))+(abs(a(5*(i-1)+k,5*(j-1)+1)-a(5*(i-1)+k,5*(j-1)+2))+abs(a(5*(i-1)+k,5*(j-1)+2)-a(5*(i-1)+k,5*(j-1)+3)))/2+(abs(a(5*(i-1)+k,5*(j-1)+2)-a(5*(i-1)+k,5*(j-1)+3))+abs(a(5*(i-1)+k,5*(j-1)+3)-a(5*(i-1)+k,5*(j-1)+4)))/2+abs(a(5*(i-1)+k,5*(j-1)+3)-a(5*(i-1)+k,5*(j-1)+4));  
    end
    count_dx=divisionRemainderAxis1*4;
   end    
   %dIy
   if(divisionRemainderAxis1==2)
     for kk=1:divisionRemainderAxis2
      sum_dy=sum_dy+abs(a(5*(i-1)+1,5*(j-1)+kk)-a(5*(i-1)+2,5*(j-1)+kk));
     end
     count_dy=divisionRemainderAxis2;
    elseif(divisionRemainderAxis1==3)
     for kk=1:divisionRemainderAxis2   
      sum_dy=sum_dy+abs(a(5*(i-1)+1,5*(j-1)+kk)-a(5*(i-1)+2,5*(j-1)+kk))+(abs(a(5*(i-1)+1,5*(j-1)+kk)-a(5*(i-1)+2,5*(j-1)+kk))+abs(a(5*(i-1)+2,5*(j-1)+kk)-a(5*(i-1)+3,5*(j-1)+kk)))/2+abs(a(5*(i-1)+2,5*(j-1)+kk)-a(5*(i-1)+3,5*(j-1)+kk));  
     end  
     count_dy=divisionRemainderAxis2*3;
    elseif(divisionRemainderAxis1==4)
     for kk=1:divisionRemainderAxis2   
      sum_dy=sum_dy+abs(a(5*(i-1)+1,5*(j-1)+kk)-a(5*(i-1)+2,5*(j-1)+kk))+(abs(a(5*(i-1)+1,5*(j-1)+kk)-a(5*(i-1)+2,5*(j-1)+kk))+abs(a(5*(i-1)+2,5*(j-1)+kk)-a(5*(i-1)+3,5*(j-1)+kk)))/2+(abs(a(5*(i-1)+2,5*(j-1)+kk)-a(5*(i-1)+3,5*(j-1)+kk))+abs(a(5*(i-1)+3,5*(j-1)+kk)-a(5*(i-1)+4,5*(j-1)+kk)))/2+abs(a(5*(i-1)+3,5*(j-1)+kk)-a(5*(i-1)+4,5*(j-1)+kk));  
     end
     count_dy=divisionRemainderAxis2*4;
    end 
  elseif(i==numberOfBlocksAxis1&divisionRemainderAxis1~=0&j<numberOfBlocksAxis2|(i==numberOfBlocksAxis1&divisionRemainderAxis1~=0&j==numberOfBlocksAxis2&divisionRemainderAxis2==0)) 
   %dIx   
   for k=1:divisionRemainderAxis1   
     for kk=1:5
      if(kk==1)   
       sum_dx=sum_dx+abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k,5*(j-1)+kk+1));
      elseif(kk==5)
       sum_dx=sum_dx+abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k,5*(j-1)+kk-1));
      else 
       sum_dx=sum_dx+(abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k,5*(j-1)+kk-1))+abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k,5*(j-1)+kk+1)))/2.;
      end 
     end
   end
   count_dx=divisionRemainderAxis1*5;
   %dIy
   if(divisionRemainderAxis1==2)
    for kk=1:5
     sum_dy=sum_dy+abs(a(5*(i-1)+1,5*(j-1)+kk)-a(5*(i-1)+2,5*(j-1)+kk));
    end
    count_dy=5;
   elseif(divisionRemainderAxis1==3)
    for kk=1:5   
     sum_dy=sum_dy+abs(a(5*(i-1)+1,5*(j-1)+kk)-a(5*(i-1)+2,5*(j-1)+kk))+(abs(a(5*(i-1)+1,5*(j-1)+kk)-a(5*(i-1)+2,5*(j-1)+kk))+abs(a(5*(i-1)+2,5*(j-1)+kk)-a(5*(i-1)+3,5*(j-1)+kk)))/2+abs(a(5*(i-1)+2,5*(j-1)+kk)-a(5*(i-1)+3,5*(j-1)+kk));  
    end  
    count_dy=15;
   elseif(divisionRemainderAxis1==4)
    for kk=1:5   
     sum_dy=sum_dy+abs(a(5*(i-1)+1,5*(j-1)+kk)-a(5*(i-1)+2,5*(j-1)+kk))+(abs(a(5*(i-1)+1,5*(j-1)+kk)-a(5*(i-1)+2,5*(j-1)+kk))+abs(a(5*(i-1)+2,5*(j-1)+kk)-a(5*(i-1)+3,5*(j-1)+kk)))/2+(abs(a(5*(i-1)+2,5*(j-1)+kk)-a(5*(i-1)+3,5*(j-1)+kk))+abs(a(5*(i-1)+3,5*(j-1)+kk)-a(5*(i-1)+4,5*(j-1)+kk)))/2+abs(a(5*(i-1)+3,5*(j-1)+kk)-a(5*(i-1)+4,5*(j-1)+kk));  
    end
    count_dy=20;
   end  
  else
   %dIx   
   for k=1:5   
     for kk=1:5
      if(kk==1)   
       sum_dx=sum_dx+abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k,5*(j-1)+kk+1));
      elseif(kk==5)
       sum_dx=sum_dx+abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k,5*(j-1)+kk-1));
      else 
       sum_dx=sum_dx+(abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k,5*(j-1)+kk-1))+abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k,5*(j-1)+kk+1)))/2.;
      end 
     end
   end
   count_dx=25;
   %dIy
   for kk=1:5   
     for k=1:5
      if(k==1)   
       sum_dy=sum_dy+abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k+1,5*(j-1)+kk));
      elseif(k==5)
       sum_dy=sum_dy+abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k-1,5*(j-1)+kk));
      else 
       sum_dy=sum_dy+(abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k-1,5*(j-1)+kk))+abs(a(5*(i-1)+k,5*(j-1)+kk)-a(5*(i-1)+k+1,5*(j-1)+kk)))/2.;
      end 
     end
   end
   count_dy=25;
  end
  dIxy(i,j)=(sum_dx+sum_dy)/(count_dx+count_dy);
 end
end  
%
%
imageBlockCounter=0;
for i=1:numberOfBlocksAxis1
 for j=1:numberOfBlocksAxis2
  imageBlockCounter=imageBlockCounter+1;
  dIxy_column(imageBlockCounter)=dIxy(i,j);      
  mesodif_column(imageBlockCounter)=meanDifference(i,j);
 end
end
classes=col;
characteristics=[IntenseMean mesodif_column dIxy_column above_thres homogen energ std2];  
newCharacteristics=[initialFeatureVector;characteristics];
classesnew=[initializeClasses;classes];
initializeClasses=classesnew;
initialFeatureVector=newCharacteristics;
end
save('results','newCharacteristics','classesnew');