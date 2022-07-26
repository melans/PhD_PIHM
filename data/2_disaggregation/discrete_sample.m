function [S]=discrete_sample(T,N)
% T is the probability table, the first column is the value and the second
% for the probability
% N is the sample size, S is the sample


%T=[1 2 3 4 5;0.7,0,0.1,0,0.2];
%T=T';
%N=1000;

[Y I]=sort(T(:,2),1,'ascend');
C=[I Y];


Y_cumulative(1)=Y(1);
for i=2:length(T(:,2))
       Y_cumulative(i)=Y_cumulative(i-1)+Y(i);
end

D=[I,Y_cumulative'];

% generate the random number 
rand('state',10);
R= rand(N,1);

NN=1./(N+1):1./(N+1):N./(N+1);
NN=NN';
LHS=[NN R];
[YY II]=sort(R,1,'ascend');

%reshuffle the random number array
for i=1:N
    New_R(i)=NN(II(i));
end

for i=1:N 
    
    j=1;
    while New_R(i)>Y_cumulative(j)
         
        j=j+1;
    end
    S(i)=T(I(j),1);  
end