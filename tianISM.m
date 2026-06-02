close all;
clear;
clc

%计算可达矩阵%
A=xlsread('adjacency_matrix.xlsx'); %读入邻接矩阵
n=size(A);
E=eye(n);
R=A+E;
k=0;
while 1
   Rnew=R*(A+E)>0;
   if isequal(R,Rnew);
       k=k+1;
break;
   end
   R=Rnew;
   k=k+1;
end
disp(Rnew);
A=Rnew;

%级别划分
r=2;
M=zeros(n);
while(~isequal(A,M))
%区域划分%
    for i=1:n
        P=find(A(i,:));
        Q=find(A(:,i));
        S=intersect(P,Q);
        if(~isempty(P)&&~isempty(Q)&&(length(P)==length(S)))
            disp('第r级：')
            disp(r)
            disp('元素为：')
            disp(i)
            A(i,i)=0;  
        end
    end
    for j=1:n
        if A(j,j)==0
            A(j,:)=0;
            A(:,j)=0;
        end 
    end
r=r+1;
end
