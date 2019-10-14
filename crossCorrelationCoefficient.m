% This function calculates the cross-correlation coefficient between elements i and j as described
% in the Pattern Recognition book in page 283 relation 5.29

% x is the feature matrix Nx7 dimension
% N is the total number of feature elements
 
function [r]= rij(x,N,i,j)
tot1=0;
tot2=0;
tot3=0;
for ii=2:N
 tot1=tot1+x(ii,i)*x(ii,j);
 tot2=tot2+x(ii,i)*x(ii,i);
 tot3=tot3+x(ii,j)*x(ii,j);
end
r=tot1/sqrt(tot2*tot3);
return